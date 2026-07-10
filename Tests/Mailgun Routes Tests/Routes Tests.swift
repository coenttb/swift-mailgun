import Dependencies
import Dependencies_Test_Support
import Foundation
import Mailgun_Routes
import Testing

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

@Suite(
    "Routes Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct RoutesTests {

}
