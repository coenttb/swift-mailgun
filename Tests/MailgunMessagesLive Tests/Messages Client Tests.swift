import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import Messages
import IssueReporting
import MailgunSharedLive
import MailgunMessagesLive

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Messages Client Tests",
    .dependency(\.context, .live),
    .dependency(\.projectRoot, .mailgunLive),
    .dependency(\.envVars, .development),
)
struct MessagesClientTests {
    @Test("Should successfully send an email")
    func testSendEmail() async throws {
        @Dependency(Messages.Client.Authenticated.self) var client
        @Dependency(\.envVars) var envVars
        
        let from = envVars.mailgunFrom
        let to = envVars.mailgunTo
        
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
