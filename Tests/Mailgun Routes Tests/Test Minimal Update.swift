import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Routes
import Testing

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Test Minimal Update",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct TestMinimalUpdate {
    
    @Test("Update only priority")
    func testUpdatePriorityOnly() async throws {
        @Dependency(Mailgun.Routes.self) var routes
        
        // Create a route
        let testEmail = "minimal-\(UUID().uuidString.prefix(8))@example.com"
        let createRequest = Mailgun.Routes.Create.Request(
            priority: 10,
            description: "Keep this description",
            expression: "match_recipient('\(testEmail)')",
            action: ["stop()"]
        )
        
        let createResponse = try await routes.client.create(createRequest)
        let routeId = createResponse.route.id
        
        // Update ONLY priority - send minimal request
        let updateRequest = Mailgun.Routes.Update.Request(
            id: routeId,
            priority: 99,
            description: nil,
            expression: nil,
            action: nil
        )
        
        let updateResponse = try await routes.client.update(routeId, updateRequest)
        print("Update message: \(updateResponse.message)")
        
        // Verify the change
        let getResponse = try await routes.client.get(routeId)
        print("Priority after update: \(getResponse.route.priority)")
        print("Description after update: \(getResponse.route.description)")
        
        #expect(getResponse.route.priority == 99, "Priority should be updated to 99")
        #expect(getResponse.route.description == "Keep this description", "Description should remain unchanged")
        
        // Clean up
        _ = try? await routes.client.delete(routeId)
    }
}
