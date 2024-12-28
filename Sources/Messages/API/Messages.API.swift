//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import CoenttbWeb
import Shared

public enum API: Equatable, Sendable {
    case send(domain: Domain, request: Messages.Send.Request)
    case sendMime(domain: Domain, request: Messages.Send.Mime.Request)
    case retrieve(domain: Domain, storageKey: String)
    case queueStatus(domain: Domain)
    case deleteScheduled(domain: Domain)
}

extension Messages.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Messages.API> {
            OneOf {
                // POST /v3/{domain_name}/messages
                URLRouting.Route(.case(Messages.API.send)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.messages
                    Body(.form(Messages.Send.Request.self, decoder: .default))
                }
                
                // POST /v3/{domain_name}/messages.mime
                URLRouting.Route(.case(Messages.API.sendMime)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "messages.mime" }
                    Body(.form(Messages.Send.Mime.Request.self, decoder: .default))
                }
                
                // GET /v3/domains/{domain_name}/messages/{storage_key}
                URLRouting.Route(.case(Messages.API.retrieve)) {
                    Method.get
                    Path.v3
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.messages
                    Path { Parse(.string) }
                }
                
                // GET /v3/domains/{name}/sending_queues
                URLRouting.Route(.case(Messages.API.queueStatus)) {
                    Method.get
                    Path.v3
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "sending_queues" }
                }
                
                // DELETE /v3/{domain_name}/envelopes
                URLRouting.Route(.case(Messages.API.deleteScheduled)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "envelopes" }
                }
            }
        }
    }
}

extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe)
    public static let messages: Path<PathBuilder.Component<String>> = Path {
        "messages"
    }
    
    nonisolated(unsafe)
    public static let domains: Path<PathBuilder.Component<String>> = Path {
        "domains"
    }
}
