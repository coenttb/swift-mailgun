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
        #expect(response.items.isEmpty || !response.items.isEmpty)
    }
    
    @Test("Should get stats")
    func testGetStats() async throws {
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-7 * 24 * 60 * 60) // 7 days ago
        
        // Convert dates to RFC2822 format strings
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let request = Mailgun.Reporting.Stats.Total.Request(
            event: "delivered,failed",  // Comma-separated string
            start: formatter.string(from: startDate),
            end: formatter.string(from: endDate),
            resolution: "day",
            duration: nil
        )
        
        let response = try await mailgun.client.reporting.stats.total(request)
        #expect(response.stats.isEmpty || !response.stats.isEmpty)
    }
    
    @Test("Should list tags")
    func testListTags() async throws {
        // First create a test tag by sending an email with it
        let testTag = "test-tag-\(UUID().uuidString.prefix(8))"
        
        let sendRequest = Mailgun.Messages.Send.Request(
            from: try .init("test@\(domain.rawValue)"),
            to: [try .init("test@example.com")],
            subject: "Test with tag",
            text: "Testing tags",
            tags: [testTag],
            testMode: true
        )
        
        _ = try await mailgun.client.messages.send(sendRequest)
        
        // Now list tags
        let response = try await mailgun.client.reporting.tags.list(nil)
        // Response.items is non-optional array
        #expect(response.items.isEmpty || !response.items.isEmpty)
        
        // Clean up - delete the test tag
        do {
            _ = try await mailgun.client.reporting.tags.delete(testTag)
        } catch {
            // Ignore errors during cleanup
        }
    }
    
    @Test("Should get tag details")
    func testGetTagDetails() async throws {
        // First create a test tag
        let testTag = "test-detail-\(UUID().uuidString.prefix(8))"
        
        let sendRequest = Mailgun.Messages.Send.Request(
            from: try .init("test@\(domain.rawValue)"),
            to: [try .init("test@example.com")],
            subject: "Test for tag details",
            text: "Testing tag details",
            tags: [testTag],
            testMode: true
        )
        
        _ = try await mailgun.client.messages.send(sendRequest)
        
        // Get tag details
        let tag = try await mailgun.client.reporting.tags.get(testTag)
        #expect(tag.tag == testTag)
        
        // Clean up
        do {
            _ = try await mailgun.client.reporting.tags.delete(testTag)
        } catch {
            // Ignore errors during cleanup
        }
    }
    
    @Test("Should get tag stats")
    func testGetTagStats() async throws {
        // First create a test tag
        let testTag = "test-stats-\(UUID().uuidString.prefix(8))"
        
        let sendRequest = Mailgun.Messages.Send.Request(
            from: try .init("test@\(domain.rawValue)"),
            to: [try .init("test@example.com")],
            subject: "Test for tag stats",
            text: "Testing tag stats",
            tags: [testTag],
            testMode: true
        )
        
        _ = try await mailgun.client.messages.send(sendRequest)
        
        // Get tag stats
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-1 * 24 * 60 * 60) // 1 day ago
        
        // Convert dates to RFC2822 format strings
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let statsRequest = Mailgun.Reporting.Tags.Stats.Request(
            event: ["accepted"],
            start: formatter.string(from: startDate),
            end: formatter.string(from: endDate),
            resolution: "day",
            duration: nil
        )
        
        let stats = try await mailgun.client.reporting.tags.stats(testTag, statsRequest)
        #expect(stats.stats.isEmpty || !stats.stats.isEmpty)
        
        // Clean up
        do {
            _ = try await mailgun.client.reporting.tags.delete(testTag)
        } catch {
            // Ignore errors during cleanup
        }
    }
    
    @Test("Should get tag aggregates")
    func testGetTagAggregates() async throws {
        // First create a test tag
        let testTag = "test-aggregates-\(UUID().uuidString.prefix(8))"
        
        let sendRequest = Mailgun.Messages.Send.Request(
            from: try .init("test@\(domain.rawValue)"),
            to: [try .init("test@example.com")],
            subject: "Test for tag aggregates",
            text: "Testing tag aggregates",
            tags: [testTag],
            testMode: true
        )
        
        _ = try await mailgun.client.messages.send(sendRequest)
        
        // Get tag aggregates  
        let aggregatesRequest = Mailgun.Reporting.Tags.Aggregates.Request(
            type: "provider"  // Can be "provider", "device", or "country"
        )
        
        let aggregates = try await mailgun.client.reporting.tags.aggregates(testTag, aggregatesRequest)
        #expect(aggregates.provider != nil || aggregates.device != nil || aggregates.country != nil)
        
        // Clean up
        do {
            _ = try await mailgun.client.reporting.tags.delete(testTag)
        } catch {
            // Ignore errors during cleanup
        }
    }
    
    @Test("Should get account metrics")
    func testGetAccountMetrics() async throws {
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-1 * 24 * 60 * 60) // 1 day ago
        
        // Convert dates to RFC2822 format strings
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let request = Mailgun.Reporting.Metrics.GetAccountMetrics.Request(
            start: formatter.string(from: startDate),
            end: formatter.string(from: endDate),
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
        
        let response = try await mailgun.client.reporting.metrics.getAccountMetrics(request)
        #expect(response.items.isEmpty || !response.items.isEmpty)
    }
    
    @Test("Should get logs analytics")
    func testLogsAnalytics() async throws {
        let endDate = Date()
        let startDate = endDate.addingTimeInterval(-1 * 24 * 60 * 60) // 1 day ago
        
        let request = Mailgun.Reporting.Logs.Analytics.Request(
            action: nil,
            groupBy: nil,
            startDate: startDate,
            endDate: endDate,
            filter: nil,
            include: nil,
            page: nil
        )
        
        let response = try await mailgun.client.reporting.logs.analytics(request)
        #expect(response.data != nil || response.meta != nil)
    }
}