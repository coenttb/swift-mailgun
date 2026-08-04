import Mailgun_Standard

extension Mailgun.Reporting.Logs {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var analytics:
            @Sendable (_ request: Mailgun.Reporting.Logs.Analytics.Request) async throws(Failure) ->
                Mailgun.Reporting.Logs.Analytics.Response

        public init(
            analytics:
                @escaping @Sendable (_ request: Mailgun.Reporting.Logs.Analytics.Request)
                async throws(Failure) -> Mailgun.Reporting.Logs.Analytics.Response
        ) {
            self.analytics = analytics
        }
    }
}
