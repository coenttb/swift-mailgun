//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import CoenttbWeb
import Shared


extension Unsubscribe {
    public enum API: Equatable, Sendable {
        case importList(domain: Domain, request: Data)
        case get(domain: Domain, address: EmailAddress)
        case delete(domain: Domain, address: EmailAddress)
        case list(domain: Domain, request: Unsubscribe.List.Request)
        case create(domain: Domain, request: Unsubscribe.Create.Request)
        case deleteAll(domain: Domain)
    }
}

extension Unsubscribe.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Unsubscribe.API> {
            OneOf {
                // POST /v3/{domain}/unsubscribes/import
                URLRouting.Route(.case(Unsubscribe.API.importList)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Path { "import" }
                    Body(.form(Foundation.Data.self, decoder: .default))
                }
                
                // GET /v3/{domain}/unsubscribes/{address}
                URLRouting.Route(.case(Unsubscribe.API.get)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
                // DELETE /v3/{domain}/unsubscribes/{address}
                URLRouting.Route(.case(Unsubscribe.API.delete)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
                // GET /v3/{domain}/unsubscribes
                URLRouting.Route(.case(Unsubscribe.API.list)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Parse(.memberwise(Unsubscribe.List.Request.init)) {
                        URLRouting.Query {
                            Optionally {
                                Field("address") { Parse(.string.representing(EmailAddress.self)) }
                            }
                            Optionally {
                                Field("term") { Parse(.string) }
                            }
                            Optionally {
                                Field("limit") { Digits() }
                            }
                            Optionally {
                                Field("page") { Parse(.string) }
                            }
                        }
                    }
                }
                
                // POST /v3/{domain}/unsubscribes
                URLRouting.Route(.case(Unsubscribe.API.create)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Body(.form(Unsubscribe.Create.Request.self, decoder: .default))
                }
                
                // DELETE /v3/{domain}/unsubscribes
                URLRouting.Route(.case(Unsubscribe.API.deleteAll)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe)
    public static let unsubscribes: Path<PathBuilder.Component<String>> = Path {
        "unsubscribes"
    }
}


extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}
