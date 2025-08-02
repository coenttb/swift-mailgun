//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import ServerFoundation
import Shared

public enum API: Equatable, Sendable {
    case list(domain: Domain)
    case get(domain: Domain, type: Webhook.Variant)
    case create(domain: Domain, type: Webhook.Variant, url: String)
    case update(domain: Domain, type: Webhook.Variant, url: String)
    case delete(domain: Domain, type: Webhook.Variant)
}

extension API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<API> {
            OneOf {
                URLRouting.Route(.case(API.list)) {
                    Method.get
                    Path.v3
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.webhooks
                }
                
                URLRouting.Route(.case(API.get)) {
                    Method.get
                    Path.v3
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.webhooks
                    Path { Parse(.string.representing(Webhook.Variant.self)) }
                }
                
                URLRouting.Route(.case(API.create)) {
                    Method.post
                    Path.v3
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.webhooks
                    URLRouting.Query {
                        Field("id") { Parse(.string.representing(Webhook.Variant.self)) }
                    }
                    URLRouting.Query {
                        Field("url") { Parse(.string) }
                    }
                }
                
                URLRouting.Route(.case(API.update)) {
                    Method.put
                    Path.v3
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.webhooks
                    Path { Parse(.string.representing(Webhook.Variant.self)) }
                    URLRouting.Query {
                        Field("url") { Parse(.string) }
                    }
                }
                
                URLRouting.Route(.case(API.delete)) {
                    Method.delete
                    Path.v3
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.webhooks
                    Path { Parse(.string.representing(Webhook.Variant.self)) }
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe) public static let webhooks = Path {
        "webhooks"
    }
    
    nonisolated(unsafe) public static let domains = Path {
        "domains"
    }
}

extension Webhooks.API.Router: TestDependencyKey {
    public static let testValue: Self = .init()
}
