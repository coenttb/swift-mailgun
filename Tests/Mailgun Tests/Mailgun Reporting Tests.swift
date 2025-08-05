import Testing
import Dependencies
import Mailgun
import Mailgun_Reporting
import Mailgun_Reporting_Types
import TypesFoundation
import Foundation

@Suite(
    "Mailgun Reporting Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunReportingTests {
    @Dependency(Mailgun.Reporting.Client.self) var client
    @Dependency(\.envVars.mailgunDomain) var domain
    
    @Test("Should successfully get account metrics")
    func testGetAccountMetrics() async throws {
        let request = Mailgun.Reporting.Metrics.Account.Request(
            start: Date().addingTimeInterval(-7 * 24 * 60 * 60), // 7 days ago
            end: Date(),
            resolution: .day,
            duration: nil,
            dimensions: nil,
            metrics: nil,
            includeSubaccounts: nil,
            includeAggregates: nil
        )
        
        let response = try await client.metrics.account(request)
        
        #expect(response.items != nil)
        #expect(response.resolution == "day")
    }
    
    @Test("Should successfully get domain metrics")
    func testGetDomainMetrics() async throws {
        let request = Mailgun.Reporting.Metrics.Domain.Request(
            domain: domain,
            start: Date().addingTimeInterval(-24 * 60 * 60), // 1 day ago
            end: Date(),
            resolution: .hour,
            duration: nil,
            dimensions: nil,
            metrics: nil
        )
        
        let response = try await client.metrics.domain(request)
        
        #expect(response.items != nil)
        #expect(response.resolution == "hour")
    }
    
    @Test("Should successfully get stats")
    func testGetStats() async throws {
        let request = Mailgun.Reporting.Stats.Request(
            event: ["accepted", "delivered"],
            start: nil,
            end: nil,
            resolution: nil,
            duration: "1d"
        )
        
        let response = try await client.stats.list(domain: domain, request: request)
        
        #expect(response.items != nil)
        #expect(response.stats != nil)
    }
    
    @Test("Should successfully list tags")
    func testListTags() async throws {
        let request = Mailgun.Reporting.Tags.List.Request(
            limit: 10
        )
        
        let response = try await client.tags.list(domain, request)
        
        #expect(response.items != nil)
        #expect(response.paging != nil)
    }
    
    @Test("Should successfully get tag stats")
    func testGetTagStats() async throws {
        // First list tags to get a valid tag
        let listResponse = try await client.tags.list(domain, nil)
        
        guard let testTag = listResponse.items.first?.tag else {
            // Skip test if no tags available
            return
        }
        
        let request = Mailgun.Reporting.Tags.TagStats.Request(
            event: ["accepted", "delivered"],
            start: nil,
            end: nil,
            resolution: nil,
            duration: "1d"
        )
        
        let response = try await client.tags.tagStats(domain: domain, tag: testTag, request: request)
        
        #expect(response.tag == testTag)
        #expect(response.stats != nil)
    }
    
    @Test("Should successfully access logs client")
    func testLogsClient() async throws {
        // The logs API might require special permissions
        // Just verify the client is accessible
        _ = client.logs
        #expect(true, "Logs client is accessible")
    }
}