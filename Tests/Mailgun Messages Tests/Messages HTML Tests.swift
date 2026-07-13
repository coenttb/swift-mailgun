import Dependencies
import Dependencies_Test_Support
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
            html: "<h1>Hello World!</h1>",
            date: RFC_5322.DateTime(secondsSinceEpoch: 1_609_459_200)
        )

        let response = try await messages.client.send(email: email)

        print(response)
    }

    @Test("Email with text and HTML")
    func emailWithText() async throws {
        let email = try Email(
            to: [.init("info@coenttb.com")],
            from: .init("info@coenttb.com"),
            subject: "Multipart Email",
            text: "This is the plain text version.",
            date: RFC_5322.DateTime(secondsSinceEpoch: 1_609_459_200)
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
            html: "<div><h1>HTML Version</h1><p>This is the HTML version with formatting.</p></div>",
            date: RFC_5322.DateTime(secondsSinceEpoch: 1_609_459_200)
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
            html: "<div><h1>Newsletter</h1><p>This email uses both Email HTML content and Mailgun-specific options.</p></div>",
            date: RFC_5322.DateTime(secondsSinceEpoch: 1_609_459_200)
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
