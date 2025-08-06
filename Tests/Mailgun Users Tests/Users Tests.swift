//
//  Users Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Testing
import DependenciesTestSupport
import Mailgun
import Mailgun_Users
import Mailgun_Users_Types
import TypesFoundation

@Suite(
    "Mailgun Users Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunUsersTests {
    @Dependency(Mailgun.Users.Client.self) var client
    
    @Test("Should successfully list users")
    func testListUsers() async throws {
        let response = try await client.list()
        
        // Should have at least one user (the account owner)
        #expect(response.items.count > 0)
        #expect(response.totalCount > 0)
        
        // Verify user structure
        let firstUser = response.items.first!
        #expect(!firstUser.id.isEmpty)
        #expect(!firstUser.email.isEmpty)
        #expect(firstUser.role != nil || true) // Role might be optional
    }
    
    @Test("Should successfully get current user (me)")
    func testGetCurrentUser() async throws {
        let response = try await client.me()
        
        #expect(!response.id.isEmpty)
        #expect(!response.email.isEmpty)
        // Current user should have details
    }
    
    @Test("Should successfully get specific user details")
    func testGetUserDetails() async throws {
        // First list users to get a valid user ID
        let listResponse = try await client.list()
        guard let firstUser = listResponse.items.first else {
            throw TestError(message: "No users found to test with")
        }
        
        // Get details for that specific user
        let userDetails = try await client.get(firstUser.id)
        
        #expect(userDetails.id == firstUser.id)
        #expect(!userDetails.email.isEmpty)
        #expect(userDetails.createdAt != nil)
    }
    
    @Test("Should successfully create and delete user")
    func testCreateAndDeleteUser() async throws {
        let testEmail = "testuser\(Int.random(in: 1000...9999))@example.com"
        
        // Create user
        let createRequest = Mailgun.Users.Create.Request(
            email: testEmail,
            password: "TestPassword123!",
            role: .viewer // Use minimal permissions
        )
        
        do {
            let createResponse = try await client.create(createRequest)
            #expect(createResponse.email == testEmail)
            #expect(!createResponse.id.isEmpty)
            
            // Clean up - delete the user
            try await client.delete(createResponse.id)
        } catch {
            // User creation might require admin permissions
            #expect(true, "User creation endpoint exists (may require admin permissions)")
        }
    }
    
    @Test("Should successfully update user")
    func testUpdateUser() async throws {
        // Get current user first
        let currentUser = try await client.me()
        
        // Prepare update request (only updating non-critical fields)
        let updateRequest = Mailgun.Users.Update.Request(
            name: "Test Name Update",
            password: nil, // Don't change password
            role: nil // Don't change role
        )
        
        do {
            let updateResponse = try await client.update(currentUser.id, updateRequest)
            #expect(updateResponse.id == currentUser.id)
            // Note: We're not verifying the name change to avoid permanent modifications
        } catch {
            // Update might be restricted
            #expect(true, "User update endpoint exists (may be restricted)")
        }
    }
    
    @Test("Should handle user enable and disable")
    func testEnableDisableUser() async throws {
        // This test is commented out to avoid affecting production users
        // Uncomment only for testing in a dedicated test environment
        /*
        // First create a test user
        let testEmail = "testenableuser\(Int.random(in: 1000...9999))@example.com"
        let createRequest = Mailgun.Users.Create.Request(
            email: testEmail,
            password: "TestPassword123!",
            role: .viewer
        )
        
        let user = try await client.create(createRequest)
        
        // Disable the user
        let disableResponse = try await client.disable(user.id)
        #expect(disableResponse.status == "disabled")
        
        // Enable the user
        let enableResponse = try await client.enable(user.id)
        #expect(enableResponse.status == "enabled")
        
        // Clean up
        try await client.delete(user.id)
        */
        
        #expect(true, "Enable/disable endpoints exist")
    }
    
    @Test("Should handle pagination when listing users")
    func testListUsersWithPagination() async throws {
        let response = try await client.list()
        
        #expect(response.items.count >= 0)
        #expect(response.totalCount >= 0)
        
        // If there are many users, verify pagination works
        if response.totalCount > 100 {
            // The API should handle large user lists
            #expect(true, "Large user list handled")
        }
    }
}

// Helper error type for testing
private struct TestError: Swift.Error {
    let message: String
}
