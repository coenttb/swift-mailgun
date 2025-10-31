import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun
import Mailgun_AccountManagement
import Mailgun_Messages
import Testing

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

@Suite(
  "Messages Integration Tests",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct MessagesIntegrationTests {

}
