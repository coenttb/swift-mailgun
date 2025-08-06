import DependenciesTestSupport
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
import IssueReporting
import Mailgun_Messages
import Testing

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Messages Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development)
)
struct MessagesClientTests {
    @Test("Should successfully send an email")
    func testSendEmail() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let request = Mailgun.Messages.Send.Request(
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
