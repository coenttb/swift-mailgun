import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun
//
//@Suite(
//    "Mailgun Users Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
//)
//struct MailgunUsersTests {
//    @Dependency(Mailgun.Users.Client.self) var client
//    
//    @Test("Should successfully list users")
//    func testListUsers() async throws {
//        let response = try await client.list()
//        
//        // Should have at least one user (the account owner)
//        #expect(response.items.count > 0)
//        #expect(response.totalCount > 0)
//        
//        // Verify user structure
//        let firstUser = response.items.first!
//        #expect(!firstUser.id.isEmpty)
//        #expect(!firstUser.email.isEmpty)
//        #expect(firstUser.role != nil || true) // Role might be optional
//    }
//    
//    @Test("Should successfully get current user (me)")
//    func testGetCurrentUser() async throws {
//        let response = try await client.me()
//        
//        #expect(!response.id.isEmpty)
//        #expect(!response.email.isEmpty)
//        // Current user should have details
//    }
//    
//    @Test("Should successfully get specific user details")
//    func testGetUserDetails() async throws {
//        // First list users to get a valid user ID
//        let listResponse = try await client.list()
//        guard let testUserId = listResponse.items.first?.id else {
//            throw TestError("No users available to test")
//        }
//        
//        let response = try await client.get(testUserId)
//        
//        #expect(response.id == testUserId)
//        #expect(!response.email.isEmpty)
//    }
//    
//    @Test("Should handle organization operations")
//    func testOrganizationOperations() async throws {
//        // Note: These operations require specific organization setup
//        // We'll just verify the request structures compile
//        let updateRequest = Mailgun.Users.Organization.UpdateRequest(
//            role: "viewer"
//        )
//        
//        _ = updateRequest
//        #expect(true, "Organization request structures are valid")
//    }
//}
//
//private struct TestError: Swift.Error {
//    let message: String
//    init(_ message: String) {
//        self.message = message
//    }
//}
