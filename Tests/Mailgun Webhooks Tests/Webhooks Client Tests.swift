//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
@testable import Mailgun_Webhooks
import Testing
import WebhooksTypes

@Suite(
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)

struct WebhooksClientTests {
    @Test("Should successfully create webhook")
    func testCreateWebhook() async throws {
        @Dependency(Mailgun.Webhooks.Client.self) var client

        let testUrl = "https://bin.mailgun.net/opened"
        let response = try await client.create(.opened, testUrl)

        #expect(response.message == "Webhook has been created")
        #expect(response.webhook.urls.contains(testUrl))
    }

    @Test("Should successfully list webhooks")
    func testListWebhooks() async throws {
        @Dependency(Mailgun.Webhooks.Client.self) var client

        let response = try await client.list()

        #expect(response.webhooks.opened?.urls.isEmpty == false)
    }

    @Test("Should successfully get webhook by type")
    func testGetWebhook() async throws {
        @Dependency(Mailgun.Webhooks.Client.self) var client

        let webhook = try await client.get(.opened)

        #expect(!webhook.webhook.urls.isEmpty)
    }

    @Test("Should successfully update webhook")
    func testUpdateWebhook() async throws {
        @Dependency(Mailgun.Webhooks.Client.self) var client

        let testUrl = "https://bin.mailgun.net/opened2"
        let response = try await client.update(.opened, testUrl)

        #expect(response.message == "Webhook has been updated")
        #expect(response.webhook.urls.contains(testUrl))
    }

    @Test("Should successfully delete webhook")
    func testDeleteWebhook() async throws {
        @Dependency(Mailgun.Webhooks.Client.self) var client

        let response = try await client.delete(.opened)

        #expect(response.message == "Webhook has been deleted")
        #expect(!response.webhook.urls.isEmpty)
    }
}
