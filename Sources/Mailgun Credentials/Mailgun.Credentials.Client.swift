import Mailgun_Standard
import Domain_Standard

extension Mailgun.Credentials {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list:
            @Sendable (_ domain: Domain, _ request: Mailgun.Credentials.List.Request?)
                async throws(Failure) -> Mailgun.Credentials.List.Response
        public var create:
            @Sendable (_ domain: Domain, _ request: Mailgun.Credentials.Create.Request)
                async throws(Failure) -> Mailgun.Credentials.Create.Response
        public var deleteAll:
            @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Credentials.Delete.Response
        public var update:
            @Sendable (
                _ domain: Domain, _ login: String, _ request: Mailgun.Credentials.Update.Request
            ) async throws(Failure) -> Mailgun.Credentials.Update.Response
        public var delete:
            @Sendable (_ domain: Domain, _ login: String) async throws(Failure) ->
                Mailgun.Credentials.Delete.Response
        public var updateMailbox:
            @Sendable (
                _ domain: Domain, _ login: String,
                _ request: Mailgun.Credentials.Mailbox.Update.Request
            ) async throws(Failure) -> Mailgun.Credentials.Mailbox.Update.Response

        public init(
            list:
                @escaping @Sendable (_ domain: Domain, _ request: Mailgun.Credentials.List.Request?)
                async throws(Failure) -> Mailgun.Credentials.List.Response,
            create:
                @escaping @Sendable (
                    _ domain: Domain, _ request: Mailgun.Credentials.Create.Request
                ) async throws(Failure) -> Mailgun.Credentials.Create.Response,
            deleteAll:
                @escaping @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Credentials.Delete.Response,
            update:
                @escaping @Sendable (
                    _ domain: Domain, _ login: String, _ request: Mailgun.Credentials.Update.Request
                ) async throws(Failure) -> Mailgun.Credentials.Update.Response,
            delete:
                @escaping @Sendable (_ domain: Domain, _ login: String) async throws(Failure) ->
                Mailgun.Credentials.Delete.Response,
            updateMailbox:
                @escaping @Sendable (
                    _ domain: Domain, _ login: String,
                    _ request: Mailgun.Credentials.Mailbox.Update.Request
                ) async throws(Failure) -> Mailgun.Credentials.Mailbox.Update.Response
        ) {
            self.list = list
            self.create = create
            self.deleteAll = deleteAll
            self.update = update
            self.delete = delete
            self.updateMailbox = updateMailbox
        }
    }
}
