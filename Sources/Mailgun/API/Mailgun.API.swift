//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//


import ServerFoundation
import Credentials
import CustomMessageLimit
import Domains
import Events
import IPAllowlist
import IPPools
import IPs
import Keys
import Lists
import Messages
import Reporting
import Routes
import Subaccounts
import Suppressions
import Tags
import Templates
import Users
import Webhooks
import Shared

extension Mailgun {
    public enum API: Equatable, Sendable {
        case messages(Messages.API)
        case lists(Lists.API)
        case events(Events.API)
        case suppressions(Suppressions.API)
        case webhooks(Webhooks.API)
    }
}

extension Mailgun.API {
    public struct Router: ParserPrinter, Sendable {
        
        public var body: some URLRouting.Router<Mailgun.API> {
            OneOf {
                URLRouting.Route(.case(Mailgun.API.messages)) {
                    Messages.API.Router()
                }
                
                URLRouting.Route(.case(Mailgun.API.lists)) {
                    Lists.API.Router()
                }
                
                URLRouting.Route(.case(Mailgun.API.events)) {
                    Events.API.Router()
                }
                
                URLRouting.Route(.case(Mailgun.API.suppressions)) {
                    Suppressions.API.Router()
                }
                
                URLRouting.Route(.case(Mailgun.API.webhooks)) {
                    Webhooks.API.Router()
                }
            }
        }
    }
}

public enum MailgunRouterKey: TestDependencyKey {
    public static let testValue: Mailgun.API.Router = .init()
}

extension MailgunRouterKey: DependencyKey {
    public static let liveValue: Mailgun.API.Router = .init()
}

extension DependencyValues {
    public var mailgunRouter: Mailgun.API.Router {
        get { self[MailgunRouterKey.self] }
        set { self[MailgunRouterKey.self] = newValue }
    }
}
