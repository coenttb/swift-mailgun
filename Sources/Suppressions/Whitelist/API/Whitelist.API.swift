//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import CoenttbWeb
import Shared

extension Whitelist {
    public enum API: Equatable, Sendable {
        case get(domain: Domain, value: String)
        case delete(domain: Domain, value: String)
        case list(domain: Domain, request: Whitelist.List.Request)
        case create(domain: Domain, request: Whitelist.Create.Request)
        case deleteAll(domain: Domain)
        case importList(domain: Domain, request: Data)
    }
}

extension Whitelist.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Whitelist.API> {
            OneOf {
                URLRouting.Route(.case(Whitelist.API.get)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Path { Parse(.string) }
                }
                
                URLRouting.Route(.case(Whitelist.API.delete)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Path { Parse(.string) }
                }
                
                URLRouting.Route(.case(Whitelist.API.list)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Parse(.memberwise(Whitelist.List.Request.init)) {
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
                
                URLRouting.Route(.case(Whitelist.API.create)) {
                    Method.post
                    Headers {
                        Field.contentType { "application/x-www-form-urlencoded" }
                    }
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Body(.form(Whitelist.Create.Request.self, decoder: .default))
                }
                
                URLRouting.Route(.case(Whitelist.API.deleteAll)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                }
                
                URLRouting.Route(.case(Whitelist.API.importList)) {
                    
                    let multipart = MultipartFileUpload.csv()
                    
                    Method.post
                    Headers {
                        Field.contentType { multipart.contentType }
                    }
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.whitelists
                    Path { "import" }
                    Body(multipart)
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe)
    public static let whitelists: Path<PathBuilder.Component<String>> = Path {
        "whitelists"
    }
}

extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}
