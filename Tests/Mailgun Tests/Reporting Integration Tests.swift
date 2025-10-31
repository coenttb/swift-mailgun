import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun
import Mailgun_AccountManagement
import Mailgun_Messages_Types
import Mailgun_Reporting_Types
import Testing

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

@Suite(
  "Reporting Integration Tests",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct ReportingIntegrationTests {

}
