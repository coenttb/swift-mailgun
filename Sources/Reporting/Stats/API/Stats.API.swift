//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import CoenttbWeb
import Shared

extension Stats {
    public enum API: Equatable, Sendable {
        case total(request: Stats.Total.Request)
        case filter(request: Stats.Filter.Request)
        case aggregateProviders(domain: Domain)
        case aggregateDevices(domain: Domain)
        case aggregateCountries(domain: Domain)
    }
}

extension Stats.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Stats.API> {
            OneOf {
                URLRouting.Route(.case(Stats.API.total)) {
                    Method.get
                    Path.v3
                    Path.stats
                    Path.total
                    Parse(.memberwise(Stats.Total.Request.init)) {
                        URLRouting.Query {
                            Field("event") { Parse(.string) }
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
                        }
                    }
                }
                
                URLRouting.Route(.case(Stats.API.filter)) {
                    Method.get
                    Path.v3
                    Path.stats
                    Path.filter
                    Parse(.memberwise(Stats.Filter.Request.init)) {
                        URLRouting.Query {
                            Field("event") { Parse(.string) }
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
                                Field("filter") { Parse(.string) }
                            }
                            Optionally {
                                Field("group") { Parse(.string) }
                            }
                        }
                    }
                }
                
                URLRouting.Route(.case(Stats.API.aggregateProviders)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.aggregates
                    Path.providers
                }
                
                URLRouting.Route(.case(Stats.API.aggregateDevices)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.aggregates
                    Path.devices
                }
                
                URLRouting.Route(.case(Stats.API.aggregateCountries)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.aggregates
                    Path.countries
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe)
    public static let stats: Path<PathBuilder.Component<String>> = Path {
        "stats"
    }
    
    nonisolated(unsafe)
    public static let total: Path<PathBuilder.Component<String>> = Path {
        "total"
    }
    
    nonisolated(unsafe)
    public static let filter: Path<PathBuilder.Component<String>> = Path {
        "filter"
    }
    
    nonisolated(unsafe)
    public static let aggregates: Path<PathBuilder.Component<String>> = Path {
        "aggregates"
    }
    
    nonisolated(unsafe)
    public static let providers: Path<PathBuilder.Component<String>> = Path {
        "providers"
    }
    
    nonisolated(unsafe)
    public static let devices: Path<PathBuilder.Component<String>> = Path {
        "devices"
    }
    
    nonisolated(unsafe)
    public static let countries: Path<PathBuilder.Component<String>> = Path {
        "countries"
    }
}
