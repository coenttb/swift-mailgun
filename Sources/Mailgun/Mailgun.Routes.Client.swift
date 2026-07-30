extension Mailgun.Routes {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var create:
            @Sendable (_ request: Mailgun.Routes.Create.Request) async throws(Failure) ->
                Mailgun.Routes.Create.Response
        public var list:
            @Sendable (_ limit: Int?, _ skip: Int?) async throws(Failure) ->
                Mailgun.Routes.List.Response
        public var get:
            @Sendable (_ id: String) async throws(Failure) -> Mailgun.Routes.Get.Response
        public var update:
            @Sendable (_ id: String, _ request: Mailgun.Routes.Update.Request) async throws(Failure)
                -> Mailgun.Routes.Update.Response
        public var delete:
            @Sendable (_ id: String) async throws(Failure) -> Mailgun.Routes.Delete.Response
        public var match:
            @Sendable (_ address: String) async throws(Failure) -> Mailgun.Routes.Match.Response

        public init(
            create:
                @escaping @Sendable (_ request: Mailgun.Routes.Create.Request) async throws(Failure)
                -> Mailgun.Routes.Create.Response,
            list:
                @escaping @Sendable (_ limit: Int?, _ skip: Int?) async throws(Failure) ->
                Mailgun.Routes.List.Response,
            get:
                @escaping @Sendable (_ id: String) async throws(Failure) ->
                Mailgun.Routes.Get.Response,
            update:
                @escaping @Sendable (_ id: String, _ request: Mailgun.Routes.Update.Request)
                async throws(Failure) -> Mailgun.Routes.Update.Response,
            delete:
                @escaping @Sendable (_ id: String) async throws(Failure) ->
                Mailgun.Routes.Delete.Response,
            match:
                @escaping @Sendable (_ address: String) async throws(Failure) ->
                Mailgun.Routes.Match.Response
        ) {
            self.create = create
            self.list = list
            self.get = get
            self.update = update
            self.delete = delete
            self.match = match
        }
    }
}
