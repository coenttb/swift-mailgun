import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun
import Testing

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite("README Verification")
struct ReadmeVerificationTests {
    @Dependency(Mailgun.Messages.self) var messages

    // README line 16-40: Overview example
    @Test("Overview example compiles")
    func overviewExample() async throws {
        let request = try Mailgun.Messages.Send.Request(
            from: .init("hello@yourdomain.com"),
            to: [try .init("user@example.com")],
            subject: "Welcome!"
        ) {
            div {
                h1 { "Welcome!" }
                    .color(.blue)
                    .textAlign(.center)

                p { "We're excited to have you on board." }
                    .fontSize(.rem(1.1))
            }
            .padding(.rem(2))
        }

        // Verify request structure
        #expect(request.from.description == "hello@yourdomain.com")
        #expect(request.to.count == 1)
        #expect(request.subject == "Welcome!")
    }

    // README line 82-99: Basic Usage
    @Test("Basic usage example compiles")
    func basicUsageExample() async throws {
        let request = try Mailgun.Messages.Send.Request(
            from: .init("noreply@yourdomain.com"),
            to: [.init("test@example.com")],
            subject: "Hello",
            text: "Hello from Mailgun!"
        ) {
            div { "HTML body" }
        }

        #expect(request.from.description == "noreply@yourdomain.com")
        #expect(request.subject == "Hello")
        #expect(request.text == "Hello from Mailgun!")
    }

    // README line 105-128: HTML Email Templates
    @Test("HTML email template example compiles")
    func htmlTemplateExample() async throws {
        let request = try Mailgun.Messages.Send.Request(
            from: .init("newsletter@yourdomain.com"),
            to: [.init("subscriber@example.com")],
            subject: "Weekly Newsletter"
        ) {
            div {
                h1 { "This Week's Highlights" }
                    .marginBottom(.rem(1))

                ul {
                    li { "New Swift 6 features" }
                    li { "SwiftUI improvements" }
                    li { "Server-side Swift updates" }
                }

                a(href: "{{unsubscribe}}") { "Unsubscribe" }
                    .fontSize(.px(12))
                    .color(.gray)
            }
            .padding(.rem(2))
        }

        #expect(request.from.description == "newsletter@yourdomain.com")
        #expect(request.to.count == 1)
        #expect(request.subject == "Weekly Newsletter")
    }

    // README line 133-144: Template Variables
    @Test("Template variables example compiles")
    func templateVariablesExample() async throws {
        let templateVars = """
        {
            "customer_name": "John Doe",
            "order_id": "12345",
            "total": "$99.99"
        }
        """

        let request = try Mailgun.Messages.Send.Request(
            from: .init("noreply@yourdomain.com"),
            to: [.init("user@example.com")],
            subject: "Order #{{order_id}}",
            template: "order-confirmation",
            templateVariables: templateVars
        ) {
            div { "Fallback HTML" }
        }

        #expect(request.template == "order-confirmation")
        #expect(request.templateVariables != nil)
    }

    // README line 148-162: Batch Sending
    @Test("Batch sending example compiles")
    func batchSendingExample() async throws {
        let recipientVars = """
        {
            "alice@example.com": {"name": "Alice", "code": "ALICE20"},
            "bob@example.com": {"name": "Bob", "code": "BOB15"}
        }
        """

        let request = try Mailgun.Messages.Send.Request(
            from: .init("newsletter@yourdomain.com"),
            to: [
                .init("alice@example.com"),
                .init("bob@example.com")
            ],
            subject: "Hello %recipient.name%!",
            text: "Special code: %recipient.code%",
            recipientVariables: recipientVars
        ) {
            div { "Hello %recipient.name%!" }
        }

        #expect(request.to.count == 2)
        #expect(request.recipientVariables != nil)
    }

    // README line 166-176: Scheduled Delivery
    @Test("Scheduled delivery example compiles")
    func scheduledDeliveryExample() async throws {
        let deliveryTime = Date().addingTimeInterval(3600)

        let request = try Mailgun.Messages.Send.Request(
            from: .init("reminder@yourdomain.com"),
            to: [.init("user@example.com")],
            subject: "Meeting Reminder",
            text: "Meeting in 1 hour",
            deliveryTime: deliveryTime
        ) {
            div { "Meeting reminder" }
        }

        #expect(request.deliveryTime != nil)
        #expect(request.subject == "Meeting Reminder")
    }

    // README line 180-194: Attachments
    @Test("Attachments example compiles")
    func attachmentsExample() async throws {
        let pdfData = Data()

        let attachment = Mailgun.Messages.Attachment.Data(
            data: pdfData,
            filename: "report.pdf",
            contentType: "application/pdf"
        )

        let request = try Mailgun.Messages.Send.Request(
            from: .init("reports@yourdomain.com"),
            to: [.init("manager@example.com")],
            subject: "Monthly Report",
            text: "Report attached",
            attachments: [attachment]
        ) {
            div { "Monthly report attached" }
        }

        #expect(request.attachments?.count == 1)
        #expect(request.attachments?.first?.filename == "report.pdf")
    }
}
