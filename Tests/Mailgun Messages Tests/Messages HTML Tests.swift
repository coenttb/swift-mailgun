import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Messages
import Testing

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

@Suite(
    "Messages HTML Email Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MessagesHTMLEmailTests {
    @Dependency(Mailgun.Messages.self) var messages

    @Test("Simple HTML email")
    func html() async throws {
        let email = try Email(
            to: [.init("info@coenttb.com")],
            from: .init("info@coenttb.com"),
            subject: "Simple HTML Email",
            html: {
                h1 { "Hello World!" }
            }
        )

        let response = try await messages.client.send(email: email)

        print(response)
    }

    @Test("Email with HTML builder")
    func emailWithHtml() async throws {
        let email = try Email(
            to: [.init("info@coenttb.com")],
            from: .init("info@coenttb.com"),
            subject: "Email with HTML builder",
            html: {
                div {
                    h1 { "Welcome!" }
                    p { "This email was created using the Email type with HTML builder." }
                }
            }
        )

        let response = try await messages.client.send(email: email)

        print(response)
    }

    @Test("Email with text and HTML")
    func emailWithTextAndHtml() async throws {
        let email = try Email(
            to: [.init("info@coenttb.com")],
            from: .init("info@coenttb.com"),
            subject: "Multipart Email",
            text: "This is the plain text version.",
            html: {
                div {
                    h1 { "HTML Version" }
                    p { "This is the HTML version with formatting." }
                }
            }
        )

        let response = try await messages.client.send(email: email)

        print(response)
    }

    @Test("Email with HTML and Mailgun options")
    func emailWithHtmlAndMailgunOptions() async throws {
        let email = try Email(
            to: [.init("info@coenttb.com")],
            from: .init("info@coenttb.com"),
            subject: "Email with Mailgun options",
            html: {
                div {
                    h1 { "Newsletter" }
                    p { "This email uses both Email HTML builder and Mailgun-specific options." }
                }
            }
        )

        let response = try await messages.client.send(
            email: email,
            tags: ["newsletter", "html-test"],
            testMode: true,
            tracking: .yes
        )

        print(response)
    }
}
