import CoenttbWeb
import Shared

extension Bounces {
    public enum API: Equatable, Sendable {
        case importList(domain: Domain, request: Data)
        case get(domain: Domain, address: EmailAddress)
        case delete(domain: Domain, address: EmailAddress)
        case list(domain: Domain, request: Bounces.List.Request)
        case create(domain: Domain, request: Bounces.Create.Request)
        case deleteAll(domain: Domain)
    }
}

extension Bounces.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Bounces.API> {
            OneOf {
                // POST /v3/{domain}/bounces/import
                URLRouting.Route(.case(Bounces.API.importList)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Path { "import" }
                    Body(.form(Foundation.Data.self, decoder: .default))
                }
                
                // GET /v3/{domain}/bounces/{address}
                URLRouting.Route(.case(Bounces.API.get)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
                // DELETE /v3/{domain}/bounces/{address}
                URLRouting.Route(.case(Bounces.API.delete)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
                // GET /v3/{domain}/bounces
                URLRouting.Route(.case(Bounces.API.list)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Parse(.memberwise(Bounces.List.Request.init)) {
                        URLRouting.Query {
                            Optionally {
                                Field("limit") { Digits() }
                            }
                            Optionally {
                                Field("page") { Parse(.string) }
                            }
                            Optionally {
                                Field("term") { Parse(.string) }
                            }
                        }
                    }
                }
                
                // POST /v3/{domain}/bounces
                URLRouting.Route(.case(Bounces.API.create)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                    Body(.form(Bounces.Create.Request.self, decoder: .default))
                }
                
                // DELETE /v3/{domain}/bounces
                URLRouting.Route(.case(Bounces.API.deleteAll)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.bounces
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe)
    public static let bounces: Path<PathBuilder.Component<String>> = Path {
        "bounces"
    }
}

extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}
