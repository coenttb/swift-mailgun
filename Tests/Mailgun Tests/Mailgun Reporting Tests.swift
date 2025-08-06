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
//    @Dependency(Mailgun.Reporting.Client.self) var client
//    @Dependency(\.envVars.mailgunDomain) var domain
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
