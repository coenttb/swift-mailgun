import Dependencies
import DependenciesTestSupport
import EmailAddress
import Foundation
import Mailgun_Suppressions
import Testing

@Suite(
    "Mailgun Unsubscribe Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct UnsubscribeClientTests {
    }
