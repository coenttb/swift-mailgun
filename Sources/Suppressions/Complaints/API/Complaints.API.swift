// Complaints.API.swift
import Coenttb_Web
import Shared

extension Complaints {
    public enum API: Equatable, Sendable {
        case importList(domain: Domain, request: Data)
        case get(domain: Domain, address: EmailAddress)
        case delete(domain: Domain, address: EmailAddress)
        case list(domain: Domain, request: Complaints.List.Request)
        case create(domain: Domain, request: Complaints.Create.Request)
        case deleteAll(domain: Domain)
    }
}

extension Complaints.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Complaints.API> {
            OneOf {
                URLRouting.Route(.case(Complaints.API.importList)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Path { "import" }
                    Body(.form(Foundation.Data.self, decoder: .default))
                }
                
                URLRouting.Route(.case(Complaints.API.get)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
                URLRouting.Route(.case(Complaints.API.delete)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
                URLRouting.Route(.case(Complaints.API.list)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Parse(.memberwise(Complaints.List.Request.init)) {
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
                
                URLRouting.Route(.case(Complaints.API.create)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                    Body(.form(Complaints.Create.Request.self, decoder: .default))
                }
                
                URLRouting.Route(.case(Complaints.API.deleteAll)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.complaints
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe) public static let complaints = Path {
        "complaints"
    }
}

extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}
