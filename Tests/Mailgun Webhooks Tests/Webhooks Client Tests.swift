import Dependencies
import Dependencies_Test_Support
import Foundation
import Mailgun_Webhooks
import Testing

@Suite(
    "Mailgun Webhooks Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct WebhooksClientTests {
}
