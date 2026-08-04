import Mailgun_Standard

extension Mailgun.Reporting.Stats {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var total:
            @Sendable (_ request: Mailgun.Reporting.Stats.Total.Request) async throws(Failure) ->
                Mailgun.Reporting.Stats.StatsList
        public var filter:
            @Sendable (_ request: Mailgun.Reporting.Stats.Filter.Request) async throws(Failure) ->
                Mailgun.Reporting.Stats.StatsList
        public var aggregateProviders:
            @Sendable () async throws(Failure) -> Mailgun.Reporting.Stats.AggregatesProviders
        public var aggregateDevices:
            @Sendable () async throws(Failure) -> Mailgun.Reporting.Stats.AggregatesDevices
        public var aggregateCountries:
            @Sendable () async throws(Failure) -> Mailgun.Reporting.Stats.AggregatesCountries

        public init(
            total:
                @escaping @Sendable (_ request: Mailgun.Reporting.Stats.Total.Request)
                async throws(Failure) -> Mailgun.Reporting.Stats.StatsList,
            filter:
                @escaping @Sendable (_ request: Mailgun.Reporting.Stats.Filter.Request)
                async throws(Failure) -> Mailgun.Reporting.Stats.StatsList,
            aggregateProviders:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.Reporting.Stats.AggregatesProviders,
            aggregateDevices:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.Reporting.Stats.AggregatesDevices,
            aggregateCountries:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.Reporting.Stats.AggregatesCountries
        ) {
            self.total = total
            self.filter = filter
            self.aggregateProviders = aggregateProviders
            self.aggregateDevices = aggregateDevices
            self.aggregateCountries = aggregateCountries
        }
    }
}
