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
        let response = try await client.list()
        
        // The allowlist might be empty, so we just check the structure
        #expect(response.addresses != nil)
    }
    
    @Test("Should successfully add and remove IP from allowlist")
    func testAddAndRemoveIP() async throws {
        // Use a test IP address
        let testIP = "192.168.1.\(Int.random(in: 100...200))"
        let testDescription = "Test IP for automated tests"
        
        // Add IP to allowlist
        let addRequest = Mailgun.IPAllowlist.AddRequest(
            address: testIP,
            description: testDescription
        )
        
        let addResponse = try await client.add(addRequest)
        #expect(addResponse.message?.contains("added") == true || addResponse.message?.contains("success") == true || addResponse.message == nil)
        
        // List to verify it was added
        let listResponse = try await client.list()
        let hasIP = listResponse.addresses.contains { $0.ipAddress == testIP }
        #expect(hasIP, "Test IP should be in the allowlist")
        
        // Remove the IP
        let deleteRequest = Mailgun.IPAllowlist.DeleteRequest(address: testIP)
        let removeResponse = try await client.delete(deleteRequest)
        #expect(removeResponse.message?.contains("removed") == true || removeResponse.message?.contains("deleted") == true || removeResponse.message == nil)
    }
    
    @Test("Should handle updating IP allowlist entry")
    func testUpdateIPAllowlistEntry() async throws {
        let testIP = "10.0.0.\(Int.random(in: 100...200))"
        let initialDescription = "Initial description"
        let updatedDescription = "Updated description"
        
        // First add an IP
        let addRequest = Mailgun.IPAllowlist.AddRequest(
            address: testIP,
            description: initialDescription
        )
        _ = try await client.add(addRequest)
        
        // Update the description
        let updateRequest = Mailgun.IPAllowlist.UpdateRequest(
            address: testIP,
            description: updatedDescription
        )
        
        let updateResponse = try await client.update(updateRequest)
        #expect(updateResponse.message?.contains("updated") == true || updateResponse.message?.contains("success") == true || updateResponse.message == nil)
        
        // Clean up
        let deleteRequest = Mailgun.IPAllowlist.DeleteRequest(address: testIP)
        _ = try await client.delete(deleteRequest)
    }
}