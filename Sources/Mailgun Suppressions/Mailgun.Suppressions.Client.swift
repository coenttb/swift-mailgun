import EmailAddress_Standard
import Mailgun_Standard

extension Mailgun.Suppressions {
    public struct Client<Failure: Swift.Error>: Sendable {
        public let bounces: Mailgun.Suppressions.Bounces.Client<Failure>
        public let complaints: Mailgun.Suppressions.Complaints.Client<Failure>
        public let unsubscribe: Mailgun.Suppressions.Unsubscribe.Client<Failure>
        public let allowlist: Mailgun.Suppressions.Allowlist.Client<Failure>

        public init(
            bounces: Mailgun.Suppressions.Bounces.Client<Failure>,
            complaints: Mailgun.Suppressions.Complaints.Client<Failure>,
            unsubscribe: Mailgun.Suppressions.Unsubscribe.Client<Failure>,
            allowlist: Mailgun.Suppressions.Allowlist.Client<Failure>
        ) {
            self.bounces = bounces
            self.complaints = complaints
            self.unsubscribe = unsubscribe
            self.allowlist = allowlist
        }
    }
}
