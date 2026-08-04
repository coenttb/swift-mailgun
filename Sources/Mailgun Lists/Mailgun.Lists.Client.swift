import Mailgun_Standard
import EmailAddress_Standard

extension Mailgun.Lists {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var create:
            @Sendable (_ request: Mailgun.Lists.List.Create.Request) async throws(Failure) ->
                Mailgun.Lists.List.Create.Response
        public var list:
            @Sendable (_ request: Mailgun.Lists.List.Request) async throws(Failure) ->
                Mailgun.Lists.List.Response
        public var members:
            @Sendable (_ listAddress: EmailAddress, _ request: Mailgun.Lists.List.Members.Request)
                async throws(Failure) -> Mailgun.Lists.List.Members.Response
        public var addMember:
            @Sendable (_ listAddress: EmailAddress, _ request: Mailgun.Lists.Member.Add.Request)
                async throws(Failure) -> Mailgun.Lists.Member.Add.Response
        public var bulkAdd:
            @Sendable (
                _ listAddress: EmailAddress, _ members: [Mailgun.Lists.Member.Bulk], _ upsert: Bool?
            ) async throws(Failure) -> Mailgun.Lists.Member.Bulk.Response
        public var bulkAddCSV:
            @Sendable (
                _ listAddress: EmailAddress, _ csv: [UInt8], _ subscribed: Bool?, _ upsert: Bool?
            ) async throws(Failure) -> Mailgun.Lists.Member.Bulk.Response
        public var getMember:
            @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress)
                async throws(Failure) -> Mailgun.Lists.Member
        public var updateMember:
            @Sendable (
                _ listAddress: EmailAddress, _ memberAddress: EmailAddress,
                _ request: Mailgun.Lists.Member.Update.Request
            ) async throws(Failure) -> Mailgun.Lists.Member.Update.Response
        public var deleteMember:
            @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress)
                async throws(Failure) -> Mailgun.Lists.Member.Delete.Response
        public var update:
            @Sendable (_ listAddress: EmailAddress, _ request: Mailgun.Lists.List.Update.Request)
                async throws(Failure) -> Mailgun.Lists.List.Update.Response
        public var delete:
            @Sendable (_ listAddress: EmailAddress) async throws(Failure) ->
                Mailgun.Lists.List.Delete.Response
        public var get:
            @Sendable (_ listAddress: EmailAddress) async throws(Failure) ->
                Mailgun.Lists.List.Get.Response
        public var pages:
            @Sendable (_ limit: Int?) async throws(Failure) -> Mailgun.Lists.List.Pages.Response
        public var memberPages:
            @Sendable (
                _ listAddress: EmailAddress, _ request: Mailgun.Lists.List.Members.Pages.Request
            ) async throws(Failure) -> Mailgun.Lists.List.Members.Pages.Response

        public init(
            create:
                @escaping @Sendable (_ request: Mailgun.Lists.List.Create.Request)
                async throws(Failure) -> Mailgun.Lists.List.Create.Response,
            list:
                @escaping @Sendable (_ request: Mailgun.Lists.List.Request) async throws(Failure) ->
                Mailgun.Lists.List.Response,
            members:
                @escaping @Sendable (
                    _ listAddress: EmailAddress, _ request: Mailgun.Lists.List.Members.Request
                ) async throws(Failure) -> Mailgun.Lists.List.Members.Response,
            addMember:
                @escaping @Sendable (
                    _ listAddress: EmailAddress, _ request: Mailgun.Lists.Member.Add.Request
                ) async throws(Failure) -> Mailgun.Lists.Member.Add.Response,
            bulkAdd:
                @escaping @Sendable (
                    _ listAddress: EmailAddress, _ members: [Mailgun.Lists.Member.Bulk],
                    _ upsert: Bool?
                ) async throws(Failure) -> Mailgun.Lists.Member.Bulk.Response,
            bulkAddCSV:
                @escaping @Sendable (
                    _ listAddress: EmailAddress, _ csv: [UInt8], _ subscribed: Bool?,
                    _ upsert: Bool?
                ) async throws(Failure) -> Mailgun.Lists.Member.Bulk.Response,
            getMember:
                @escaping @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress)
                async throws(Failure) -> Mailgun.Lists.Member,
            updateMember:
                @escaping @Sendable (
                    _ listAddress: EmailAddress, _ memberAddress: EmailAddress,
                    _ request: Mailgun.Lists.Member.Update.Request
                ) async throws(Failure) -> Mailgun.Lists.Member.Update.Response,
            deleteMember:
                @escaping @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress)
                async throws(Failure) -> Mailgun.Lists.Member.Delete.Response,
            update:
                @escaping @Sendable (
                    _ listAddress: EmailAddress, _ request: Mailgun.Lists.List.Update.Request
                ) async throws(Failure) -> Mailgun.Lists.List.Update.Response,
            delete:
                @escaping @Sendable (_ listAddress: EmailAddress) async throws(Failure) ->
                Mailgun.Lists.List.Delete.Response,
            get:
                @escaping @Sendable (_ listAddress: EmailAddress) async throws(Failure) ->
                Mailgun.Lists.List.Get.Response,
            pages:
                @escaping @Sendable (_ limit: Int?) async throws(Failure) ->
                Mailgun.Lists.List.Pages.Response,
            memberPages:
                @escaping @Sendable (
                    _ listAddress: EmailAddress, _ request: Mailgun.Lists.List.Members.Pages.Request
                ) async throws(Failure) -> Mailgun.Lists.List.Members.Pages.Response
        ) {
            self.create = create
            self.list = list
            self.members = members
            self.addMember = addMember
            self.bulkAdd = bulkAdd
            self.bulkAddCSV = bulkAddCSV
            self.getMember = getMember
            self.updateMember = updateMember
            self.deleteMember = deleteMember
            self.update = update
            self.delete = delete
            self.get = get
            self.pages = pages
            self.memberPages = memberPages
        }
    }
}
