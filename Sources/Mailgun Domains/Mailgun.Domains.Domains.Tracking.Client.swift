import Domain_Standard
import Mailgun_Standard

extension Mailgun.Domains.Domains.Tracking {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var get:
            @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Domains.Domains.Tracking.Get.Response
        public var updateClick:
            @Sendable (
                _ domain: Domain, _ request: Mailgun.Domains.Domains.Tracking.UpdateClick.Request
            ) async throws(Failure) -> Mailgun.Domains.Domains.Tracking.UpdateClick.Response
        public var updateOpen:
            @Sendable (
                _ domain: Domain, _ request: Mailgun.Domains.Domains.Tracking.UpdateOpen.Request
            ) async throws(Failure) -> Mailgun.Domains.Domains.Tracking.UpdateOpen.Response
        public var updateUnsubscribe:
            @Sendable (
                _ domain: Domain,
                _ request: Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Request
            ) async throws(Failure) -> Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Response

        public init(
            get:
                @escaping @Sendable (_ domain: Domain) async throws(Failure) ->
                Mailgun.Domains.Domains.Tracking.Get.Response,
            updateClick:
                @escaping @Sendable (
                    _ domain: Domain,
                    _ request: Mailgun.Domains.Domains.Tracking.UpdateClick.Request
                ) async throws(Failure) -> Mailgun.Domains.Domains.Tracking.UpdateClick.Response,
            updateOpen:
                @escaping @Sendable (
                    _ domain: Domain, _ request: Mailgun.Domains.Domains.Tracking.UpdateOpen.Request
                ) async throws(Failure) -> Mailgun.Domains.Domains.Tracking.UpdateOpen.Response,
            updateUnsubscribe:
                @escaping @Sendable (
                    _ domain: Domain,
                    _ request: Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Request
                ) async throws(Failure) ->
                Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Response
        ) {
            self.get = get
            self.updateClick = updateClick
            self.updateOpen = updateOpen
            self.updateUnsubscribe = updateUnsubscribe
        }
    }
}
