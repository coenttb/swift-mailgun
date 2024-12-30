//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Coenttb_Web
import Shared


public enum API: Equatable, Sendable {
    case bounces(Bounces.API)
    case complaints(Complaints.API)
    case unsubscribe(Unsubscribe.API)
    case whitelist(Whitelist.API)
}

extension Suppressions.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<Suppressions.API> {
            OneOf {
                URLRouting.Route(.case(Suppressions.API.bounces)) {
                    Bounces.API.Router()
                }
                URLRouting.Route(.case(Suppressions.API.complaints)) {
                    Complaints.API.Router()
                }
                URLRouting.Route(.case(Suppressions.API.unsubscribe)) {
                    Unsubscribe.API.Router()
                }
                URLRouting.Route(.case(Suppressions.API.whitelist)) {
                    Whitelist.API.Router()
                }
            }
        }
    }
}
