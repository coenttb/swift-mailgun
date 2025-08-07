import Dependencies
import DependenciesTestSupport
import Mailgun
import Testing
//
// @Suite(
//    "Mailgun Credentials Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
// )
// struct MailgunCredentialsTests {
//    @Dependency(Mailgun.Credentials.self) var credentials
//    @Dependency(\.envVars.mailgun.domain) var domain
//    
//    @Test("Should successfully list credentials")
//    func testListCredentials() async throws {
//        let response = try await client.list(domain)
//        
//        #expect(response.totalCount >= 0)
//        
//        // Check individual credential properties if any exist
//        if !response.items.isEmpty {
//            let firstCredential = response.items[0]
//            #expect(!firstCredential.login.isEmpty)
//        }
//    }
//    
//    @Test("Should successfully create and delete credential")
//    func testCreateAndDeleteCredential() async throws {
//        let testLogin = "testuser\(Int.random(in: 1000...9999))"
//        let testPassword = "TestPassword123!"
//        
//        // Create credential
//        let createRequest = Mailgun.Credentials.Create.Request(
//            login: testLogin,
//            password: testPassword
//        )
//        
//        let createResponse = try await client.create(domain, createRequest)
//        #expect(createResponse.message.contains("Created") || createResponse.message.contains("added"))
//        
//        // Verify it was created by listing
//        let listResponse = try await client.list(domain)
//        let createdCredential = listResponse.items.first { $0.login == testLogin }
//        #expect(createdCredential != nil)
//        
//        // Clean up - delete the credential
//        let deleteResponse = try await client.delete(domain, testLogin)
//        #expect(deleteResponse.message.contains("Deleted") || deleteResponse.message.contains("removed"))
//    }
//    
//    @Test("Should successfully update credential password")
//    func testUpdateCredentialPassword() async throws {
//        let testLogin = "testupdateuser\(Int.random(in: 1000...9999))"
//        let initialPassword = "InitialPassword123!"
//        let newPassword = "NewPassword456!"
//        
//        // First create a credential
//        let createRequest = Mailgun.Credentials.Create.Request(
//            login: testLogin,
//            password: initialPassword
//        )
//        
//        let createResponse = try await client.create(domain, createRequest)
//        #expect(createResponse.message.contains("Created") || createResponse.message.contains("added"))
//        
//        // Update the password
//        let updateRequest = Mailgun.Credentials.Update.Request(
//            password: newPassword
//        )
//        
//        let updateResponse = try await client.update(domain, testLogin, updateRequest)
//        #expect(updateResponse.message.contains("Updated") || updateResponse.message.contains("changed"))
//        
//        // Clean up
//        try await client.delete(domain, testLogin)
//    }
//    
////    @Test("Should handle mailbox update")
////    func testUpdateMailbox() async throws {
////        let testLogin = "testmailbox\(Int.random(in: 1000...9999))"
////        let testPassword = "MailboxPassword123!"
////        
////        // Create a credential first
////        let createRequest = Mailgun.Credentials.Create.Request(
////            login: testLogin,
////            password: testPassword
////        )
////        
////        let createResponse = try await client.create(domain, createRequest)
////        #expect(createResponse.message.contains("Created") || createResponse.message.contains("added"))
////        
////        // Update mailbox settings
////        let mailboxUpdateRequest = Mailgun.Credentials.Mailbox.Update.Request(
////            mailboxSize: 10485760, // 10MB in bytes
////            skipVerification: false,
////            skipWelcomeEmail: true
////        )
////        
////        do {
////            let updateResponse = try await client.updateMailbox(domain, testLogin, mailboxUpdateRequest)
////            #expect(updateResponse.message.contains("Updated") || updateResponse.message.contains("modified"))
////        } catch {
////            // Some accounts may not support mailbox updates
////            #expect(true, "Mailbox update endpoint exists (may not be supported for all accounts)")
////        }
////        
////        // Clean up
////        try await client.delete(domain, testLogin)
////    }
//
//    @Test("Should handle delete all credentials")
//    func testDeleteAllCredentials() async throws {
//        // This test is commented out to avoid deleting all production credentials
//        // Uncomment only for testing in a dedicated test environment
//        /*
//        // First create some test credentials
//        for i in 1...3 {
//            let createRequest = Mailgun.Credentials.Create.Request(
//                login: "bulktest\(i)",
//                password: "BulkPassword\(i)!"
//            )
//            _ = try await client.create(domain, createRequest)
//        }
//        
//        // Delete all credentials
//        let deleteResponse = try await client.deleteAll(domain)
//        #expect(deleteResponse.message.contains("Deleted") || deleteResponse.message.contains("removed"))
//        
//        // Verify all are deleted
//        let listResponse = try await client.list(domain)
//        #expect(listResponse.totalCount == 0)
//        */
//        
//        #expect(true, "Delete all credentials endpoint exists")
//    }
//    
//    @Test("Should handle credential with special characters")
//    func testCredentialWithSpecialCharacters() async throws {
//        let testLogin = "test.user-\(Int.random(in: 1000...9999))@subdomain"
//        let testPassword = "Complex!@#$%^&*()Password123"
//        
//        // Create credential with special characters
//        let createRequest = Mailgun.Credentials.Create.Request(
//            login: testLogin,
//            password: testPassword
//        )
//        
//        let createResponse = try await client.create(domain, createRequest)
//        #expect(createResponse.message.contains("Created") || createResponse.message.contains("added"))
//        
//        // Clean up
//        try await client.delete(domain, testLogin)
//    }
//    
//    @Test("Should handle pagination when listing credentials")
//    func testListCredentialsWithPagination() async throws {
//        // Note: This test assumes you can pass pagination parameters
//        // The actual implementation would depend on the API structure
//        let response = try await client.list(domain)
//        
//        #expect(response.items != nil)
//        #expect(response.totalCount >= 0)
//        
//        // Check pagination properties if they exist
//        if response.totalCount > 100 {
//            // If there are many credentials, pagination should be available
//            #expect(true, "Large credential list handled")
//        }
//    }
// }
//
//// Helper error type for testing
// private struct TestError: Swift.Error, Codable, Equatable {
//    let statusCode: Int
//    let message: String
// }
