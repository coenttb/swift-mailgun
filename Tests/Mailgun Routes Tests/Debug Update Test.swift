import Dependencies
import Dependencies_Test_Support
import Foundation
import Mailgun_Routes
import Testing

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

@Suite(
    "Debug Update Test",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct DebugUpdateTest {

}
