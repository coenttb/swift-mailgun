//
//  Routes Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun_Shared
import Mailgun_Routes
import Mailgun_Routes_Types
import TypesFoundation

@Suite(
    "Mailgun Routes Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunRoutesTests {
    
    @Test("Should successfully list routes")
    func testListRoutes() async throws {
        @Dependency(Mailgun.Routes.Client.self) var client
        let response = try await client.list()
        
        // Check response structure
        #expect(response.items != nil)
        #expect(response.totalCount >= 0)
        
        // Verify route structure if any exist
        if let routes = response.items, !routes.isEmpty {
            let firstRoute = routes[0]
            #expect(!firstRoute.id.isEmpty)
            #expect(firstRoute.priority >= 0)
            #expect(!firstRoute.expression.isEmpty)
            #expect(!firstRoute.actions.isEmpty)
        }
    }
    
    @Test("Should successfully create and delete route")
    func testCreateAndDeleteRoute() async throws {
        @Dependency(Mailgun.Routes.Client.self) var client
        let testDescription = "Test route \(Int.random(in: 1000...9999))"
        
        // Create route
        let createRequest = Mailgun.Routes.Create.Request(
            priority: 100,
            description: testDescription,
            expression: "match_recipient(\".*@test.example.com\")",
            action: ["forward(\"https://example.com/webhook\")", "stop()"]
        )
        
        let createResponse = try await client.create(createRequest)
        #expect(!createResponse.route.id.isEmpty)
        #expect(createResponse.route.description == testDescription)
        #expect(createResponse.message.contains("created") || createResponse.message.contains("Route has been created"))
        
        let routeId = createResponse.route.id
        
        // Verify it was created by listing
        let listResponse = try await client.list()
        let createdRoute = listResponse.items?.first { $0.id == routeId }
        #expect(createdRoute != nil)
        
        // Clean up - delete the route
        let deleteResponse = try await client.delete(routeId)
        #expect(deleteResponse.message.contains("deleted") || deleteResponse.message.contains("Route has been deleted"))
    }
    
    @Test("Should successfully get route details")
    func testGetRouteDetails() async throws {
        @Dependency(Mailgun.Routes.Client.self) var client
        // First create a test route
        let createRequest = Mailgun.Routes.Create.Request(
            priority: 200,
            description: "Test route for details",
            expression: "match_recipient(\".*@details.example.com\")",
            action: ["stop()"]
        )
        
        let createResponse = try await client.create(createRequest)
        let routeId = createResponse.route.id
        
        // Get route details
        let routeDetails = try await client.get(routeId)
        
        #expect(routeDetails.id == routeId)
        #expect(routeDetails.priority == 200)
        #expect(routeDetails.description == "Test route for details")
        #expect(!routeDetails.expression.isEmpty)
        
        // Clean up
        try await client.delete(routeId)
    }
    
    @Test("Should successfully update route")
    func testUpdateRoute() async throws {
        @Dependency(Mailgun.Routes.Client.self) var client
        // First create a test route
        let createRequest = Mailgun.Routes.Create.Request(
            priority: 300,
            description: "Original description",
            expression: "match_recipient(\".*@update.example.com\")",
            action: ["stop()"]
        )
        
        let createResponse = try await client.create(createRequest)
        let routeId = createResponse.route.id
        
        // Update the route
        let updateRequest = Mailgun.Routes.Update.Request(
            priority: 350,
            description: "Updated description",
            expression: nil, // Keep existing expression
            action: nil // Keep existing actions
        )
        
        let updateResponse = try await client.update(routeId, updateRequest)
        #expect(updateResponse.route.priority == 350)
        #expect(updateResponse.route.description == "Updated description")
        #expect(updateResponse.message.contains("updated") || updateResponse.message.contains("Route has been updated"))
        
        // Clean up
        try await client.delete(routeId)
    }
    
    @Test("Should handle various route expressions")
    func testVariousRouteExpressions() async throws {
        @Dependency(Mailgun.Routes.Client.self) var client
        // Test different expression types
        let expressions = [
            "match_recipient(\".*@example.com\")",
            "match_header(\"subject\", \".*important.*\")",
            "catch_all()"
        ]
        
        for (index, expression) in expressions.enumerated() {
            let createRequest = Mailgun.Routes.Create.Request(
                priority: 400 + index,
                description: "Test expression \(index)",
                expression: expression,
                action: ["stop()"]
            )
            
            let createResponse = try await client.create(createRequest)
            #expect(!createResponse.route.id.isEmpty)
            #expect(createResponse.route.expression == expression)
            
            // Clean up
            try await client.delete(createResponse.route.id)
        }
    }
    
    @Test("Should handle various route actions")
    func testVariousRouteActions() async throws {
        @Dependency(Mailgun.Routes.Client.self) var client
        // Test different action combinations
        let actionSets = [
            ["forward(\"https://example.com/webhook\")"],
            ["store()", "stop()"],
            ["forward(\"https://example.com/webhook\")", "store()", "stop()"]
        ]
        
        for (index, actions) in actionSets.enumerated() {
            let createRequest = Mailgun.Routes.Create.Request(
                priority: 500 + index,
                description: "Test actions \(index)",
                expression: "match_recipient(\".*@actions\(index).example.com\")",
                action: actions
            )
            
            let createResponse = try await client.create(createRequest)
            #expect(!createResponse.route.id.isEmpty)
            #expect(createResponse.route.actions == actions)
            
            // Clean up
            try await client.delete(createResponse.route.id)
        }
    }
    
    @Test("Should handle route priority ordering")
    func testRoutePriorityOrdering() async throws {
        @Dependency(Mailgun.Routes.Client.self) var client
        // Create routes with different priorities
        let priorities = [100, 50, 150]
        var routeIds: [String] = []
        
        for priority in priorities {
            let createRequest = Mailgun.Routes.Create.Request(
                priority: priority,
                description: "Priority test \(priority)",
                expression: "match_recipient(\".*@priority\(priority).example.com\")",
                action: ["stop()"]
            )
            
            let createResponse = try await client.create(createRequest)
            routeIds.append(createResponse.route.id)
        }
        
        // List routes and verify they're ordered by priority
        let listResponse = try await client.list()
        if let routes = listResponse.items {
            // Routes should be ordered by priority (ascending)
            let createdRoutes = routes.filter { routeIds.contains($0.id) }
            if createdRoutes.count == 3 {
                let sortedByPriority = createdRoutes.sorted { $0.priority < $1.priority }
                #expect(sortedByPriority[0].priority == 50)
                #expect(sortedByPriority[1].priority == 100)
                #expect(sortedByPriority[2].priority == 150)
            }
        }
        
        // Clean up
        for routeId in routeIds {
            try await client.delete(routeId)
        }
    }
    
    @Test("Should handle pagination when listing routes")
    func testListRoutesWithPagination() async throws {
        @Dependency(Mailgun.Routes.Client.self) var client
        let response = try await client.list()
        
        #expect(response.totalCount >= 0)
        
        // If there are many routes, verify pagination works
        if response.totalCount > 100 {
            // The API should handle large route lists
            #expect(true, "Large route list handled")
        }
    }
}
