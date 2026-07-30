extension Mailgun.Subaccounts {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var get:
            @Sendable (_ subaccountId: String) async throws(Failure) ->
                Mailgun.Subaccounts.Get.Response
        public var list:
            @Sendable (_ request: Mailgun.Subaccounts.List.Request?) async throws(Failure) ->
                Mailgun.Subaccounts.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Subaccounts.Create.Request) async throws(Failure) ->
                Mailgun.Subaccounts.Create.Response
        public var delete:
            @Sendable (_ subaccountId: String) async throws(Failure) ->
                Mailgun.Subaccounts.Delete.Response
        public var disable:
            @Sendable (_ subaccountId: String, _ request: Mailgun.Subaccounts.Disable.Request?)
                async throws(Failure) -> Mailgun.Subaccounts.Disable.Response
        public var enable:
            @Sendable (_ subaccountId: String) async throws(Failure) ->
                Mailgun.Subaccounts.Enable.Response
        public var getCustomLimit:
            @Sendable (_ subaccountId: String) async throws(Failure) ->
                Mailgun.Subaccounts.CustomLimit.Get.Response
        public var updateCustomLimit:
            @Sendable (_ subaccountId: String, _ limit: Double) async throws(Failure) ->
                Mailgun.Subaccounts.CustomLimit.Update.Response
        public var deleteCustomLimit:
            @Sendable (_ subaccountId: String) async throws(Failure) ->
                Mailgun.Subaccounts.CustomLimit.Delete.Response
        public var updateFeatures:
            @Sendable (
                _ subaccountId: String, _ request: Mailgun.Subaccounts.Features.Update.Request
            ) async throws(Failure) -> Mailgun.Subaccounts.Features.Update.Response

        public init(
            get:
                @escaping @Sendable (_ subaccountId: String) async throws(Failure) ->
                Mailgun.Subaccounts.Get.Response,
            list:
                @escaping @Sendable (_ request: Mailgun.Subaccounts.List.Request?)
                async throws(Failure) -> Mailgun.Subaccounts.List.Response,
            create:
                @escaping @Sendable (_ request: Mailgun.Subaccounts.Create.Request)
                async throws(Failure) -> Mailgun.Subaccounts.Create.Response,
            delete:
                @escaping @Sendable (_ subaccountId: String) async throws(Failure) ->
                Mailgun.Subaccounts.Delete.Response,
            disable:
                @escaping @Sendable (
                    _ subaccountId: String, _ request: Mailgun.Subaccounts.Disable.Request?
                ) async throws(Failure) -> Mailgun.Subaccounts.Disable.Response,
            enable:
                @escaping @Sendable (_ subaccountId: String) async throws(Failure) ->
                Mailgun.Subaccounts.Enable.Response,
            getCustomLimit:
                @escaping @Sendable (_ subaccountId: String) async throws(Failure) ->
                Mailgun.Subaccounts.CustomLimit.Get.Response,
            updateCustomLimit:
                @escaping @Sendable (_ subaccountId: String, _ limit: Double) async throws(Failure)
                -> Mailgun.Subaccounts.CustomLimit.Update.Response,
            deleteCustomLimit:
                @escaping @Sendable (_ subaccountId: String) async throws(Failure) ->
                Mailgun.Subaccounts.CustomLimit.Delete.Response,
            updateFeatures:
                @escaping @Sendable (
                    _ subaccountId: String, _ request: Mailgun.Subaccounts.Features.Update.Request
                ) async throws(Failure) -> Mailgun.Subaccounts.Features.Update.Response
        ) {
            self.get = get
            self.list = list
            self.create = create
            self.delete = delete
            self.disable = disable
            self.enable = enable
            self.getCustomLimit = getCustomLimit
            self.updateCustomLimit = updateCustomLimit
            self.deleteCustomLimit = deleteCustomLimit
            self.updateFeatures = updateFeatures
        }
    }
}
