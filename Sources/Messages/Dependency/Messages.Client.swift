//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import CoenttbWeb
import DependenciesMacros

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    @DependencyEndpoint
    public var send: @Sendable (_ request: Messages.Send.Request) async throws -> Messages.Send.Response
    
    @DependencyEndpoint
    public var sendMime: @Sendable (_ request: Messages.Send.Mime.Request) async throws -> Messages.Send.Response
    
    @DependencyEndpoint
    public var retrieve: @Sendable (_ storageKey: String) async throws -> Messages.StoredMessage
    
    @DependencyEndpoint
    public var queueStatus: @Sendable () async throws -> Messages.Queue.Status
    
    @DependencyEndpoint
    public var deleteAll: @Sendable () async throws -> Messages.Delete.Response
}

extension Client: TestDependencyKey {
    public static var testValue: Self {
                
        return Self(
            send: { _ in
                .init(id: "test-id", message: "Queued. Thank you.")
            },
            sendMime: { _ in
                .init(id: "test-id", message: "Queued. Thank you.")
            },
            retrieve: { _ in
                .init(
                    contentTransferEncoding: "7bit",
                    contentType: "text/html; charset=ascii",
                    from: try .init("test@example.com"),
                    messageId: "<test-id@example.com>",
                    mimeVersion: "1.0",
                    subject: "Test Subject",
                    to: try .init("recipient@example.com"),
                    tags: ["test"],
                    sender: try .init("test@example.com"),
                    recipients: [try .init("recipient@example.com")],
                    bodyHtml: "<html>Test</html>",
                    bodyPlain: "Test",
                    strippedHtml: "<html>Test</html>",
                    strippedText: "Test",
                    strippedSignature: nil,
                    messageHeaders: [],
                    templateName: nil,
                    templateVariables: nil
                )
            },
            queueStatus: {
                .init(
                    regular: .init(isDisabled: false, disabled: nil),
                    scheduled: .init(isDisabled: false, disabled: nil)
                )
            },
            deleteAll: {
                .init(message: "done")
            }
        )
    }
}
