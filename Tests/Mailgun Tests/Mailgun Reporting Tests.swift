import Dependencies
import DependenciesTestSupport
import Mailgun
import Testing
//
// @Suite(
//    "Mailgun Reporting Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
// )
// struct MailgunReportingTests {
//    @Dependency(Mailgun.Reporting.self) var reporting
//    @Dependency(\.envVars.mailgun.domain) var domain
//    
//    @Test("Should successfully access reporting subclients")
//    func testReportingSubclients() async throws {
//        // Just verify all subclients are accessible
//        _ = client.metrics
//        _ = client.stats
//        _ = client.events
//        _ = client.tags
//        _ = client.logs
//        
//        #expect(true, "All reporting subclients are accessible")
//    }
// }
