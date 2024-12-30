//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//


import Shared
import Coenttb_Web
import DependenciesMacros

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    @DependencyEndpoint
    public var list: @Sendable () async throws -> [Webhook.Variant: Webhook]
    
    @DependencyEndpoint
    public var get: @Sendable (_ type: Webhook.Variant) async throws -> Webhook
    
    @DependencyEndpoint
    public var create: @Sendable (_ type: Webhook.Variant, _ url: String) async throws -> Response
    
    @DependencyEndpoint
    public var update: @Sendable (_ type: Webhook.Variant, _ url: String) async throws -> Response
    
    @DependencyEndpoint
    public var delete: @Sendable (_ type: Webhook.Variant) async throws -> Response
}

extension Webhooks.Client: TestDependencyKey {
    static public let testValue: Self = Webhooks.Client(
        list: {
            [
                .delivered: .init(urls: ["https://test.webhook.com/delivered"]),
                .opened: .init(urls: ["https://test.webhook.com/opened"]),
                .clicked: .init(urls: ["https://test.webhook.com/clicked"]),
                .permanentFail: .init(urls: ["https://test.webhook.com/permanent-fail"])
            ]
        },
        get: { type in
                .init(urls: ["https://test.webhook.com/\(type)"])
        },
        create: { type, url in
                .init(
                    message: "Webhook has been created",
                    webhook: .init(urls: [url])
                )
        },
        update: { type, url in
                .init(
                    message: "Webhook has been updated",
                    webhook: .init(urls: [url])
                )
        },
        delete: { type in
                .init(
                    message: "Webhook has been deleted",
                    webhook: .init(urls: ["https://test.webhook.com/\(type)"])
                )
        }
    )
}
