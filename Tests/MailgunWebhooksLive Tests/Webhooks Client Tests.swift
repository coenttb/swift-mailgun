//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import IssueReporting
import Shared
@testable import Webhooks

@Suite(
    .dependency(\.envVars, .liveTest),
    .dependency(AuthenticatedClient.testValue)
)
struct WebhooksClientTests {
    @Test("Should successfully create webhook")
    func testCreateWebhook() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        let testUrl = "https://webhook.test/endpoint"
        let response = try await client.create(.opened, testUrl)
        
        #expect(response.message == "Webhook has been created")
        #expect(response.webhook.urls.contains(testUrl))
    }
    
    @Test("Should successfully list webhooks")
    func testListWebhooks() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        let response = try await client.list()
        
        #expect(!response.isEmpty)
        #expect(response.values.allSatisfy { !$0.urls.isEmpty })
    }
    
    @Test("Should successfully get webhook by type")
    func testGetWebhook() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        let webhook = try await client.get(.delivered)
        
        #expect(!webhook.urls.isEmpty)
    }
    
    @Test("Should successfully update webhook")
    func testUpdateWebhook() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        let testUrl = "https://webhook.test/updated"
        let response = try await client.update(.clicked, testUrl)
        
        #expect(response.message == "Webhook has been updated")
        #expect(response.webhook.urls.contains(testUrl))
    }
    
    @Test("Should handle permanent and temporary fail webhooks")
    func testFailureWebhooks() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        let testUrl = "https://webhook.test/failures"
        let permanentResponse = try await client.create(.permanentFail, testUrl)
        
        #expect(permanentResponse.webhook.urls.contains(testUrl))
        
        let temporaryResponse = try await client.create(.temporaryFail, testUrl)
        #expect(temporaryResponse.webhook.urls.contains(testUrl))
    }
    
    @Test("Should successfully delete webhook")
    func testDeleteWebhook() async throws {
        @Dependency(AuthenticatedClient.self) var client

        let response = try await client.delete(.complained)
        
        #expect(response.message == "Webhook has been deleted")
        #expect(!response.webhook.urls.isEmpty)
    }
}
