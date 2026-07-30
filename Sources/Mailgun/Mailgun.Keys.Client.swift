extension Mailgun.Keys {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list: @Sendable () async throws(Failure) -> Mailgun.Keys.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Keys.Create.Request) async throws(Failure) ->
                Mailgun.Keys.Create.Response
        public var delete:
            @Sendable (_ keyId: String) async throws(Failure) -> Mailgun.Keys.Delete.Response
        public var addPublicKey:
            @Sendable (_ request: Mailgun.Keys.PublicKey.Request) async throws(Failure) ->
                Mailgun.Keys.PublicKey.Response

        public init(
            list: @escaping @Sendable () async throws(Failure) -> Mailgun.Keys.List.Response,
            create:
                @escaping @Sendable (_ request: Mailgun.Keys.Create.Request) async throws(Failure)
                -> Mailgun.Keys.Create.Response,
            delete:
                @escaping @Sendable (_ keyId: String) async throws(Failure) ->
                Mailgun.Keys.Delete.Response,
            addPublicKey:
                @escaping @Sendable (_ request: Mailgun.Keys.PublicKey.Request)
                async throws(Failure) -> Mailgun.Keys.PublicKey.Response
        ) {
            self.list = list
            self.create = create
            self.delete = delete
            self.addPublicKey = addPublicKey
        }
    }
}
