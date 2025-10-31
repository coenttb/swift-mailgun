import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Routes
import Testing

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

@Suite(
  "Test Minimal Update",
  .dependency(\.context, .live),
  .dependency(\.envVars, .development),
  .serialized
)
struct TestMinimalUpdate {

}
