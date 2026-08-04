import Mailgun_Standard
import EmailAddress_Standard

extension Mailgun.Suppressions.Complaints {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var importList:
            @Sendable (_ request: Mailgun.Suppressions.Complaints.Import.Request)
                async throws(Failure) -> Mailgun.Suppressions.Complaints.Import.Response
        public var get:
            @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Complaints.Get.Response
        public var delete:
            @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Complaints.Delete.Response
        public var list:
            @Sendable (_ request: Mailgun.Suppressions.Complaints.List.Request?)
                async throws(Failure) -> Mailgun.Suppressions.Complaints.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Suppressions.Complaints.Create.Request)
                async throws(Failure) -> Mailgun.Suppressions.Complaints.Create.Response
        public var deleteAll:
            @Sendable () async throws(Failure) ->
                Mailgun.Suppressions.Complaints.Delete.All.Response

        public init(
            importList:
                @escaping @Sendable (_ request: Mailgun.Suppressions.Complaints.Import.Request)
                async throws(Failure) -> Mailgun.Suppressions.Complaints.Import.Response,
            get:
                @escaping @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Complaints.Get.Response,
            delete:
                @escaping @Sendable (_ address: EmailAddress) async throws(Failure) ->
                Mailgun.Suppressions.Complaints.Delete.Response,
            list:
                @escaping @Sendable (_ request: Mailgun.Suppressions.Complaints.List.Request?)
                async throws(Failure) -> Mailgun.Suppressions.Complaints.List.Response,
            create:
                @escaping @Sendable (_ request: Mailgun.Suppressions.Complaints.Create.Request)
                async throws(Failure) -> Mailgun.Suppressions.Complaints.Create.Response,
            deleteAll:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.Suppressions.Complaints.Delete.All.Response
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
