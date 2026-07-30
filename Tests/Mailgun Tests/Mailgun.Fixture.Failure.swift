@testable import Mailgun

extension Mailgun {
    enum Fixture {}
}

extension Mailgun.Fixture {
    enum Failure: Swift.Error, Equatable, Sendable {
        case expected
    }
}
