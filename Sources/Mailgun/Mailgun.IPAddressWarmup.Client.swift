extension Mailgun.IPAddressWarmup {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list: @Sendable () async throws(Failure) -> Mailgun.IPAddressWarmup.List.Response
        public var get:
            @Sendable (_ ip: String) async throws(Failure) -> Mailgun.IPAddressWarmup.IPWarmup
        public var create:
            @Sendable (_ ip: String, _ request: Mailgun.IPAddressWarmup.Create.Request)
                async throws(Failure) -> Mailgun.IPAddressWarmup.Create.Response
        public var delete:
            @Sendable (_ ip: String) async throws(Failure) ->
                Mailgun.IPAddressWarmup.Delete.Response

        public init(
            list:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.IPAddressWarmup.List.Response,
            get:
                @escaping @Sendable (_ ip: String) async throws(Failure) ->
                Mailgun.IPAddressWarmup.IPWarmup,
            create:
                @escaping @Sendable (
                    _ ip: String, _ request: Mailgun.IPAddressWarmup.Create.Request
                ) async throws(Failure) -> Mailgun.IPAddressWarmup.Create.Response,
            delete:
                @escaping @Sendable (_ ip: String) async throws(Failure) ->
                Mailgun.IPAddressWarmup.Delete.Response
        ) {
            self.list = list
            self.get = get
            self.create = create
            self.delete = delete
        }
    }
}
