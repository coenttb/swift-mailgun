import Mailgun_Standard
import Domain_Standard

extension Mailgun.Domains.Domains {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list:
            @Sendable (_ request: Mailgun.Domains.Domains.List.Request?) async throws(Failure) ->
                Mailgun.Domains.Domains.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Domains.Domains.Create.Request) async throws(Failure) ->
                Mailgun.Domains.Domains.Create.Response
        public var get:
            @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Domains.Domains.Get.Response
        public var update:
            @Sendable (_ domain: Domain, _ request: Mailgun.Domains.Domains.Update.Request)
                async throws(Failure) -> Mailgun.Domains.Domains.Update.Response
        public var delete:
            @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Domains.Domains.Delete.Response
        public var verify:
            @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Domains.Domains.Verify.Response

        public init(
            list:
                @escaping @Sendable (_ request: Mailgun.Domains.Domains.List.Request?)
                async throws(Failure) -> Mailgun.Domains.Domains.List.Response,
            create:
                @escaping @Sendable (_ request: Mailgun.Domains.Domains.Create.Request)
                async throws(Failure) -> Mailgun.Domains.Domains.Create.Response,
            get:
                @escaping @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Domains.Domains.Get.Response,
            update:
                @escaping @Sendable (
                    _ domain: Domain, _ request: Mailgun.Domains.Domains.Update.Request
                ) async throws(Failure) -> Mailgun.Domains.Domains.Update.Response,
            delete:
                @escaping @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Domains.Domains.Delete.Response,
            verify:
                @escaping @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Domains.Domains.Verify.Response
        ) {
            self.list = list
            self.create = create
            self.get = get
            self.update = update
            self.delete = delete
            self.verify = verify
        }
    }
}
