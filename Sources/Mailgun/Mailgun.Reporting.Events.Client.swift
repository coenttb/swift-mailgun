extension Mailgun.Reporting.Events {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list:
            @Sendable (_ query: Mailgun.Reporting.Events.List.Query?) async throws(Failure) ->
                Mailgun.Reporting.Events.List.Response

        public init(
            list:
                @escaping @Sendable (_ query: Mailgun.Reporting.Events.List.Query?)
                async throws(Failure) -> Mailgun.Reporting.Events.List.Response
        ) {
            self.list = list
        }
    }
}
