extension Mailgun.Users {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list:
            @Sendable (_ request: Mailgun.Users.List.Request?) async throws(Failure) ->
                Mailgun.Users.List.Response
        public var get:
            @Sendable (_ userId: String) async throws(Failure) -> Mailgun.Users.Get.Response
        public var me: @Sendable () async throws(Failure) -> Mailgun.Users.Me.Response
        public var addToOrganization:
            @Sendable (_ userId: String, _ orgId: String) async throws(Failure) ->
                Mailgun.Users.Organization.Add.Response
        public var removeFromOrganization:
            @Sendable (_ userId: String, _ orgId: String) async throws(Failure) ->
                Mailgun.Users.Organization.Remove.Response

        public init(
            list:
                @escaping @Sendable (_ request: Mailgun.Users.List.Request?) async throws(Failure)
                -> Mailgun.Users.List.Response,
            get:
                @escaping @Sendable (_ userId: String) async throws(Failure) ->
                Mailgun.Users.Get.Response,
            me: @escaping @Sendable () async throws(Failure) -> Mailgun.Users.Me.Response,
            addToOrganization:
                @escaping @Sendable (_ userId: String, _ orgId: String) async throws(Failure) ->
                Mailgun.Users.Organization.Add.Response,
            removeFromOrganization:
                @escaping @Sendable (_ userId: String, _ orgId: String) async throws(Failure) ->
                Mailgun.Users.Organization.Remove.Response
        ) {
            self.list = list
            self.get = get
            self.me = me
            self.addToOrganization = addToOrganization
            self.removeFromOrganization = removeFromOrganization
        }
    }
}
