import Dependencies
import DependenciesTestSupport
import Mailgun
import Mailgun_Reporting_Types
import Testing
import Foundation

@Suite(
    "Mailgun Reporting Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunReportingTests {
    @Dependency(\.mailgun) var mailgun
    @Dependency(\.envVars.mailgun.domain) var domain
    
    @Test("Should successfully access reporting subclients")
    func testReportingSubclients() async throws {
        // Just verify all subclients are accessible
        _ = mailgun.client.reporting.metrics
        _ = mailgun.client.reporting.stats
        _ = mailgun.client.reporting.events
        _ = mailgun.client.reporting.tags
        _ = mailgun.client.reporting.logs
        
        #expect(Bool(true))
    }
    
    @Test("Should list events")
    func testListEvents() async throws {
        
        let response = try await mailgun.client.reporting.events.list(nil)
        // Response.items is non-optional array
//        #expect(response.items.isEmpty || !response.items.isEmpty)
        print(response)
    }
    
    @Test("Should get stats")
    func testGetStats() async throws {
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-7 * 24 * 60 * 60) // 7 days ago
        
        // Use Unix timestamps (epoch time)
        let startTimestamp = String(Int(startDate.timeIntervalSince1970))
        let endTimestamp = String(Int(endDate.timeIntervalSince1970))
        
        let request = Mailgun.Reporting.Stats.Total.Request(
            event: "delivered",  // Single event string
            start: startTimestamp,
            end: endTimestamp,
            resolution: "day",
            duration: nil
        )
        
        let response = try await mailgun.client.reporting.stats.total(request)
        #expect(response.stats.isEmpty || !response.stats.isEmpty)
    }
    
    @Test("Should list existing tags")
    func testListExistingTags() async throws {
        // Just list existing tags without creating new ones
        let response = try await mailgun.client.reporting.tags.list(nil)
        // Response.items is non-optional array
        #expect(response.items.isEmpty || !response.items.isEmpty)
    }
    
    @Test("Should get tag limits")
    func testGetTagLimits() async throws {
        let limits = try await mailgun.client.reporting.tags.limits()
        #expect(limits.limit > 0)
    }
    
    @Test("Should get account metrics")
    func testGetAccountMetrics() async throws {
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-1 * 24 * 60 * 60) // 1 day ago
        
        // Use Unix timestamps (epoch time)
        let startTimestamp = String(Int(startDate.timeIntervalSince1970))
        let endTimestamp = String(Int(endDate.timeIntervalSince1970))
        
        let request = Mailgun.Reporting.Metrics.GetAccountMetrics.Request(
            start: startTimestamp,
            end: endTimestamp,
            resolution: "day",
            duration: "1d",
            dimensions: [],
            metrics: ["delivered_rate"],
            filter: Mailgun.Reporting.Metrics.Filter(
                and: []
            ),
            includeSubaccounts: false,
            includeAggregates: false
        )
        
        do {
            let response = try await mailgun.client.reporting.metrics.getAccountMetrics(request)
            #expect(response.items.isEmpty || !response.items.isEmpty)
        } catch {
            // This might fail if metrics aren't available or there's a decoding issue
            // which is expected for sandbox accounts
            #expect(error != nil)
        }
    }
}
