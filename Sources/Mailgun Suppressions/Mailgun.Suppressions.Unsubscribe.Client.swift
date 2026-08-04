import EmailAddress_Standard
import Mailgun_Standard

extension Mailgun.Suppressions.Unsubscribe {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var importList:
            @Sendable (_ csv: [UInt8]) async throws(Failure) ->
                Mailgun.Suppressions.Unsubscribe.Import.Response
        public var get:
            @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Unsubscribe.Get.Response
        public var delete:
            @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Unsubscribe.Delete.Response
        public var list:
            @Sendable (_ request: Mailgun.Suppressions.Unsubscribe.List.Request?)
                async throws(Failure) -> Mailgun.Suppressions.Unsubscribe.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Suppressions.Unsubscribe.Create.Request)
                async throws(Failure) -> Mailgun.Suppressions.Unsubscribe.Create.Response
        public var deleteAll:
            @Sendable () async throws(Failure) ->
                Mailgun.Suppressions.Unsubscribe.DeleteAll.Response

        public init(
            importList:
                @escaping @Sendable (_ csv: [UInt8]) async throws(Failure) ->
                Mailgun.Suppressions.Unsubscribe.Import.Response,
            get:
                @escaping @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Unsubscribe.Get.Response,
            delete:
                @escaping @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Unsubscribe.Delete.Response,
            list:
                @escaping @Sendable (_ request: Mailgun.Suppressions.Unsubscribe.List.Request?)
                async throws(Failure) -> Mailgun.Suppressions.Unsubscribe.List.Response,
            create:
                @escaping @Sendable (_ request: Mailgun.Suppressions.Unsubscribe.Create.Request)
                async throws(Failure) -> Mailgun.Suppressions.Unsubscribe.Create.Response,
            deleteAll:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.Suppressions.Unsubscribe.DeleteAll.Response
        ) {
            self.importList = importList
            self.get = get
            self.delete = delete
            self.list = list
            self.create = create
            self.deleteAll = deleteAll
        }
    }
}
