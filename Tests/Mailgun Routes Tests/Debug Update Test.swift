import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Routes
import Testing

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Debug Update Test",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct DebugUpdateTest {

    @Test("Debug update with all fields")
    func testDebugUpdate() async throws {
        @Dependency(Mailgun.Routes.self) var routes

        // Create a route first
        let testEmail = "debug-\(UUID().uuidString.prefix(8))@example.com"
        let createRequest = Mailgun.Routes.Create.Request(
            priority: 1,
            description: "Original",
            expression: "match_recipient('\(testEmail)')",
            action: ["stop()"]
        )

        let createResponse = try await routes.client.create(createRequest)
        let routeId = createResponse.route.id
        print("Created route: \(routeId)")
        print("Initial priority: \(createResponse.route.priority)")
        print("Initial description: \(createResponse.route.description)")
        print("Initial actions: \(createResponse.route.actions)")

        // Update with ALL fields
        let updateRequest = Mailgun.Routes.Update.Request(
            id: routeId,
            priority: 5,
            description: "UPDATED",
            expression: "match_recipient('\(testEmail)')",
            action: ["forward('https://example.com/webhook')"]
        )

        let updateResponse = try await routes.client.update(routeId, updateRequest)
        print("\nUpdate response:")
        print("Message: \(updateResponse.message)")
        print("Priority in response: \(updateResponse.priority)")
        print("Description in response: \(updateResponse.description)")
        print("Actions in response: \(updateResponse.actions)")

        // Fetch to verify
        let getResponse = try await routes.client.get(routeId)
        print("\nFetched after update:")
        print("Priority: \(getResponse.route.priority)")
        print("Description: \(getResponse.route.description)")
        print("Actions: \(getResponse.route.actions)")

        #expect(getResponse.route.priority == 5)
        #expect(getResponse.route.description == "UPDATED")
        #expect(getResponse.route.actions == ["forward('https://example.com/webhook')"])

        // Clean up
        _ = try? await routes.client.delete(routeId)
    }
}
