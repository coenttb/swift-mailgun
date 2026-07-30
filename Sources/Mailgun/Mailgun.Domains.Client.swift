extension Mailgun.Domains {
    @dynamicMemberLookup
    public struct Client<Failure: Swift.Error>: Sendable {
        public var domains: Mailgun.Domains.Domains.Client<Failure>
        public var dkim: DKIM
        public var domain: Domain

        public struct DKIM: Sendable {
            public var security: Mailgun.Domains.DKIM_Security.Client<Failure>
        }

        public struct Domain: Sendable {
            public var keys: Mailgun.Domains.DomainKeys.Client<Failure>
            public var tracking: Mailgun.Domains.Domains.Tracking.Client<Failure>
        }

        public init(
            domains: Mailgun.Domains.Domains.Client<Failure>,
            dkimSecurity: Mailgun.Domains.DKIM_Security.Client<Failure>,
            domainKeys: Mailgun.Domains.DomainKeys.Client<Failure>,
            domainTracking: Mailgun.Domains.Domains.Tracking.Client<Failure>
        ) {
            self.domains = domains
            self.dkim = .init(security: dkimSecurity)
            self.domain = .init(keys: domainKeys, tracking: domainTracking)
        }

        public subscript<Subject>(
            dynamicMember keyPath: KeyPath<Mailgun.Domains.Domains.Client<Failure>, Subject>
        ) -> Subject {
            self.domains[keyPath: keyPath]
        }
    }
}
