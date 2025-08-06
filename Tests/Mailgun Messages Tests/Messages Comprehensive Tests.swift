import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun_Messages
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Messages Comprehensive Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MessagesComprehensiveTests {
    
    @Test("Send simple text email")
    func testSendSimpleTextEmail() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Simple Text Email Test",
            text: "This is a simple text email sent from the test suite.",
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send HTML email with text fallback")
    func testSendHtmlEmailWithTextFallback() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "HTML Email with Text Fallback",
            html: """
                <html>
                <body>
                    <h1>Welcome to Mailgun Tests</h1>
                    <p>This is an <strong>HTML email</strong> with formatting.</p>
                    <ul>
                        <li>Feature 1</li>
                        <li>Feature 2</li>
                        <li>Feature 3</li>
                    </ul>
                </body>
                </html>
                """,
            text: "Welcome to Mailgun Tests\n\nThis is an HTML email with formatting.\n\n- Feature 1\n- Feature 2\n- Feature 3",
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with CC and BCC recipients")
    func testSendEmailWithCcBcc() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with CC and BCC",
            html: "<p>This email has CC and BCC recipients</p>",
            text: "This email has CC and BCC recipients",
            cc: ["cc@example.com"],
            bcc: ["bcc@example.com"],
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with tags")
    func testSendEmailWithTags() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Tagged Email",
            text: "This email has tags for analytics",
            tags: ["test", "automated", "sdk-test"],
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with custom headers")
    func testSendEmailWithCustomHeaders() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Custom Headers",
            text: "This email includes custom headers",
            testMode: true,
            headers: [
                "X-Custom-Header": "CustomValue",
                "X-Test-ID": "test-123",
                "X-Campaign": "sdk-testing"
            ]
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with custom variables")
    func testSendEmailWithVariables() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Variables",
            text: "This email has custom variables attached",
            testMode: true,
            variables: [
                "user_id": "12345",
                "campaign_id": "test_campaign",
                "source": "sdk_test"
            ]
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with tracking options")
    func testSendEmailWithTracking() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Tracking",
            html: """
                <p>This email has tracking enabled.</p>
                <p><a href="https://example.com">Click this link</a></p>
                """,
            text: "This email has tracking enabled.\n\nVisit: https://example.com",
            testMode: true,
            tracking: .yes,
            trackingClicks: .htmlOnly,
            trackingOpens: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with DKIM settings")
    func testSendEmailWithDkim() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with DKIM Settings",
            text: "This email has specific DKIM settings",
            dkim: true,
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with TLS requirements")
    func testSendEmailWithTlsRequirement() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with TLS Requirement",
            text: "This email requires TLS for delivery",
            testMode: true,
            requireTls: true,
            skipVerification: false
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email to multiple recipients")
    func testSendEmailToMultipleRecipients() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let additionalRecipients = [
            try EmailAddress("test1@example.com"),
            try EmailAddress("test2@example.com"),
            try EmailAddress("test3@example.com")
        ]
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to] + additionalRecipients,
            subject: "Email to Multiple Recipients",
            text: "This email is being sent to multiple recipients",
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with recipient variables for batch sending")
    func testSendBatchEmailWithRecipientVariables() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let recipientVariables = """
            {
                "\(to.rawValue)": {"name": "Test User", "id": 1},
                "user2@example.com": {"name": "User Two", "id": 2},
                "user3@example.com": {"name": "User Three", "id": 3}
            }
            """
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to, try EmailAddress("user2@example.com"), try EmailAddress("user3@example.com")],
            subject: "Personalized Email for %recipient.name%",
            text: "Hello %recipient.name%! Your user ID is %recipient.id%.",
            testMode: true,
            recipientVariables: recipientVariables
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send AMP HTML email")
    func testSendAmpHtmlEmail() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let ampHtml = """
            <!doctype html>
            <html ⚡4email>
            <head>
                <meta charset="utf-8">
                <script async src="https://cdn.ampproject.org/v0.js"></script>
                <style amp4email-boilerplate>body{visibility:hidden}</style>
            </head>
            <body>
                <h1>Hello from AMP Email!</h1>
                <amp-img src="https://example.com/image.jpg" width="300" height="200"></amp-img>
            </body>
            </html>
            """
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "AMP HTML Email Test",
            html: "<h1>HTML Fallback</h1><p>This is the HTML version.</p>",
            text: "Text fallback for AMP email",
            ampHtml: ampHtml,
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send scheduled email")
    func testSendScheduledEmail() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let futureDate = Date().addingTimeInterval(3600) // 1 hour from now
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Scheduled Email Test",
            text: "This email was scheduled for delivery",
            deliveryTime: futureDate,
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with send time optimization")
    func testSendEmailWithSTO() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Send Time Optimization",
            text: "This email uses STO for optimal delivery timing",
            deliveryTimeOptimizePeriod: "24h",
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with timezone optimization")
    func testSendEmailWithTZO() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Timezone Optimization",
            text: "This email uses TZO for timezone-aware delivery",
            timeZoneLocalize: "09:00",
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with tracking pixel location top")
    func testSendEmailWithTrackingPixelTop() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Tracking Pixel at Top",
            html: "<p>This email has the tracking pixel at the top for better accuracy.</p>",
            testMode: true,
            trackingOpens: true,
            trackingPixelLocationTop: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
}