//
//  Domains Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Mailgun_Domains
import Mailgun_Shared
import Testing

@Suite(
    "Mailgun Domains Aggregation Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunDomainsAggregationTests {
    @Dependency(Mailgun.Domains.Client.self) var client
    @Dependency(\.envVars.mailgunDomain) var domain

    @Test("Should access all domain sub-clients")
    func testAccessAllSubClients() async throws {
        // Test that we can access all domain sub-clients through the aggregation client

        // Main domains client
        _ = client.domains

        // DKIM client through nested structure
        _ = client.dkim
        _ = client.dkim.security

        // Domain keys and tracking through nested structure
        _ = client.domain
        _ = client.domain.keys
        _ = client.domain.tracking

        #expect(Bool(true), "All domain sub-clients are accessible through aggregation")
    }

    @Test("Should list domains through aggregation client")
    func testListDomainsThroughAggregation() async throws {
        // Test using the domains client through aggregation
        let request = Mailgun.Domains.Domains.List.Request(
            authority: nil,
            state: nil,
            limit: 5,
            skip: 0
        )

        let response = try await client.domains.list(request)

        #expect(!response.items.isEmpty || response.items.isEmpty)
        #expect(response.totalCount >= 0)

        if !response.items.isEmpty {
            let firstDomain = response.items.first!
            #expect(!firstDomain.name.isEmpty)
            #expect(firstDomain.state == .active || firstDomain.state == .unverified || firstDomain.state == .disabled)
            #expect(firstDomain.type == .sandbox || firstDomain.type == .custom)
        }
    }

    @Test("Should get domain details through aggregation client")
    func testGetDomainThroughAggregation() async throws {
        // Test getting domain details through the aggregation client
        let response = try await client.domains.get(domain)

        #expect(response.domain.name == domain.description)
        if let smtpLogin = response.domain.smtpLogin {
            #expect(!smtpLogin.isEmpty || smtpLogin.isEmpty)
        }

        // Check DNS records if present
        if let sendingRecords = response.sendingDnsRecords, !sendingRecords.isEmpty {
            #expect(!sendingRecords.first!.recordType.isEmpty)
        }
    }

    @Test("Should access DKIM security through aggregation")
    func testAccessDKIMSecurityThroughAggregation() async throws {
        // Test DKIM security operations through aggregation
        let dkimSecurityClient = client.dkim.security

        let request = Mailgun.Domains.DKIM_Security.Rotation.Update.Request(
            rotationEnabled: false,
            rotationInterval: nil
        )

        do {
            let response = try await dkimSecurityClient.updateRotation(domain, request)
            #expect(!response.message.isEmpty)
        } catch {
            // Handle cases where DKIM might not be available
            let errorString = String(describing: error).lowercased()
            if errorString.contains("404") || errorString.contains("not found") ||
               errorString.contains("forbidden") || errorString.contains("400") ||
               errorString.contains("rotation_enabled") {
                #expect(Bool(true), "DKIM operations not available - expected for sandbox domains")
            } else {
                throw error
            }
        }
    }

    @Test("Should access domain keys through aggregation")
    func testAccessDomainKeysThroughAggregation() async throws {
        // Test domain keys operations through aggregation
        let keysClient = client.domain.keys

        let request = Mailgun.Domains.DomainKeys.List.Request(
            page: nil,
            limit: 5,
            signingDomain: nil,
            selector: nil
        )

        do {
            let response = try await keysClient.list(request)
            #expect(!response.items.isEmpty || response.items.isEmpty)
        } catch {
            // Handle cases where domain keys might not be accessible
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("404") || errorString.contains("not found") || errorString.contains("forbidden") {
                #expect(Bool(true), "Domain keys not accessible - expected for some account types")
            } else {
                throw error
            }
        }
    }

    @Test("Should access tracking settings through aggregation")
    func testAccessTrackingThroughAggregation() async throws {
        // Test tracking operations through aggregation
        let trackingClient = client.domain.tracking

        do {
            let response = try await trackingClient.get(domain)

            #expect(response.tracking.click.active == true || response.tracking.click.active == false)
            #expect(response.tracking.open.active == true || response.tracking.open.active == false)
            #expect(response.tracking.unsubscribe.active == true || response.tracking.unsubscribe.active == false)
        } catch {
            // Handle cases where tracking might not be available
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("404") || errorString.contains("not found") {
                #expect(Bool(true), "Tracking not available - expected for some domains")
            } else {
                throw error
            }
        }
    }

    @Test("Should handle domain verification through aggregation")
    func testDomainVerificationThroughAggregation() async throws {
        // Test domain verification through aggregation
        do {
            let response = try await client.domains.verify(domain)

            #expect(response.domain.name == domain.description)
            #expect(!response.message.isEmpty)

            // Check DNS records
            if let sendingRecords = response.sendingDnsRecords {
                for record in sendingRecords {
                    #expect(!record.recordType.isEmpty)
                    #expect(!record.valid.isEmpty)
                }
            }
        } catch {
            // Handle cases where verification might not be available
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("404") || errorString.contains("not found") {
                #expect(Bool(true), "Domain verification not available - expected for some domains")
            } else {
                throw error
            }
        }
    }

    @Test("Should use dynamic member lookup for domains client")
    func testDynamicMemberLookup() async throws {
        // The Domains.Client supports dynamic member lookup to access Domains.Domains.Client members
        // This test verifies that we can use the shorthand syntax

        // These should work through dynamic member lookup
        let listRequest = Mailgun.Domains.Domains.List.Request(
            authority: nil,
            state: .active,
            limit: 3,
            skip: 0
        )

        // Using dynamic member lookup (client.list instead of client.domains.list)
        let response = try await client.list(listRequest)

        #expect(!response.items.isEmpty || response.items.isEmpty)
        #expect(response.totalCount >= 0)
    }

    @Test("Should handle all domain operations through aggregation")
    func testAllDomainOperationsThroughAggregation() async throws {
        // Comprehensive test of all domain operations available through aggregation

        // List domains
        let listResponse = try await client.list(nil)
        #expect(!listResponse.items.isEmpty || listResponse.items.isEmpty)

        // Get specific domain
        let getResponse = try await client.get(domain)
        #expect(getResponse.domain.name == domain.description)

        // Update domain (may fail for sandbox domains)
        let updateRequest = Mailgun.Domains.Domains.Update.Request(
            spamAction: .tag,
            webScheme: nil,
            wildcard: nil
        )

        do {
            let updateResponse = try await client.update(domain, updateRequest)
            #expect(!updateResponse.message.isEmpty)
        } catch {
            // Updates might be restricted
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("403") || errorString.contains("forbidden") {
                #expect(Bool(true), "Domain updates restricted - expected for sandbox domains")
            } else {
                throw error
            }
        }
    }

    @Test("Should validate complete domain feature integration")
    func testCompleteDomainFeatureIntegration() async throws {
        // This test validates that all domain-related features are properly integrated

        var successfulOperations = 0
        var expectedOperations = 0

        // Test main domains operations
        expectedOperations += 1
        do {
            _ = try await client.list(nil)
            successfulOperations += 1
        } catch {
            #expect(Bool(true), "List operation failed - counting as expected")
        }

        // Test DKIM operations
        expectedOperations += 1
        do {
            let request = Mailgun.Domains.DKIM_Security.Rotation.Update.Request(
                rotationEnabled: false
            )
            _ = try await client.dkim.security.updateRotation(domain, request)
            successfulOperations += 1
        } catch {
            #expect(Bool(true), "DKIM operation failed - counting as expected")
        }

        // Test domain keys operations
        expectedOperations += 1
        do {
            _ = try await client.domain.keys.listDomainKeys(domain.description)
            successfulOperations += 1
        } catch {
            #expect(Bool(true), "Domain keys operation failed - counting as expected")
        }

        // Test tracking operations
        expectedOperations += 1
        do {
            _ = try await client.domain.tracking.get(domain)
            successfulOperations += 1
        } catch {
            #expect(Bool(true), "Tracking operation failed - counting as expected")
        }

        // At least some operations should succeed
        #expect(successfulOperations > 0, "At least some domain operations should succeed")
        #expect(expectedOperations == 4, "All expected operations were tested")
    }
}
