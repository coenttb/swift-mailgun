import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Messages
import Testing

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Messages Template Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MessagesTemplateTests {

    @Test("Send email with template")
    func testSendEmailWithTemplate() async throws {
        @Dependency(Mailgun.Messages.self) var messages
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Template Email Test",
            template: "welcome-template",
            testMode: true
        )

        let response = try await messages.client.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send email with template and variables")
    func testSendEmailWithTemplateVariables() async throws {
        @Dependency(Mailgun.Messages.self) var messages
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let templateVariables = """
            {
                "name": "John Doe",
                "company": "Acme Corp",
                "activation_link": "https://example.com/activate/123",
                "support_email": "support@example.com"
            }
            """

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Welcome to Our Service",
            template: "onboarding-template",
            templateVariables: templateVariables,
            testMode: true
        )

        let response = try await messages.client.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send email with template version")
    func testSendEmailWithTemplateVersion() async throws {
        @Dependency(Mailgun.Messages.self) var messages
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Versioned Template Test",
            template: "newsletter-template",
            templateVersion: "v2.0",
            templateVariables: """
                {
                    "month": "January",
                    "year": "2024"
                }
                """,
            testMode: true
        )

        let response = try await messages.client.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send email with template and generate text version")
    func testSendEmailWithTemplateText() async throws {
        @Dependency(Mailgun.Messages.self) var messages
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Template with Auto Text",
            template: "html-template",
            templateText: true,
            templateVariables: """
                {
                    "product": "Premium Plan",
                    "price": "$99.99"
                }
                """,
            testMode: true
        )

        let response = try await messages.client.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send MIME email with template")
    func testSendMimeWithTemplate() async throws {
        @Dependency(Mailgun.Messages.self) var messages
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/plain; charset=UTF-8
            From: \(from.rawValue)
            To: \(to.rawValue)
            Subject: MIME with Template Override

            This is the fallback content if template is not found.
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: [to],
            message: Data(mimeContent.utf8),
            template: "override-template",
            templateVariables: """
                {
                    "override_message": "This template overrides the MIME content"
                }
                """,
            testMode: true
        )

        let response = try await messages.client.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send email with template and custom variables")
    func testSendEmailWithTemplateAndCustomVars() async throws {
        @Dependency(Mailgun.Messages.self) var messages
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Template with Mixed Variables",
            template: "mixed-vars-template",
            templateVariables: """
                {
                    "template_var1": "From template variables",
                    "template_var2": "Also from template"
                }
                """,
            testMode: true,
            variables: [
                "custom_var1": "From custom variables",
                "custom_var2": "Also custom",
                "tracking_id": "test-123"
            ]
        )

        let response = try await messages.client.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send email with template override subject")
    func testSendEmailTemplateOverrideSubject() async throws {
        @Dependency(Mailgun.Messages.self) var messages
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Overridden Subject Line",  // This overrides template's subject
            template: "template-with-subject",
            templateVariables: """
                {
                    "content": "This tests subject override behavior"
                }
                """,
            testMode: true
        )

        let response = try await messages.client.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send batch email with template and recipient variables")
    func testSendBatchTemplateEmail() async throws {
        @Dependency(Mailgun.Messages.self) var messages
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to

        let recipientVariables = """
            {
                "\(to.rawValue)": {
                    "name": "Primary User",
                    "account_type": "Premium",
                    "renewal_date": "2024-12-31"
                },
                "user2@example.com": {
                    "name": "Secondary User",
                    "account_type": "Basic",
                    "renewal_date": "2024-06-15"
                }
            }
            """

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to, try EmailAddress("user2@example.com")],
            subject: "Account Status for %recipient.name%",
            template: "account-status-template",
            testMode: true,
            recipientVariables: recipientVariables
        )

        let response = try await messages.client.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
}
