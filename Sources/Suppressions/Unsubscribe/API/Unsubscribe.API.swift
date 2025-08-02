//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import ServerFoundation
import Shared


extension Unsubscribe {
    public enum API: Equatable, Sendable {
        case importList(domain: Domain, request: Foundation.Data)
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
                URLRouting.Route(.case(Unsubscribe.API.importList)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Path { "import" }
                    Body(.form(Foundation.Data.self, decoder: .mailgun))
                }
                
                URLRouting.Route(.case(Unsubscribe.API.get)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
                URLRouting.Route(.case(Unsubscribe.API.delete)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
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
                
                URLRouting.Route(.case(Unsubscribe.API.create)) {
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.unsubscribes
                    Body(.form(Unsubscribe.Create.Request.self, decoder: .mailgun))
                }
                
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
    nonisolated(unsafe) public static let unsubscribes = Path {
        "unsubscribes"
    }
}

extension Unsubscribe.API.Router: TestDependencyKey {
    public static let testValue: Unsubscribe.API.Router = .init()
}
