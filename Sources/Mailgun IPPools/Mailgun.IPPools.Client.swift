import Mailgun_Standard

extension Mailgun.IPPools {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list: @Sendable () async throws(Failure) -> Mailgun.IPPools.List.Response
        public var create:
            @Sendable (_ request: Mailgun.IPPools.Create.Request) async throws(Failure) ->
                Mailgun.IPPools.Create.Response
        public var get: @Sendable (_ poolId: String) async throws(Failure) -> Mailgun.IPPools.IPPool
        public var update:
            @Sendable (_ poolId: String, _ request: Mailgun.IPPools.Update.Request)
                async throws(Failure) -> Mailgun.IPPools.Update.Response
        public var delete:
            @Sendable (_ poolId: String, _ request: Mailgun.IPPools.Delete.Request?)
                async throws(Failure) -> Mailgun.IPPools.Delete.Response
        public var listDomains:
            @Sendable (_ poolId: String) async throws(Failure) ->
                Mailgun.IPPools.DomainsList.Response

        public init(
            list: @escaping @Sendable () async throws(Failure) -> Mailgun.IPPools.List.Response,
            create:
                @escaping @Sendable (_ request: Mailgun.IPPools.Create.Request)
                async throws(Failure) -> Mailgun.IPPools.Create.Response,
            get:
                @escaping @Sendable (_ poolId: String) async throws(Failure) ->
                Mailgun.IPPools.IPPool,
            update:
                @escaping @Sendable (_ poolId: String, _ request: Mailgun.IPPools.Update.Request)
                async throws(Failure) -> Mailgun.IPPools.Update.Response,
            delete:
                @escaping @Sendable (_ poolId: String, _ request: Mailgun.IPPools.Delete.Request?)
                async throws(Failure) -> Mailgun.IPPools.Delete.Response,
            listDomains:
                @escaping @Sendable (_ poolId: String) async throws(Failure) ->
                Mailgun.IPPools.DomainsList.Response
        ) {
            self.list = list
            self.create = create
            self.get = get
            self.update = update
            self.delete = delete
            self.listDomains = listDomains
        }
    }
}
