//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import CoenttbWeb
import Shared

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
                    // WE HAVE TO DO THIS BECAUSE PARSE(.memberwise) SUPPORTS UP TO 10 fields. You fix this by nested Parse in Parse, but then the result is a tuple of tuples you have to convert back to and from a single tuple.
                    Parse(
                        .convert(
                            apply: { (
                                first: (
                                    Date?,
                                    Date?,
                                    Events.List.Query.Ascending?,
                                    Int?,
                                    Events.Event.Variant?,
                                    String?,
                                    String?,
                                    EmailAddress?,
                                    String?,
                                    String?
                                ),
                                second: (
                                    EmailAddress?,
                                    Int?,
                                    EmailAddress?,
                                    [EmailAddress]?,
                                    [String]?,
                                    Severity?
                                )
                            )
                                -> (
                                    Date?,
                                    Date?,
                                    Events.List.Query.Ascending?,
                                    Int?,
                                    Events.Event.Variant?,
                                    String?,
                                    String?,
                                    EmailAddress?,
                                    String?,
                                    String?,
                                    EmailAddress?,
                                    Int?,
                                    EmailAddress?,
                                    [EmailAddress]?,
                                    [String]?,
                                    Severity?
                                ) in
                                (
                                    first.0,
                                    first.1,
                                    first.2,
                                    first.3,
                                    first.4,
                                    first.5,
                                    first.6,
                                    first.7,
                                    first.8,
                                    first.9,
                                    second.0,
                                    second.1,
                                    second.2,
                                    second.3,
                                    second.4,
                                    second.5
                                )
                            },
                            unapply: { (
                                tuple: (
                                    Date?,
                                    Date?,
                                    Events.List.Query.Ascending?,
                                    Int?,
                                    Events.Event.Variant?,
                                    String?,
                                    String?,
                                    EmailAddress?,
                                    String?,
                                    String?,
                                    EmailAddress?,
                                    Int?,
                                    EmailAddress?,
                                    [EmailAddress]?,
                                    [String]?,
                                    Severity?
                                )
                            )
                                -> (
                                    (
                                        Date?,
                                        Date?,
                                        Events.List.Query.Ascending?,
                                        Int?,
                                        Events.Event.Variant?,
                                        String?,
                                        String?,
                                        EmailAddress?,
                                        String?,
                                        String?
                                    ),
                                    (
                                        EmailAddress?,
                                        Int?,
                                        EmailAddress?,
                                        [EmailAddress]?,
                                        [String]?,
                                        Severity?
                                    )
                                ) in
                                (
                                    (
                                        tuple.0,
                                        tuple.1,
                                        tuple.2,
                                        tuple.3,
                                        tuple.4,
                                        tuple.5,
                                        tuple.6,
                                        tuple.7,
                                        tuple.8,
                                        tuple.9
                                    ),
                                    (
                                        tuple.10,
                                        tuple.11,
                                        tuple.12,
                                        tuple.13,
                                        tuple.14,
                                        tuple.15
                                    )
                                )
                            }
                        )
                    ) {
                        Parse {
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
                        }
                        
                        Parse {
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
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe)
    public static let events: Path<PathBuilder.Component<String>> = Path {
        "events"
    }
}
