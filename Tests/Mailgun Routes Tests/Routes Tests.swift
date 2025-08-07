import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Routes
import Testing

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Routes Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct RoutesTests {
    
    @Test("Create a new route")
    func testCreateRoute() async throws {
        @Dependency(Mailgun.Routes.self) var routes
        
        let request = Mailgun.Routes.Create.Request(
            priority: 0,
            description: "Test route for SDK testing",
            expression: "match_recipient('test-\(UUID().uuidString.prefix(8))@example.com')",
            action: ["stop()"]
        )
        
        let response = try await routes.client.create(request)
        
        #expect(!response.route.id.isEmpty)
        #expect(response.route.priority == 0)
        #expect(response.route.description == request.description)
        #expect(response.route.expression == request.expression)
        #expect(response.route.actions == request.action)
        #expect(response.message.contains("created"))
        
        // Clean up
        _ = try? await routes.client.delete(response.route.id)
    }
    
    @Test("List all routes")
    func testListRoutes() async throws {
        @Dependency(Mailgun.Routes.self) var routes
        
        // First create a route to ensure we have at least one
        let createRequest = Mailgun.Routes.Create.Request(
            priority: 10,
            description: "Test route for listing",
            expression: "match_recipient('list-test-\(UUID().uuidString.prefix(8))@example.com')",
            action: ["stop()"]
        )
        
        let createResponse = try await routes.client.create(createRequest)
        let routeId = createResponse.route.id
        
        // Now list routes
        let listResponse = try await routes.client.list(nil, nil)
        
        #expect(listResponse.totalCount > 0)
        #expect(!listResponse.items.isEmpty)
        
        // Check if our created route is in the list
        let foundRoute = listResponse.items.first { $0.id == routeId }
        #expect(foundRoute != nil)
        
        // Test with pagination
        let paginatedResponse = try await routes.client.list(1, 0)
        #expect(paginatedResponse.items.count <= 1)
        
        // Clean up
        _ = try? await routes.client.delete(routeId)
    }
    
    @Test("Get a specific route")
    func testGetRoute() async throws {
        @Dependency(Mailgun.Routes.self) var routes
        
        // First create a route
        let createRequest = Mailgun.Routes.Create.Request(
            priority: 5,
            description: "Test route for getting",
            expression: "match_recipient('get-test-\(UUID().uuidString.prefix(8))@example.com')",
            action: ["forward('https://example.com/webhook')"]
        )
        
        let createResponse = try await routes.client.create(createRequest)
        let routeId = createResponse.route.id
        
        // Get the route
        let getResponse = try await routes.client.get(routeId)
        
        #expect(getResponse.route.id == routeId)
        #expect(getResponse.route.priority == 5)
        #expect(getResponse.route.description == createRequest.description)
        #expect(getResponse.route.expression == createRequest.expression)
        #expect(getResponse.route.actions == createRequest.action)
        
        // Clean up
        _ = try? await routes.client.delete(routeId)
    }
    
    @Test("Update an existing route")
    func testUpdateRoute() async throws {
        @Dependency(Mailgun.Routes.self) var routes
        
        // First create a route
        let testEmail = "update-test-\(UUID().uuidString.prefix(8))@example.com"
        let createRequest = Mailgun.Routes.Create.Request(
            priority: 1,
            description: "Original description",
            expression: "match_recipient('\(testEmail)')",
            action: ["stop()"]
        )
        
        let createResponse = try await routes.client.create(createRequest)
        let routeId = createResponse.route.id
        
        // Update the route - include expression to ensure update works
        let updateRequest = Mailgun.Routes.Update.Request(
            priority: 2,
            description: "Updated description",
            expression: "match_recipient('\(testEmail)')",  // Same expression
            action: ["forward('https://example.com/updated')"]
        )
        // Debug: Check what request is being generated
        // @Dependency(Mailgun.Routes.API.Router.self) var router
        // print("router.request(for: .update(id: routeId, request: updateRequest))", try router.request(for: .update(id: routeId, request: updateRequest)).debugDescription)
        
        let updateResponse = try await routes.client.update(routeId, updateRequest)
        print("updateResponse: \(updateResponse)")
        
        #expect(updateResponse.message.contains("updated"))
        #expect(updateResponse.id == routeId)
        
        // Get the route to verify it was actually updated
        let getResponse = try await routes.client.get(routeId)
        print("After GET - priority: \(getResponse.route.priority), description: \(getResponse.route.description)")
        
        #expect(getResponse.route.priority == 2)
        #expect(getResponse.route.description == "Updated description")
        #expect(getResponse.route.actions == ["forward('https://example.com/updated')"])
        
        // Clean up
        _ = try? await routes.client.delete(routeId)
    }
    
    @Test("Delete a route")
    func testDeleteRoute() async throws {
        @Dependency(Mailgun.Routes.self) var routes
        
        // First create a route
        let createRequest = Mailgun.Routes.Create.Request(
            priority: 3,
            description: "Route to be deleted",
            expression: "match_recipient('delete-test-\(UUID().uuidString.prefix(8))@example.com')",
            action: ["stop()"]
        )
        
        let createResponse = try await routes.client.create(createRequest)
        let routeId = createResponse.route.id
        
        // Delete the route
        let deleteResponse = try await routes.client.delete(routeId)
        
        #expect(deleteResponse.message.contains("deleted"))
        #expect(deleteResponse.id == routeId)
        
        // Verify it's deleted by trying to get it
        do {
            _ = try await routes.client.get(routeId)
            Issue.record("Route should not exist after deletion")
        } catch {
            // Expected error - route should not exist
        }
    }
    
    @Test("Match address to route")
    func testMatchRoute() async throws {
        @Dependency(Mailgun.Routes.self) var routes
        
        // Create a route with a specific pattern
        let testEmail = "match-test-\(UUID().uuidString.prefix(8))@example.com"
        let createRequest = Mailgun.Routes.Create.Request(
            priority: 0,
            description: "Route for matching test",
            expression: "match_recipient('\(testEmail)')",
            action: ["forward('https://example.com/match')"]
        )
        
        let createResponse = try await routes.client.create(createRequest)
        let routeId = createResponse.route.id
        
        // Test matching the exact address
        let matchResponse = try await routes.client.match(testEmail)
        
        #expect(matchResponse.route.id == routeId)
        #expect(matchResponse.route.description == createRequest.description)
        
        // Test non-matching address
        // Note: We use a domain that won't match existing catch-all patterns like .*@example.com
        let nonMatchingEmail = "nonexistent@nomatch-\(UUID().uuidString.prefix(8)).test"
        do {
            let nonMatchResponse = try await routes.client.match(nonMatchingEmail)
            
            // The Mailgun API returns an empty/default route when no match is found
            // Check if the route appears to be empty or a default placeholder
            if nonMatchResponse.route.id.isEmpty  || nonMatchResponse.route.description.isEmpty {
                // OK - API returned empty/default route for non-match
            } else {
                // There might be a catch-all route that matches this address
                // This is not necessarily an error, just log it
                print("Note: Address '\(nonMatchingEmail)' matched route: \(nonMatchResponse.route.id) - \(nonMatchResponse.route.description)")
                
                // Only fail if it matched our specific test route (which it shouldn't)
                if nonMatchResponse.route.id == routeId {
                    Issue.record("Non-matching address incorrectly matched our specific test route")
                }
            }
        } catch {
            // Also acceptable - some configurations might throw an error for non-matches
        }
        
        // Clean up
        _ = try? await routes.client.delete(routeId)
    }
    
    @Test("Create route with default priority")
    func testCreateRouteDefaultPriority() async throws {
        @Dependency(Mailgun.Routes.self) var routes
        
        // Create without specifying priority (should default to 0)
        let request = Mailgun.Routes.Create.Request(
            description: "Route with default priority",
            expression: "match_recipient('default-priority-\(UUID().uuidString.prefix(8))@example.com')",
            action: ["stop()"]
        )
        
        let response = try await routes.client.create(request)
        
        #expect(response.route.priority == 0)
        
        // Clean up
        _ = try? await routes.client.delete(response.route.id)
    }
    
    @Test("Create route with multiple actions")
    func testCreateRouteMultipleActions() async throws {
        @Dependency(Mailgun.Routes.self) var routes
        
        let request = Mailgun.Routes.Create.Request(
            priority: 1,
            description: "Route with multiple actions",
            expression: "match_recipient('multi-action-\(UUID().uuidString.prefix(8))@example.com')",
            action: [
                "forward('https://example.com/webhook1')",
                "forward('https://example.com/webhook2')",
                "stop()"
            ]
        )
        
        let response = try await routes.client.create(request)
        
        #expect(response.route.actions.count == 3)
        #expect(response.route.actions[0] == "forward('https://example.com/webhook1')")
        #expect(response.route.actions[1] == "forward('https://example.com/webhook2')")
        #expect(response.route.actions[2] == "stop()")
        
        // Clean up
        _ = try? await routes.client.delete(response.route.id)
    }
    
    @Test("Test route expressions")
    func testRouteExpressions() async throws {
        @Dependency(Mailgun.Routes.self) var routes
        
        // Test various expression types
        let expressions = [
            "match_recipient('.*@example.com')",  // Match all example.com
            "match_header('subject', 'Test')",     // Match subject header
            "catch_all()",                         // Catch all messages
            "match_recipient('user@example.com') and match_header('X-Priority', 'High')"  // Complex expression
        ]
        
        for (index, expression) in expressions.enumerated() {
            let request = Mailgun.Routes.Create.Request(
                priority: index,
                description: "Expression test \(index)",
                expression: expression,
                action: ["stop()"]
            )
            
            let response = try await routes.client.create(request)
            #expect(response.route.expression == expression)
            
            // Clean up
            _ = try? await routes.client.delete(response.route.id)
        }
    }
    
    @Test(
        "Delete all existing routes",
        .disabled("Used for manual cleanup after running tests.")
    )
    func deleteAllExistingRoutes() async throws {
        @Dependency(Mailgun.Routes.self) var routes
        
        let listResponse = try await routes.client.list(nil, nil)
        
        for route in listResponse.items {
            _ = try? await routes.client.delete(route.id)
        }
    }
}
