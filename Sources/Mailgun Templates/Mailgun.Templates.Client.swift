import Mailgun_Standard

extension Mailgun.Templates {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list:
            @Sendable (_ request: Mailgun.Templates.List.Request?) async throws(Failure) ->
                Mailgun.Templates.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Templates.Create.Request) async throws(Failure) ->
                Mailgun.Templates.Create.Response
        public var deleteAll:
            @Sendable () async throws(Failure) -> Mailgun.Templates.DeleteAll.Response
        public var versions:
            @Sendable (_ templateName: String, _ request: Mailgun.Templates.Versions.Request?)
                async throws(Failure) -> Mailgun.Templates.Versions.Response
        public var createVersion:
            @Sendable (_ templateName: String, _ request: Mailgun.Templates.Version.Create.Request)
                async throws(Failure) -> Mailgun.Templates.Version.Create.Response
        public var get:
            @Sendable (_ templateName: String, _ request: Mailgun.Templates.Get.Request?)
                async throws(Failure) -> Mailgun.Templates.Get.Response
        public var update:
            @Sendable (_ templateName: String, _ request: Mailgun.Templates.Update.Request)
                async throws(Failure) -> Mailgun.Templates.Update.Response
        public var delete:
            @Sendable (_ templateName: String) async throws(Failure) ->
                Mailgun.Templates.Delete.Response
        public var getVersion:
            @Sendable (_ templateName: String, _ versionName: String) async throws(Failure) ->
                Mailgun.Templates.Version.Get.Response
        public var updateVersion:
            @Sendable (
                _ templateName: String, _ versionName: String,
                _ request: Mailgun.Templates.Version.Update.Request
            ) async throws(Failure) -> Mailgun.Templates.Version.Update.Response
        public var deleteVersion:
            @Sendable (_ templateName: String, _ versionName: String) async throws(Failure) ->
                Mailgun.Templates.Version.Delete.Response
        public var copyVersion:
            @Sendable (
                _ templateName: String, _ versionName: String, _ newVersionName: String,
                _ request: Mailgun.Templates.Version.Copy.Request?
            ) async throws(Failure) -> Mailgun.Templates.Version.Copy.Response

        public init(
            list:
                @escaping @Sendable (_ request: Mailgun.Templates.List.Request?)
                async throws(Failure) -> Mailgun.Templates.List.Response,
            create:
                @escaping @Sendable (_ request: Mailgun.Templates.Create.Request)
                async throws(Failure) -> Mailgun.Templates.Create.Response,
            deleteAll:
                @escaping @Sendable () async throws(Failure) -> Mailgun.Templates.DeleteAll.Response,
            versions:
                @escaping @Sendable (
                    _ templateName: String, _ request: Mailgun.Templates.Versions.Request?
                ) async throws(Failure) -> Mailgun.Templates.Versions.Response,
            createVersion:
                @escaping @Sendable (
                    _ templateName: String, _ request: Mailgun.Templates.Version.Create.Request
                ) async throws(Failure) -> Mailgun.Templates.Version.Create.Response,
            get:
                @escaping @Sendable (
                    _ templateName: String, _ request: Mailgun.Templates.Get.Request?
                ) async throws(Failure) -> Mailgun.Templates.Get.Response,
            update:
                @escaping @Sendable (
                    _ templateName: String, _ request: Mailgun.Templates.Update.Request
                ) async throws(Failure) -> Mailgun.Templates.Update.Response,
            delete:
                @escaping @Sendable (_ templateName: String) async throws(Failure) ->
                Mailgun.Templates.Delete.Response,
            getVersion:
                @escaping @Sendable (_ templateName: String, _ versionName: String)
                async throws(Failure) -> Mailgun.Templates.Version.Get.Response,
            updateVersion:
                @escaping @Sendable (
                    _ templateName: String, _ versionName: String,
                    _ request: Mailgun.Templates.Version.Update.Request
                ) async throws(Failure) -> Mailgun.Templates.Version.Update.Response,
            deleteVersion:
                @escaping @Sendable (_ templateName: String, _ versionName: String)
                async throws(Failure) -> Mailgun.Templates.Version.Delete.Response,
            copyVersion:
                @escaping @Sendable (
                    _ templateName: String, _ versionName: String, _ newVersionName: String,
                    _ request: Mailgun.Templates.Version.Copy.Request?
                ) async throws(Failure) -> Mailgun.Templates.Version.Copy.Response
        ) {
            self.list = list
            self.create = create
            self.deleteAll = deleteAll
            self.versions = versions
            self.createVersion = createVersion
            self.get = get
            self.update = update
            self.delete = delete
            self.getVersion = getVersion
            self.updateVersion = updateVersion
            self.deleteVersion = deleteVersion
            self.copyVersion = copyVersion
        }
    }
}
