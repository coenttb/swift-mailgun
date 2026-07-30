extension Mailgun.Domains.DomainKeys {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list:
            @Sendable (_ request: Mailgun.Domains.DomainKeys.List.Request?) async throws(Failure) ->
                Mailgun.Domains.DomainKeys.List.Response
        public var create:
            @Sendable (_ request: Mailgun.Domains.DomainKeys.Create.Request) async throws(Failure)
                -> Mailgun.Domains.DomainKeys.Create.Response
        public var delete:
            @Sendable (_ request: Mailgun.Domains.DomainKeys.Delete.Request) async throws(Failure)
                -> Mailgun.Domains.DomainKeys.Delete.Response
        public var activate:
            @Sendable (_ authorityName: String, _ selector: String) async throws(Failure) ->
                Mailgun.Domains.DomainKeys.Activate.Response
        public var listDomainKeys:
            @Sendable (_ authorityName: String) async throws(Failure) ->
                Mailgun.Domains.DomainKeys.DomainKeysList.Response
        public var deactivate:
            @Sendable (_ authorityName: String, _ selector: String) async throws(Failure) ->
                Mailgun.Domains.DomainKeys.Deactivate.Response
        public var setDkimAuthority:
            @Sendable (
                _ domainName: String, _ request: Mailgun.Domains.DomainKeys.SetDkimAuthority.Request
            ) async throws(Failure) -> Mailgun.Domains.DomainKeys.SetDkimAuthority.Response
        public var setDkimSelector:
            @Sendable (
                _ domainName: String, _ request: Mailgun.Domains.DomainKeys.SetDkimSelector.Request
            ) async throws(Failure) -> Mailgun.Domains.DomainKeys.SetDkimSelector.Response

        public init(
            list:
                @escaping @Sendable (_ request: Mailgun.Domains.DomainKeys.List.Request?)
                async throws(Failure) -> Mailgun.Domains.DomainKeys.List.Response,
            create:
                @escaping @Sendable (_ request: Mailgun.Domains.DomainKeys.Create.Request)
                async throws(Failure) -> Mailgun.Domains.DomainKeys.Create.Response,
            delete:
                @escaping @Sendable (_ request: Mailgun.Domains.DomainKeys.Delete.Request)
                async throws(Failure) -> Mailgun.Domains.DomainKeys.Delete.Response,
            activate:
                @escaping @Sendable (_ authorityName: String, _ selector: String)
                async throws(Failure) -> Mailgun.Domains.DomainKeys.Activate.Response,
            listDomainKeys:
                @escaping @Sendable (_ authorityName: String) async throws(Failure) ->
                Mailgun.Domains.DomainKeys.DomainKeysList.Response,
            deactivate:
                @escaping @Sendable (_ authorityName: String, _ selector: String)
                async throws(Failure) -> Mailgun.Domains.DomainKeys.Deactivate.Response,
            setDkimAuthority:
                @escaping @Sendable (
                    _ domainName: String,
                    _ request: Mailgun.Domains.DomainKeys.SetDkimAuthority.Request
                ) async throws(Failure) -> Mailgun.Domains.DomainKeys.SetDkimAuthority.Response,
            setDkimSelector:
                @escaping @Sendable (
                    _ domainName: String,
                    _ request: Mailgun.Domains.DomainKeys.SetDkimSelector.Request
                ) async throws(Failure) -> Mailgun.Domains.DomainKeys.SetDkimSelector.Response
        ) {
            self.list = list
            self.create = create
            self.delete = delete
            self.activate = activate
            self.listDomainKeys = listDomainKeys
            self.deactivate = deactivate
            self.setDkimAuthority = setDkimAuthority
            self.setDkimSelector = setDkimSelector
        }
    }
}
