import Mailgun_Standard

extension Mailgun.Reporting {
    public struct Client<Failure: Swift.Error>: Sendable {
        public let metrics: Mailgun.Reporting.Metrics.Client<Failure>
        public let stats: Mailgun.Reporting.Stats.Client<Failure>
        public let events: Mailgun.Reporting.Events.Client<Failure>
        public let tags: Mailgun.Reporting.Tags.Client<Failure>
        public let logs: Mailgun.Reporting.Logs.Client<Failure>

        public init(
            metrics: Mailgun.Reporting.Metrics.Client<Failure>,
            stats: Mailgun.Reporting.Stats.Client<Failure>,
            events: Mailgun.Reporting.Events.Client<Failure>,
            tags: Mailgun.Reporting.Tags.Client<Failure>,
            logs: Mailgun.Reporting.Logs.Client<Failure>
        ) {
            self.metrics = metrics
            self.stats = stats
            self.events = events
            self.tags = tags
            self.logs = logs
        }
    }
}
