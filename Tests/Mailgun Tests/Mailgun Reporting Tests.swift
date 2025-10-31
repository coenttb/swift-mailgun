import Dependencies
import DependenciesTestSupport
import EmailAddress
import Foundation
import Mailgun
import Mailgun_AccountManagement
import Mailgun_Messages_Types
import Mailgun_Reporting_Types
import Testing

@Suite(
  "Mailgun Reporting Tests",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct MailgunReportingTests {
  @Dependency(\.mailgun) var mailgun

}
