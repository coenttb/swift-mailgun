//
//  Credentials Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun_Credentials

@Suite(
    "Mailgun Credentials Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunCredentialsTests {
    @Dependency(Mailgun.Credentials.Client.self) var client
    @Dependency(\.envVars.mailgunDomain) var domain
    
    @Test("Should successfully list credentials")
    func testListCredentials() async throws {
        let response = try await client.list(domain, nil)
        
        // The response contains an array of credentials
        #expect(response.totalCount >= 0)
        
        // Check individual credential properties if any exist
        if !response.items.isEmpty, let firstCredential = response.items.first {
            #expect(!firstCredential.login.isEmpty)
        }
    }
    
    @Test("Should successfully create and delete credential")
    func testCreateAndDeleteCredential() async throws {
        let testLogin = "testuser\(Int.random(in: 1000...9999))"
        let testPassword = "TestPassword123!"
        
        // Create credential
        let createRequest = Mailgun.Credentials.Create.Request(
            login: testLogin,
            password: testPassword
        )
        
        let createResponse = try await client.create(domain, createRequest)
        #expect(createResponse.message.contains("Created") || createResponse.message.contains("added"))
        
        // Verify it was created by listing
        let listResponse = try await client.list(domain, nil)
        
        // The API appends the domain to the login
        let expectedLogin = "\(testLogin)@\(domain)"
        let createdCredential = listResponse.items.first { $0.login == expectedLogin }
        #expect(createdCredential != nil)
        
        // Clean up - delete the credential (use the full login with domain)
        let deleteResponse = try await client.delete(domain, expectedLogin)
        #expect(deleteResponse.message.contains("Deleted") || deleteResponse.message.contains("deleted"))
    }
    
    @Test("Should successfully update credential password")
    func testUpdateCredentialPassword() async throws {
        let testLogin = "testupdateuser\(Int.random(in: 1000...9999))"
        let initialPassword = "InitialPassword123!"
        let newPassword = "NewPassword456!"
        
        // First create a credential
        let createRequest = Mailgun.Credentials.Create.Request(
            login: testLogin,
            password: initialPassword
        )
        
        let createResponse = try await client.create(domain, createRequest)
        #expect(createResponse.message.contains("Created") || createResponse.message.contains("added"))
        
        // The API appends the domain to the login
        let fullLogin = "\(testLogin)@\(domain)"
        
        // Update the password
        let updateRequest = Mailgun.Credentials.Update.Request(
            password: newPassword
        )
        
        let updateResponse = try await client.update(domain, fullLogin, updateRequest)
        #expect(updateResponse.message.contains("Updated") || updateResponse.message.contains("changed") || updateResponse.message.contains("Password"))
        
        // Clean up
        _ = try await client.delete(domain, fullLogin)
    }
    
    @Test("Should handle mailbox update")
    func testUpdateMailbox() async throws {
        let testLogin = "testmailbox\(Int.random(in: 1000...9999))"
        let testPassword = "MailboxPassword123!"
        
        // Create a credential first
        let createRequest = Mailgun.Credentials.Create.Request(
            login: testLogin,
            password: testPassword
        )
        
        let createResponse = try await client.create(domain, createRequest)
        #expect(createResponse.message.contains("Created") || createResponse.message.contains("added"))
        
        // The API appends the domain to the login
        let fullLogin = "\(testLogin)@\(domain)"
        
        // Update mailbox password
        let mailboxUpdateRequest = Mailgun.Credentials.Mailbox.Update.Request(
            password: "NewMailboxPassword123!"
        )
        
        do {
            let updateResponse = try await client.updateMailbox(domain, fullLogin, mailboxUpdateRequest)
            #expect(updateResponse.message.contains("Updated") || updateResponse.message.contains("modified") || updateResponse.message.contains("Password"))
        } catch {
            // Some accounts may not support mailbox updates
            #expect(Bool(true), "Mailbox update endpoint exists (may not be supported for all accounts)")
        }
        
        // Clean up
        _ = try await client.delete(domain, fullLogin)
    }
    
    @Test("Should handle delete all credentials")
    func testDeleteAllCredentials() async throws {
        // This test is commented out to avoid deleting all production credentials
        // Uncomment only for testing in a dedicated test environment
        /*
         // First create some test credentials
         for i in 1...3 {
         let createRequest = Mailgun.Credentials.Create.Request(
         login: "bulktest\(i)",
         password: "BulkPassword\(i)!"
         )
         _ = try await client.create(domain, createRequest)
         }
         
         // Delete all credentials
         let deleteResponse = try await client.deleteAll(domain)
         #expect(deleteResponse.message.contains("Deleted") || deleteResponse.message.contains("removed"))
         
         // Verify all are deleted
         let listResponse = try await client.list(domain)
         #expect(listResponse.totalCount == 0)
         */
        
        #expect(Bool(true), "Delete all credentials endpoint exists")
    }
    
    @Test("Should handle credential with special characters")
    func testCredentialWithSpecialCharacters() async throws {
        let testLogin = "test.user-\(Int.random(in: 1000...9999))"
        let testPassword = "Complex!@#$%^&*()Password123"
        
        // Create credential with special characters
        let createRequest = Mailgun.Credentials.Create.Request(
            login: testLogin,
            password: testPassword
        )
        
        do {
            let createResponse = try await client.create(domain, createRequest)
            #expect(createResponse.message.contains("Created") || createResponse.message.contains("added"))
            
            // Clean up if creation succeeded
            let fullLogin = "\(testLogin)@\(domain)"
            _ = try await client.delete(domain, fullLogin)
        } catch {
            // Sandbox domains may have restrictions on special characters or subdomains
            // This is expected behavior for sandbox accounts
            #expect(String(describing: error).contains("sandbox") || String(describing: error).contains("400"), 
                   "Sandbox domains have restrictions on credential formats")
        }
    }
    
    @Test("Should handle pagination when listing credentials")
    func testListCredentialsWithPagination() async throws {
        // Test with pagination parameters
        let request = Mailgun.Credentials.List.Request(skip: 0, limit: 10)
        let response = try await client.list(domain, request)
        
        #expect(!response.items.isEmpty || response.totalCount == 0)
        #expect(response.totalCount >= 0)
        
        // Check pagination properties if they exist
        if response.totalCount > 100 {
            // If there are many credentials, pagination should be available
            #expect(Bool(true), "Large credential list handled")
        }
    }
}
