extension Mailgun.IPAllowlist {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list: @Sendable () async throws(Failure) -> Mailgun.IPAllowlist.ListResponse
        public var update:
            @Sendable (_ request: Mailgun.IPAllowlist.UpdateRequest) async throws(Failure) ->
                Mailgun.IPAllowlist.SuccessResponse
        public var add:
            @Sendable (_ request: Mailgun.IPAllowlist.AddRequest) async throws(Failure) ->
                Mailgun.IPAllowlist.SuccessResponse
        public var delete:
            @Sendable (_ request: Mailgun.IPAllowlist.DeleteRequest) async throws(Failure) ->
                Mailgun.IPAllowlist.SuccessResponse

        public init(
            list: @escaping @Sendable () async throws(Failure) -> Mailgun.IPAllowlist.ListResponse,
            update:
                @escaping @Sendable (_ request: Mailgun.IPAllowlist.UpdateRequest)
                async throws(Failure) -> Mailgun.IPAllowlist.SuccessResponse,
            add:
                @escaping @Sendable (_ request: Mailgun.IPAllowlist.AddRequest)
                async throws(Failure) -> Mailgun.IPAllowlist.SuccessResponse,
            delete:
                @escaping @Sendable (_ request: Mailgun.IPAllowlist.DeleteRequest)
                async throws(Failure) -> Mailgun.IPAllowlist.SuccessResponse
        ) {
            self.list = list
            self.update = update
            self.add = add
            self.delete = delete
        }
    }
}
