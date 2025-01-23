//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Coenttb_Web
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
                URLRouting.Route(.case(Messages.API.send)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.messages
                    Body(.form(Messages.Send.Request.self, decoder: .default))
                }
                
                URLRouting.Route(.case(Messages.API.sendMime)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "messages.mime" }
                    Body(.form(Messages.Send.Mime.Request.self, decoder: .default))
                }
                
                URLRouting.Route(.case(Messages.API.retrieve)) {
                    Method.get
                    Path.v3
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.messages
                    Path { Parse(.string) }
                }
                
                URLRouting.Route(.case(Messages.API.queueStatus)) {
                    Method.get
                    Path.v3
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path { "sending_queues" }
                }
                
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

extension Messages.API.Router: TestDependencyKey {
    public static let testValue: Messages.API.Router = .init()
}


extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe) public static let messages = Path {
        "messages"
    }

    nonisolated(unsafe) public static let domains = Path {
        "domains"
    }
}
