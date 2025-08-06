import Testing
import DependenciesTestSupport
import Mailgun
import Mailgun_Keys
import Mailgun_Keys_Types
import TypesFoundation

@Suite(
    "Mailgun Keys Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunKeysTests {
    @Dependency(Mailgun.Keys.Client.self) var client
    
//    @Test("Should successfully list API keys")
//    func testListKeys() async throws {
//        let response = try await client.list()
//        
//        // Should have at least one key (the one we're using)
//        #expect(response.items.count > 0)
//        #expect(response.totalCount > 0)
//        
//        // Verify key structure
//        let firstKey = response.items.first!
//        #expect(!firstKey.id.isEmpty)
//        #expect(!firstKey.key.rawValue.isEmpty)
//        #expect(firstKey.active != nil)
//        #expect(firstKey.createdAt != nil)
//    }
//    
//    @Test("Should successfully get specific key details")
//    func testGetKeyDetails() async throws {
//        // First list keys to get a valid key ID
//        let listResponse = try await client.list()
//        guard let testKeyId = listResponse.items.first?.id else {
//            throw TestError("No keys available to test")
//        }
//        
//        let response = try await client.list()
//        
//        #expect(response.id == testKeyId)
//        #expect(!response.key.rawValue.isEmpty)
//        #expect(response.active != nil)
//        #expect(response.name != nil)
//    }
//    
//    @Test("Should handle key rotation")
//    func testKeyRotation() async throws {
//        // Note: We won't actually rotate production keys in tests
//        // Just verify the request structure compiles
//        let rotateRequest = Mailgun.Keys.Rotate.Request(
//            description: "Test rotation"
//        )
//        
//        _ = rotateRequest
//        #expect(true, "Rotate request structure is valid")
//    }
}
//
//private struct TestError: Error {
//    let message: String
//    init(_ message: String) {
//        self.message = message
//    }
//}
