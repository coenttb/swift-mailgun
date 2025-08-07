import Dependencies
import DependenciesTestSupport
import Mailgun
import Testing
//
// @Suite(
//    "Mailgun IPPools Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
// )
// struct MailgunIPPoolsTests {
//    @Dependency(Mailgun.IPPools.self) var ipPools
//    
//    @Test("Should successfully list IP pools")
//    func testListIPPools() async throws {
//        let response = try await client.list()
//        
//        // Check response structure
//        #expect(response.ipPools != nil)
//        #expect(!response.message.isEmpty)
//    }
//    
//    @Test("Should successfully create and delete IP pool")
//    func testCreateAndDeleteIPPool() async throws {
//        let testPoolName = "test-pool-\(Int.random(in: 1000...9999))"
//        let testPoolDescription = "Test IP Pool for automated tests"
//        
//        // Create IP pool
//        let createRequest = Mailgun.IPPools.CreateRequest(
//            name: testPoolName,
//            description: testPoolDescription,
//            ips: []
//        )
//        
//        let createResponse = try await client.create(createRequest)
//        #expect(createResponse.message.contains("created") || createResponse.message.contains("Created"))
//        #expect(createResponse.poolId == testPoolName)
//        
//        // List to verify it was created
//        let listResponse = try await client.list()
//        let hasPool = listResponse.ipPools.contains { $0.name == testPoolName }
//        #expect(hasPool, "Test pool should be in the list")
//        
//        // Delete the pool
//        let deleteResponse = try await client.delete(testPoolName, nil)
//        #expect(deleteResponse.message.contains("deleted") || deleteResponse.message.contains("Deleted"))
//    }
//    
//    @Test("Should handle updating IP pool")
//    func testUpdateIPPool() async throws {
//        let testPoolName = "test-update-pool-\(Int.random(in: 1000...9999))"
//        
//        // First create a pool
//        let createRequest = Mailgun.IPPools.CreateRequest(
//            name: testPoolName,
//            description: "Initial description",
//            ips: []
//        )
//        
//        _ = try await client.create(createRequest)
//        
//        // Update the pool
//        let updateRequest = Mailgun.IPPools.UpdateRequest(
//            name: testPoolName,
//            description: "Updated description",
//            addIps: nil,
//            removeIps: nil
//        )
//        
//        let updateResponse = try await client.update(testPoolName, updateRequest)
//        #expect(updateResponse.message.contains("updated") || updateResponse.message.contains("Updated"))
//        
//        // Clean up
//        _ = try await client.delete(testPoolName, nil)
//    }
// }
