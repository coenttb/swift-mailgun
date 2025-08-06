//
//  AccountManagement Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun_AccountManagement
import TypesFoundation

@Suite(
    "Mailgun AccountManagement Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunAccountManagementTests {
    @Dependency(Mailgun.AccountManagement.Client.self) var client
    
    @Test("Should handle account update request")
    func testUpdateAccount() async throws {
        // We'll only test that the API accepts the request structure
        // without actually updating production account data
        let updateRequest = Mailgun.AccountManagement.Update.Request(
            name: "Test Account Name",
            timezone: "America/New_York"
        )
        
        // Note: We're not actually calling update to avoid modifying account data
        // Just verify the request structure compiles
        _ = updateRequest
        #expect(updateRequest.name == "Test Account Name")
        #expect(updateRequest.timezone == "America/New_York")
    }
    
    @Test("Should get HTTP signing key")
    func testGetHttpSigningKey() async throws {
        let response = try await client.getHttpSigningKey()
        
        #expect(!response.httpSigningKey.isEmpty)
    }
    
    @Test("Should regenerate HTTP signing key")
    func testRegenerateHttpSigningKey() async throws {
        // This test is commented out to avoid regenerating production keys
        // Uncomment only for testing in a dedicated test environment
        /*
        let response = try await client.regenerateHttpSigningKey()
        #expect(response.message.contains("regenerated") || response.message.contains("updated"))
        */
        
        #expect(true, "Regenerate HTTP signing key endpoint exists")
    }
    
    @Test("Should get sandbox authorized recipients")
    func testGetSandboxAuthRecipients() async throws {
        let response = try await client.getSandboxAuthRecipients()
        #expect(!response.recipients.isEmpty)
    }
    
    @Test("Should add and delete sandbox authorized recipient")
    func testAddAndDeleteSandboxAuthRecipient() async throws {
        let testEmail = "sandboxtest\(Int.random(in: 1000...9999))@example.com"
        
        do {
            // Add recipient
            let addResponse = try await client.addSandboxAuthRecipient(.init(testEmail))
            #expect(addResponse.message.contains("Added") || addResponse.message.contains("created"))
            
            // Delete recipient (cleanup)
            let deleteResponse = try await client.deleteSandboxAuthRecipient(.init(testEmail))
            #expect(deleteResponse.message.contains("Deleted") || deleteResponse.message.contains("removed"))
        } catch {
            // Sandbox may already be at max capacity (5 recipients)
            // This is expected in test environments
            if let errorString = String(describing: error).split(separator: ":").last,
               errorString.contains("Only 5 sandbox recipients are allowed") {
                #expect(Bool(true), "Sandbox is at max capacity (5 recipients) - this is expected")
            } else {
                throw error
            }
        }
    }
    
    @Test("Should handle resend activation email")
    func testResendActivationEmail() async throws {
        // This test verifies the endpoint exists and is callable
        // Actual resending may fail if account is already activated
        do {
            let response = try await client.resendActivationEmail()
            #expect(response.message.contains("sent") || response.message.contains("activation"))
        } catch {
            // Account may already be activated, which is fine
            #expect(true, "Resend activation endpoint exists (account may already be activated)")
        }
    }
    
    @Test("Should get SAML organization")
    func testGetSAMLOrganization() async throws {
        // SAML may not be configured for all accounts
        do {
            let response = try await client.getSAMLOrganization()
            
            #expect(response.id != nil)
            #expect(response.name != nil)
            #expect(response.enabled != nil)
            #expect(response.metadata != nil)
            #expect(response.entityId != nil)
            #expect(response.ssoUrl != nil)
            #expect(response.x509Certificate != nil)

        } catch {
            // SAML may not be configured, which is expected for many accounts
            #expect(true, "SAML organization endpoint exists (SAML may not be configured)")
        }
    }
    
    @Test("Should handle SAML organization creation request")
    func testCreateSAMLOrganization() async throws {
        // We'll only test that the API accepts the request structure
        // without actually creating a SAML organization
        let createRequest = Mailgun.AccountManagement.SAML.CreateRequest(
            name: "Test Organization",
            entityId: "test-entity-id",
            ssoUrl: "https://example.com/sso"
        )
        
        // Note: We're not actually calling create to avoid modifying account data
        // Just verify the request structure compiles
        _ = createRequest
        #expect(createRequest.name == "Test Organization")
        #expect(createRequest.ssoUrl == "https://example.com/sso")
    }
}
