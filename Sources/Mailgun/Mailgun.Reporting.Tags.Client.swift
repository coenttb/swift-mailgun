extension Mailgun.Reporting.Tags {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list:
            @Sendable (_ request: Mailgun.Reporting.Tags.List.Request?) async throws(Failure) ->
                Mailgun.Reporting.Tags.List.Response
        public var get:
            @Sendable (_ tag: String) async throws(Failure) -> Mailgun.Reporting.Tags.Get.Response
        public var update:
            @Sendable (_ tag: String, _ request: Mailgun.Reporting.Tags.Update.Request)
                async throws(Failure) -> Mailgun.Reporting.Tags.Update.Response
        public var delete:
            @Sendable (_ tag: String) async throws(Failure) ->
                Mailgun.Reporting.Tags.Delete.Response
        public var stats:
            @Sendable (_ tag: String, _ request: Mailgun.Reporting.Tags.Stats.Request)
                async throws(Failure) -> Mailgun.Reporting.Tags.Stats.Response
        public var aggregates:
            @Sendable (_ tag: String, _ request: Mailgun.Reporting.Tags.Aggregates.Request)
                async throws(Failure) -> Mailgun.Reporting.Tags.Aggregates.Response
        public var limits:
            @Sendable () async throws(Failure) -> Mailgun.Reporting.Tags.Limits.Response

        public init(
            list:
                @escaping @Sendable (_ request: Mailgun.Reporting.Tags.List.Request?)
                async throws(Failure) -> Mailgun.Reporting.Tags.List.Response,
            get:
                @escaping @Sendable (_ tag: String) async throws(Failure) ->
                Mailgun.Reporting.Tags.Get.Response,
            update:
                @escaping @Sendable (
                    _ tag: String, _ request: Mailgun.Reporting.Tags.Update.Request
                ) async throws(Failure) -> Mailgun.Reporting.Tags.Update.Response,
            delete:
                @escaping @Sendable (_ tag: String) async throws(Failure) ->
                Mailgun.Reporting.Tags.Delete.Response,
            stats:
                @escaping @Sendable (_ tag: String, _ request: Mailgun.Reporting.Tags.Stats.Request)
                async throws(Failure) -> Mailgun.Reporting.Tags.Stats.Response,
            aggregates:
                @escaping @Sendable (
                    _ tag: String, _ request: Mailgun.Reporting.Tags.Aggregates.Request
                ) async throws(Failure) -> Mailgun.Reporting.Tags.Aggregates.Response,
            limits:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.Reporting.Tags.Limits.Response
        ) {
            self.list = list
            self.get = get
            self.update = update
            self.delete = delete
            self.stats = stats
            self.aggregates = aggregates
            self.limits = limits
        }
    }
}
