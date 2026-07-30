extension Mailgun.Suppressions.Allowlist {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var get:
            @Sendable (_ value: String) async throws(Failure) ->
                Mailgun.Suppressions.Allowlist.Record
        public var delete:
            @Sendable (_ value: String) async throws(Failure) ->
                Mailgun.Suppressions.Allowlist.Delete.Response
        public var list:
            @Sendable (_ request: Mailgun.Suppressions.Allowlist.List.Request?)
                async throws(Failure) -> Mailgun.Suppressions.Allowlist.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Suppressions.Allowlist.Create.Request)
                async throws(Failure) -> Mailgun.Suppressions.Allowlist.Create.Response
        public var deleteAll:
            @Sendable () async throws(Failure) -> Mailgun.Suppressions.Allowlist.Delete.All.Response
        public var importList:
            @Sendable (_ csv: [UInt8]) async throws(Failure) ->
                Mailgun.Suppressions.Allowlist.Import.Response

        public init(
            get:
                @escaping @Sendable (_ value: String) async throws(Failure) ->
                Mailgun.Suppressions.Allowlist.Record,
            delete:
                @escaping @Sendable (_ value: String) async throws(Failure) ->
                Mailgun.Suppressions.Allowlist.Delete.Response,
            list:
                @escaping @Sendable (_ request: Mailgun.Suppressions.Allowlist.List.Request?)
                async throws(Failure) -> Mailgun.Suppressions.Allowlist.List.Response,
            create:
                @escaping @Sendable (_ request: Mailgun.Suppressions.Allowlist.Create.Request)
                async throws(Failure) -> Mailgun.Suppressions.Allowlist.Create.Response,
            deleteAll:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.Suppressions.Allowlist.Delete.All.Response,
            importList:
                @escaping @Sendable (_ csv: [UInt8]) async throws(Failure) ->
                Mailgun.Suppressions.Allowlist.Import.Response
        ) {
            self.get = get
            self.delete = delete
            self.list = list
            self.create = create
            self.deleteAll = deleteAll
            self.importList = importList
        }
    }
}
