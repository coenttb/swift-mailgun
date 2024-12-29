//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import CoenttbWeb
import Shared

extension Metrics {
    public enum API: Equatable, Sendable {
        case getAccountMetrics(request: GetAccountMetrics.Request)
        case getAccountUsageMetrics(request: GetAccountUsageMetrics.Request)
    }
}

extension Metrics.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Metrics.API> {
            OneOf {
                // POST /v1/analytics/metrics
                URLRouting.Route(.case(Metrics.API.getAccountMetrics)) {
                    Method.post
                    Path.v1
                    Path.analytics
                    Path.metrics
                    Body(.json(Metrics.GetAccountMetrics.Request.self))
                }
                
                // POST /v1/analytics/usage/metrics
                URLRouting.Route(.case(Metrics.API.getAccountUsageMetrics)) {
                    Method.post
                    Path.v1
                    Path.analytics
                    Path.usage
                    Path.metrics
                    Body(.json(Metrics.GetAccountUsageMetrics.Request.self))
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe)
    public static let analytics: Path<PathBuilder.Component<String>> = Path {
        "analytics"
    }
    
    nonisolated(unsafe)
    public static let metrics: Path<PathBuilder.Component<String>> = Path {
        "metrics"
    }
    
    nonisolated(unsafe)
    public static let usage: Path<PathBuilder.Component<String>> = Path {
        "usage"
    }
}
