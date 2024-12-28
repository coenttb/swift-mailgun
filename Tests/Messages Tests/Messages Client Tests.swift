import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import Messages
import IssueReporting
import TestShared
import Shared
import Authenticated

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Messages Client Tests",
    .dependency(\.envVars, .liveTest),
    .dependency(\.client, .testValue)
)
struct MessagesClientTests {
    @Test("Should successfully send an email")
    func testSendEmail() async throws {
        @Dependency(\.client!) var client
        @Dependency(\.envVars) var envVars
        
        let from = try #require(envVars.mailgunFrom)
        let to = try #require(envVars.mailgunTo)
        
        let request = Messages.Send.Request(
            // Use the exact domain format
            from: from,
            to: [to],
            subject: "Test Email from Mailgun Swift SDK",
            html: "<h1>Hello from Tests!</h1><p>This is a test email sent via Mailgun.</p>",
            text: "Hello from Tests! This is a test email sent via Mailgun.",
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
}
