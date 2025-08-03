import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import Messages
import IssueReporting
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Messages Client Tests",
    .dependency(\.envVars, .liveTest),
    .dependency(TestStrategy.live)
    
)
struct MessagesClientTests {
    @Test("Should successfully send an email")
    func testSendEmail() async throws {
        @Dependency(AuthenticatedClient.self) var client
        @Dependency(\.envVars) var envVars
        @Dependency(TestStrategy.self) var testStrategy
        print(testStrategy)
        
        let from = try #require(envVars.mailgunFrom)
        let to = try #require(envVars.mailgunTo)
        
        let request = Messages.Send.Request(
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
