import Mailgun_Standard

extension Mailgun.Reporting.Metrics {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var getAccountMetrics:
            @Sendable (_ request: Mailgun.Reporting.Metrics.GetAccountMetrics.Request)
                async throws(Failure) -> Mailgun.Reporting.Metrics.GetAccountMetrics.Response
        public var getAccountUsageMetrics:
            @Sendable (_ request: Mailgun.Reporting.Metrics.GetAccountUsageMetrics.Request)
                async throws(Failure) -> Mailgun.Reporting.Metrics.GetAccountUsageMetrics.Response

        public init(
            getAccountMetrics:
                @escaping @Sendable (_ request: Mailgun.Reporting.Metrics.GetAccountMetrics.Request)
                async throws(Failure) -> Mailgun.Reporting.Metrics.GetAccountMetrics.Response,
            getAccountUsageMetrics:
                @escaping @Sendable (
                    _ request: Mailgun.Reporting.Metrics.GetAccountUsageMetrics.Request
                ) async throws(Failure) -> Mailgun.Reporting.Metrics.GetAccountUsageMetrics.Response
        ) {
            self.getAccountMetrics = getAccountMetrics
            self.getAccountUsageMetrics = getAccountUsageMetrics
        }
    }
}
