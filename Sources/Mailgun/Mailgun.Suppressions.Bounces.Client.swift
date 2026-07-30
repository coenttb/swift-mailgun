extension Mailgun.Suppressions.Bounces {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var importList:
            @Sendable (_ csv: [UInt8]) async throws(Failure) ->
                Mailgun.Suppressions.Bounces.Import.Response
        public var get:
            @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Bounces.Record
        public var delete:
            @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Bounces.Delete.Response
        public var list:
            @Sendable (_ request: Mailgun.Suppressions.Bounces.List.Request?) async throws(Failure)
                -> Mailgun.Suppressions.Bounces.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Suppressions.Bounces.Create.Request) async throws(Failure)
                -> Mailgun.Suppressions.Bounces.Create.Response
        public var deleteAll:
            @Sendable () async throws(Failure) -> Mailgun.Suppressions.Bounces.Delete.All.Response

        public init(
            importList:
                @escaping @Sendable (_ csv: [UInt8]) async throws(Failure) ->
                Mailgun.Suppressions.Bounces.Import.Response,
            get:
                @escaping @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Bounces.Record,
            delete:
                @escaping @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Bounces.Delete.Response,
            list:
                @escaping @Sendable (_ request: Mailgun.Suppressions.Bounces.List.Request?)
                async throws(Failure) -> Mailgun.Suppressions.Bounces.List.Response,
            create:
                @escaping @Sendable (_ request: Mailgun.Suppressions.Bounces.Create.Request)
                async throws(Failure) -> Mailgun.Suppressions.Bounces.Create.Response,
            deleteAll:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.Suppressions.Bounces.Delete.All.Response
        ) {
            self.importList = importList
            self.get = get
            self.delete = delete
            self.list = list
            self.create = create
            self.deleteAll = deleteAll
        }
    }
}
