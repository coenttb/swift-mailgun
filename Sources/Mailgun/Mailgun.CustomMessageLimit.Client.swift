extension Mailgun.CustomMessageLimit {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var getMonthlyLimit:
            @Sendable () async throws(Failure) -> Mailgun.CustomMessageLimit.Monthly.Get.Response
        public var setMonthlyLimit:
            @Sendable (_ request: Mailgun.CustomMessageLimit.Monthly.Set.Request)
                async throws(Failure) -> Mailgun.CustomMessageLimit.Monthly.Set.Response
        public var deleteMonthlyLimit:
            @Sendable () async throws(Failure) -> Mailgun.CustomMessageLimit.Monthly.Delete.Response
        public var enableAccount:
            @Sendable () async throws(Failure) -> Mailgun.CustomMessageLimit.EnableAccount.Response

        public init(
            getMonthlyLimit:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.CustomMessageLimit.Monthly.Get.Response,
            setMonthlyLimit:
                @escaping @Sendable (_ request: Mailgun.CustomMessageLimit.Monthly.Set.Request)
                async throws(Failure) -> Mailgun.CustomMessageLimit.Monthly.Set.Response,
            deleteMonthlyLimit:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.CustomMessageLimit.Monthly.Delete.Response,
            enableAccount:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.CustomMessageLimit.EnableAccount.Response
        ) {
            self.getMonthlyLimit = getMonthlyLimit
            self.setMonthlyLimit = setMonthlyLimit
            self.deleteMonthlyLimit = deleteMonthlyLimit
            self.enableAccount = enableAccount
        }
    }
}
