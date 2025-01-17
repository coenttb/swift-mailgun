//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import Coenttb_Web
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum API: Equatable, Sendable {
    case list(
        domain: Domain,
        query: Events.List.Query?
    )
}
extension Events.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Events.API> {
            OneOf {
                URLRouting.Route(.case(Events.API.list)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.events
                    Optionally {
                        Events.List.Query.Parser()
                    }
                }
            }
        }
    }
}

extension Events.List.Query {
    struct Parser: ParserPrinter, Sendable {
        public init() {}
        var body: some ParserPrinter<URLRequestData, Events.List.Query> {
            URLRouting.Query {
                Parse(.memberwise(Events.List.Query.init)) {
                    Optionally {
                        Field("begin") {
                            Date.RFC2822.Parser()
                        }
                    }
                    Optionally {
                        Field("end") {
                            Date.RFC2822.Parser()
                        }
                    }
                    Optionally {
                        Field("ascending") {
                            Parse(.string.representing(Events.List.Query.Ascending.self))
                        }
                    }
                    Optionally {
                        Field("limit") { Digits() }
                    }
                    Optionally {
                        Field("event") { Parse(.string.representing(Event.Variant.self)) }
                    }
                    Optionally {
                        Field("list") { Parse(.string) }
                    }
                    Optionally {
                        Field("attachment") { Parse(.string) }
                    }
                    Optionally {
                        Field("from") { Parse(.string.representing(EmailAddress.self)) }
                    }
                    Optionally {
                        Field("message-id") { Parse(.string) }
                    }
                    Optionally {
                        Field("subject") { Parse(.string) }
                    }
                    
                    
                    
                    Optionally {
                        Field("to") {
                            Parse(.string.representing(EmailAddress.self))
                        }
                    }
                    Optionally {
                        Field("size") { Digits() }
                    }
                    Optionally {
                        Field("recipient") {
                            Parse(.string.representing(EmailAddress.self))
                        }
                    }
                    Optionally {
                        Field("recipients") {
                            Many {
                                Prefix { $0 != "," }.map(.string.representing(EmailAddress.self))
                            }
                            separator: {
                                ","
                            }
                        }
                    }
                    Optionally {
                        Field("tags") {
                            Many {
                                Prefix { $0 != "," }.map(.string)
                            }
                            separator: {
                                ","
                            }
                        }
                    }
                    Optionally {
                        Field("severity") {
                            Parse(.string.representing(Events.List.Query.Severity.self))
                        }
                    }
                    
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe)
    public static let events: Path<PathBuilder.Component<String>> = Path {
        "events"
    }
}
