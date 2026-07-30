extension Mailgun.Webhooks {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list: @Sendable () async throws(Failure) -> Mailgun.Webhooks.List.Response
        public var get:
            @Sendable (_ webhookName: Mailgun.Webhooks.WebhookType) async throws(Failure) ->
                Mailgun.Webhooks.Get.Response
        public var create:
            @Sendable (_ request: Mailgun.Webhooks.Create.Request) async throws(Failure) ->
                Mailgun.Webhooks.Create.Response
        public var update:
            @Sendable (
                _ webhookName: Mailgun.Webhooks.WebhookType,
                _ request: Mailgun.Webhooks.Update.Request
            ) async throws(Failure) -> Mailgun.Webhooks.Update.Response
        public var delete:
            @Sendable (_ webhookName: Mailgun.Webhooks.WebhookType) async throws(Failure) ->
                Mailgun.Webhooks.Delete.Response

        public init(
            list: @escaping @Sendable () async throws(Failure) -> Mailgun.Webhooks.List.Response,
            get:
                @escaping @Sendable (_ webhookName: Mailgun.Webhooks.WebhookType)
                async throws(Failure) -> Mailgun.Webhooks.Get.Response,
            create:
                @escaping @Sendable (_ request: Mailgun.Webhooks.Create.Request)
                async throws(Failure) -> Mailgun.Webhooks.Create.Response,
            update:
                @escaping @Sendable (
                    _ webhookName: Mailgun.Webhooks.WebhookType,
                    _ request: Mailgun.Webhooks.Update.Request
                ) async throws(Failure) -> Mailgun.Webhooks.Update.Response,
            delete:
                @escaping @Sendable (_ webhookName: Mailgun.Webhooks.WebhookType)
                async throws(Failure) -> Mailgun.Webhooks.Delete.Response
        ) {
            self.list = list
            self.get = get
            self.create = create
            self.update = update
            self.delete = delete
        }
    }
}
