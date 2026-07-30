extension Mailgun.AccountManagement {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var updateAccount:
            @Sendable (_ request: Mailgun.AccountManagement.Update.Request) async throws(Failure) ->
                Mailgun.AccountManagement.Update.Response
        public var getHttpSigningKey:
            @Sendable () async throws(Failure) ->
                Mailgun.AccountManagement.HttpSigningKey.Get.Response
        public var regenerateHttpSigningKey:
            @Sendable () async throws(Failure) ->
                Mailgun.AccountManagement.HttpSigningKey.Regenerate.Response
        public var getSandboxAuthRecipients:
            @Sendable () async throws(Failure) ->
                Mailgun.AccountManagement.Sandbox.Auth.Recipients.List.Response
        public var addSandboxAuthRecipient:
            @Sendable (_ request: Mailgun.AccountManagement.Sandbox.Auth.Recipients.Add.Request)
                async throws(Failure) ->
                Mailgun.AccountManagement.Sandbox.Auth.Recipients.Add.Response
        public var deleteSandboxAuthRecipient:
            @Sendable (_ email: EmailAddress) async throws(Failure) ->
                Mailgun.AccountManagement.Sandbox.Auth.Recipients.Delete.Response
        public var resendActivationEmail:
            @Sendable () async throws(Failure) ->
                Mailgun.AccountManagement.ResendActivationEmail.Response
        public var getSAMLOrganization:
            @Sendable () async throws(Failure) ->
                Mailgun.AccountManagement.SAML.Organization.Get.Response
        public var addSAMLOrganization:
            @Sendable (_ request: Mailgun.AccountManagement.SAML.Organization.Add.Request)
                async throws(Failure) -> Mailgun.AccountManagement.SAML.Organization.Add.Response

        public init(
            updateAccount:
                @escaping @Sendable (_ request: Mailgun.AccountManagement.Update.Request)
                async throws(Failure) -> Mailgun.AccountManagement.Update.Response,
            getHttpSigningKey:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.AccountManagement.HttpSigningKey.Get.Response,
            regenerateHttpSigningKey:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.AccountManagement.HttpSigningKey.Regenerate.Response,
            getSandboxAuthRecipients:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.AccountManagement.Sandbox.Auth.Recipients.List.Response,
            addSandboxAuthRecipient:
                @escaping @Sendable (
                    _ request: Mailgun.AccountManagement.Sandbox.Auth.Recipients.Add.Request
                ) async throws(Failure) ->
                Mailgun.AccountManagement.Sandbox.Auth.Recipients.Add.Response,
            deleteSandboxAuthRecipient:
                @escaping @Sendable (_ email: EmailAddress) async throws(Failure) ->
                Mailgun.AccountManagement.Sandbox.Auth.Recipients.Delete.Response,
            resendActivationEmail:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.AccountManagement.ResendActivationEmail.Response,
            getSAMLOrganization:
                @escaping @Sendable () async throws(Failure) ->
                Mailgun.AccountManagement.SAML.Organization.Get.Response,
            addSAMLOrganization:
                @escaping @Sendable (
                    _ request: Mailgun.AccountManagement.SAML.Organization.Add.Request
                ) async throws(Failure) -> Mailgun.AccountManagement.SAML.Organization.Add.Response
        ) {
            self.updateAccount = updateAccount
            self.getHttpSigningKey = getHttpSigningKey
            self.regenerateHttpSigningKey = regenerateHttpSigningKey
            self.getSandboxAuthRecipients = getSandboxAuthRecipients
            self.addSandboxAuthRecipient = addSandboxAuthRecipient
            self.deleteSandboxAuthRecipient = deleteSandboxAuthRecipient
            self.resendActivationEmail = resendActivationEmail
            self.getSAMLOrganization = getSAMLOrganization
            self.addSAMLOrganization = addSAMLOrganization
        }
    }
}
