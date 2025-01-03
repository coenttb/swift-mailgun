//
//  Tags.API.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import Coenttb_Web
import Foundation
import Shared

public enum API: Equatable, Sendable {
    case list(domain: Domain, request: Tag.List.Request)
    case get(domain: Domain, tag: String)
    case update(domain: Domain, tag: String, description: String?)
    case delete(domain: Domain, tag: String)
    case stats(domain: Domain, tag: String, request: Tag.Stats.Request)
    case aggregates(domain: Domain, tag: String, request: Tag.Aggregates.Request)
    case limits(domain: Domain)
}

extension API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<API> {
            OneOf {
                // List tags
                Route(.case(API.list)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tags
                    Parse(.memberwise(Tag.List.Request.init)) {
                        Query {
                            Optionally {
                                Field("page") { Parse(.string) }
                            }
                            Optionally {
                                Field("limit") { Digits() }
                            }
                        }
                    }
                }
                
                // Get a tag
                Route(.case(API.get)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                }
                
                // Update tag description
                Route(.case(API.update)) {
                    Method.put
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                    Optionally {
                        Query {
                            Field("description") { Parse(.string) }
                        }
                    }
                }
                
                // Delete tag
                Route(.case(API.delete)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                }
                
                // Get tag stats
                Route(.case(API.stats)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Path.stats
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                    Parse(.memberwise(Tag.Stats.Request.init)) {
                        Query {
                            Field("event") {
                                Many {
                                    Parse(.string)
                                }
                            }
                            Optionally {
                                Field("start") { Parse(.string) }
                            }
                            Optionally {
                                Field("end") { Parse(.string) }
                            }
                            Optionally {
                                Field("resolution") { Parse(.string) }
                            }
                            Optionally {
                                Field("duration") { Parse(.string) }
                            }
                            Optionally {
                                Field("provider") { Parse(.string) }
                            }
                            Optionally {
                                Field("device") { Parse(.string) }
                            }
                            Optionally {
                                Field("country") { Parse(.string) }
                            }
                        }
                    }
                }
                
                // Get tag aggregates
                Route(.case(API.aggregates)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.tag
                    Path.stats
                    Path.aggregates
                    Query {
                        Field("tag") { Parse(.string) }
                    }
                    Parse(.memberwise(Tag.Aggregates.Request.init)) {
                        Query {
                            Field("type") { Parse(.string) }
                        }
                    }
                }
                
                // Get tag limits
                Route(.case(API.limits)) {
                    Method.get
                    Path.v3
                    Path.domains
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.limits
                    Path.tag
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe)
    public static let tags: Path<PathBuilder.Component<String>> = Path {
        "tags"
    }
    
    nonisolated(unsafe)
    public static let tag: Path<PathBuilder.Component<String>> = Path {
        "tag"
    }
    
    nonisolated(unsafe)
    public static let stats: Path<PathBuilder.Component<String>> = Path {
        "stats"
    }
    
    nonisolated(unsafe)
    public static let aggregates: Path<PathBuilder.Component<String>> = Path {
        "aggregates"
    }
    
    nonisolated(unsafe)
    public static let domains: Path<PathBuilder.Component<String>> = Path {
        "domains"
    }
    
    nonisolated(unsafe)
    public static let limits: Path<PathBuilder.Component<String>> = Path {
        "limits"
    }
}

extension UrlFormDecoder {
    fileprivate static var `default`: UrlFormDecoder {
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        return decoder
    }
}
