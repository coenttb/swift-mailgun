extension Mailgun.DynamicIPPools {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var listHistory:
            @Sendable (_ request: Mailgun.DynamicIPPools.HistoryList.Request) async throws(Failure)
                -> Mailgun.DynamicIPPools.HistoryList.Response
        public var removeOverride:
            @Sendable (_ domain: String) async throws(Failure) ->
                Mailgun.DynamicIPPools.RemoveOverride.Response

        public init(
            listHistory:
                @escaping @Sendable (_ request: Mailgun.DynamicIPPools.HistoryList.Request)
                async throws(Failure) -> Mailgun.DynamicIPPools.HistoryList.Response,
            removeOverride:
                @escaping @Sendable (_ domain: String) async throws(Failure) ->
                Mailgun.DynamicIPPools.RemoveOverride.Response
        ) {
            self.listHistory = listHistory
            self.removeOverride = removeOverride
        }
    }
}
