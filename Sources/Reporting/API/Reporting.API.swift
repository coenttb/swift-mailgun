//
//  Reporting.API.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Coenttb_Web
import Shared

public enum API: Equatable, Sendable {
    case metrics(Metrics.API)
    case stats(Stats.API)
}

extension Reporting.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Reporting.API> {
            OneOf {
                URLRouting.Route(.case(Reporting.API.metrics)) {
                    Metrics.API.Router()
                }
                URLRouting.Route(.case(Reporting.API.stats)) {
                    Stats.API.Router()
                }
            }
        }
    }
}
