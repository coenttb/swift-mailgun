extension Mailgun {
    public struct Client<Failure: Swift.Error>: Sendable {
        public let messages: Mailgun.Messages.Client<Failure>
        public let mailingLists: Mailgun.Lists.Client<Failure>
        public let events: Mailgun.Reporting.Events.Client<Failure>
        public let suppressions: Mailgun.Suppressions.Client<Failure>
        public let webhooks: Mailgun.Webhooks.Client<Failure>
        public let domains: Mailgun.Domains.Client<Failure>
        public let templates: Mailgun.Templates.Client<Failure>
        public let routes: Mailgun.Routes.Client<Failure>
        public let ips: Mailgun.IPs.Client<Failure>
        public let ipPools: Mailgun.IPPools.Client<Failure>
        public let ipAllowlist: Mailgun.IPAllowlist.Client<Failure>
        public let keys: Mailgun.Keys.Client<Failure>
        public let users: Mailgun.Users.Client<Failure>
        public let subaccounts: Mailgun.Subaccounts.Client<Failure>
        public let credentials: Mailgun.Credentials.Client<Failure>
        public let customMessageLimit: Mailgun.CustomMessageLimit.Client<Failure>
        public let accountManagement: Mailgun.AccountManagement.Client<Failure>
        public let reporting: Mailgun.Reporting.Client<Failure>

        public init(
            messages: Mailgun.Messages.Client<Failure>,
            mailingLists: Mailgun.Lists.Client<Failure>,
            events: Mailgun.Reporting.Events.Client<Failure>,
            suppressions: Mailgun.Suppressions.Client<Failure>,
            webhooks: Mailgun.Webhooks.Client<Failure>,
            domains: Mailgun.Domains.Client<Failure>,
            templates: Mailgun.Templates.Client<Failure>,
            routes: Mailgun.Routes.Client<Failure>,
            ips: Mailgun.IPs.Client<Failure>,
            ipPools: Mailgun.IPPools.Client<Failure>,
            ipAllowlist: Mailgun.IPAllowlist.Client<Failure>,
            keys: Mailgun.Keys.Client<Failure>,
            users: Mailgun.Users.Client<Failure>,
            subaccounts: Mailgun.Subaccounts.Client<Failure>,
            credentials: Mailgun.Credentials.Client<Failure>,
            customMessageLimit: Mailgun.CustomMessageLimit.Client<Failure>,
            accountManagement: Mailgun.AccountManagement.Client<Failure>,
            reporting: Mailgun.Reporting.Client<Failure>
        ) {
            self.messages = messages
            self.mailingLists = mailingLists
            self.events = events
            self.suppressions = suppressions
            self.webhooks = webhooks
            self.domains = domains
            self.templates = templates
            self.routes = routes
            self.ips = ips
            self.ipPools = ipPools
            self.ipAllowlist = ipAllowlist
            self.keys = keys
            self.users = users
            self.subaccounts = subaccounts
            self.credentials = credentials
            self.customMessageLimit = customMessageLimit
            self.accountManagement = accountManagement
            self.reporting = reporting
        }
    }
}
