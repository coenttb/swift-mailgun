import Domain_Standard
import Mailgun_Standard

extension Mailgun.Domains.DKIM_Security {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var updateRotation:
            @Sendable (
                _ domain: Domain, _ request: Mailgun.Domains.DKIM_Security.Rotation.Update.Request
            ) async throws(Failure) -> Mailgun.Domains.DKIM_Security.Rotation.Update.Response
        public var rotateManually:
            @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Domains.DKIM_Security.Rotation.Manual.Response

        public init(
            updateRotation:
                @escaping @Sendable (
                    _ domain: Domain,
                    _ request: Mailgun.Domains.DKIM_Security.Rotation.Update.Request
                ) async throws(Failure) -> Mailgun.Domains.DKIM_Security.Rotation.Update.Response,
            rotateManually:
                @escaping @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Domains.DKIM_Security.Rotation.Manual.Response
        ) {
            self.updateRotation = updateRotation
            self.rotateManually = rotateManually
        }
    }
}
