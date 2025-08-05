import Testing
import Dependencies
import Mailgun
import Mailgun_IPAllowlist
import Mailgun_IPAllowlist_Types
import TypesFoundation

@Suite(
    "Mailgun IPAllowlist Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunIPAllowlistTests {
    @Dependency(Mailgun.IPAllowlist.Client.self) var client
    
    @Test("Should successfully list IP allowlist entries")
    func testListIPAllowlist() async throws {
        let response = try await client.list(nil)
        
        // The allowlist might be empty, so we just check the structure
        #expect(response.items != nil)
        #expect(response.totalCount >= 0)
    }
    
    @Test("Should successfully add and remove IP from allowlist")
    func testAddAndRemoveIP() async throws {
        // Use a test IP address
        let testIP = "192.168.1.\(Int.random(in: 100...200))"
        
        // Add IP to allowlist
        let addRequest = Mailgun.IPAllowlist.Create.Request(
            ip: testIP
        )
        
        let addResponse = try await client.create(addRequest)
        #expect(addResponse.message.contains("Added") || addResponse.message.contains("created"))
        #expect(addResponse.ip == testIP)
        
        // List to verify it was added
        let listResponse = try await client.list(nil)
        let hasIP = listResponse.items.contains { $0.ip == testIP }
        #expect(hasIP, "Test IP should be in the allowlist")
        
        // Remove the IP
        let removeResponse = try await client.delete(testIP)
        #expect(removeResponse.message.contains("Removed") || removeResponse.message.contains("deleted"))
    }
    
    @Test("Should handle listing with limit parameter")
    func testListWithLimit() async throws {
        let request = Mailgun.IPAllowlist.List.Request(
            limit: 5
        )
        
        let response = try await client.list(request)
        
        // Check that response respects the limit
        if response.totalCount > 5 {
            #expect(response.items.count <= 5)
        }
    }
}