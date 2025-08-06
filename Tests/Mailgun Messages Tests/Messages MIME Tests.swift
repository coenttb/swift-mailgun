import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Messages
import Testing

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Messages MIME Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MessagesMIMETests {

    @Test("Send MIME email with basic content")
    func testSendBasicMimeEmail() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/plain; charset=UTF-8
            From: \(from.rawValue)
            To: \(to.rawValue)
            Subject: MIME Email Test

            This is a test MIME email sent through Mailgun.
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: [to],
            message: Data(mimeContent.utf8),
            testMode: true
        )

        let response = try await client.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send multipart MIME email")
    func testSendMultipartMimeEmail() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let boundary = "boundary-\(UUID().uuidString)"
        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: multipart/alternative; boundary="\(boundary)"
            From: \(from.rawValue)
            To: \(to.rawValue)
            Subject: Multipart MIME Email Test

            --\(boundary)
            Content-Type: text/plain; charset=UTF-8

            This is the plain text version of the email.

            --\(boundary)
            Content-Type: text/html; charset=UTF-8

            <html>
            <body>
                <h1>This is the HTML version</h1>
                <p>With <strong>formatting</strong> and <em>style</em>.</p>
            </body>
            </html>

            --\(boundary)--
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: [to],
            message: Data(mimeContent.utf8),
            testMode: true
        )

        let response = try await client.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send MIME email with custom headers")
    func testSendMimeWithCustomHeaders() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/plain; charset=UTF-8
            From: \(from.rawValue)
            To: \(to.rawValue)
            Subject: MIME Email with Custom Headers
            X-Custom-Header: CustomValue
            X-Priority: High
            X-Campaign-ID: test-campaign-123

            This MIME email includes custom headers.
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: [to],
            message: Data(mimeContent.utf8),
            testMode: true,
            headers: [
                "X-Test-Suite": "MIME-Tests",
                "X-Test-ID": UUID().uuidString
            ]
        )

        let response = try await client.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send MIME email with tags")
    func testSendMimeWithTags() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/plain; charset=UTF-8
            From: \(from.rawValue)
            To: \(to.rawValue)
            Subject: Tagged MIME Email

            This MIME email is tagged for analytics.
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: [to],
            message: Data(mimeContent.utf8),
            tags: ["mime-test", "automated", "sdk"],
            testMode: true
        )

        let response = try await client.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send MIME email with tracking options")
    func testSendMimeWithTracking() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/html; charset=UTF-8
            From: \(from.rawValue)
            To: \(to.rawValue)
            Subject: MIME Email with Tracking

            <html>
            <body>
                <p>This email has tracking enabled.</p>
                <p><a href="https://example.com/click-me">Track this link</a></p>
            </body>
            </html>
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: [to],
            message: Data(mimeContent.utf8),
            testMode: true,
            tracking: .yes,
            trackingClicks: .htmlOnly,
            trackingOpens: true
        )

        let response = try await client.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send MIME email with DKIM options")
    func testSendMimeWithDkim() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/plain; charset=UTF-8
            From: \(from.rawValue)
            To: \(to.rawValue)
            Subject: MIME Email with DKIM

            This email tests DKIM signing options.
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: [to],
            message: Data(mimeContent.utf8),
            dkim: true,
            testMode: true
        )

        let response = try await client.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send scheduled MIME email")
    func testSendScheduledMime() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let futureDate = Date().addingTimeInterval(7200) // 2 hours from now

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/plain; charset=UTF-8
            From: \(from.rawValue)
            To: \(to.rawValue)
            Subject: Scheduled MIME Email

            This MIME email was scheduled for future delivery.
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: [to],
            message: Data(mimeContent.utf8),
            deliveryTime: futureDate,
            testMode: true
        )

        let response = try await client.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send MIME with TLS requirements")
    func testSendMimeWithTls() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/plain; charset=UTF-8
            From: \(from.rawValue)
            To: \(to.rawValue)
            Subject: MIME Email with TLS

            This email requires TLS for secure delivery.
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: [to],
            message: Data(mimeContent.utf8),
            testMode: true,
            requireTls: true,
            skipVerification: false
        )

        let response = try await client.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send MIME with recipient variables")
    func testSendMimeWithRecipientVariables() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let recipientVariables = """
            {
                "\(to.rawValue)": {"name": "Primary User", "code": "ABC123"},
                "user2@example.com": {"name": "Secondary User", "code": "DEF456"}
            }
            """

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/plain; charset=UTF-8
            From: \(from.rawValue)
            To: \(to.rawValue), user2@example.com
            Subject: Personalized MIME: %recipient.name%

            Hello %recipient.name%,

            Your unique code is: %recipient.code%
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: [to, try EmailAddress("user2@example.com")],
            message: Data(mimeContent.utf8),
            testMode: true,
            recipientVariables: recipientVariables
        )

        let response = try await client.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send MIME with base64 encoded content")
    func testSendMimeWithBase64Content() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let textContent = "This is base64 encoded content in the MIME message."
        let base64Content = Data(textContent.utf8).base64EncodedString()

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/plain; charset=UTF-8
            Content-Transfer-Encoding: base64
            From: \(from.rawValue)
            To: \(to.rawValue)
            Subject: Base64 Encoded MIME Email

            \(base64Content)
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: [to],
            message: Data(mimeContent.utf8),
            testMode: true
        )

        let response = try await client.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
}
