import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Messages
import Testing

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

@Suite(
  "Messages Attachments Tests",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct MessagesAttachmentsTests {
  @Dependency(Mailgun.Messages.self) var messages

  @Test("Messages HTML")
  func html() async throws {
    let request = try Mailgun.Messages.Send.Request(
      from: .init("info@coenttb.com"),
      to: [.init("info@coenttb.com")],
      subject: "From HTML"
    ) {
      h1 { "Hello World!" }
    }

    let response = try await messages.client.send(request: request)

    print(response)
  }

  @Test("Messages AMP HTML")
  func ampHtml() async throws {
    let request = try Mailgun.Messages.Send.Request(
      from: .init("info@coenttb.com"),
      to: [.init("info@coenttb.com")],
      subject: "From HTML"
    ) {
      h1 { "Hello World!" }
    } ampHtml: {
      h1 { "Hello World!" }
    }

    let response = try await messages.client.send(request: request)

    print(response)
  }
}
