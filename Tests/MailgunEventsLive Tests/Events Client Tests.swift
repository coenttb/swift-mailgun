import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import Events
import IssueReporting
import MailgunSharedLive

@Suite(
    "Events Client Tests",
    .dependency(\.calendar, .current),
    .dependency(\.envVars, .liveTest),
    .dependency(AuthenticatedClient.testValue)
)
struct EventsClientTests {
    @Test("Should successfully list events with default parameters")
    func testListEvents() async throws {
        @Dependency(AuthenticatedClient.self) var client

        let response = try await client.list(nil)
        
        #expect(!response.items.isEmpty)
        #expect(response.items.allSatisfy { !$0.id!.isEmpty })
        #expect(response.items.allSatisfy { $0.timestamp! > 0 })
    }
       
    @Test("Should successfully list events with date range filter")
    func testListEventsWithDateRange() async throws {
        @Dependency(AuthenticatedClient.self) var client
        @Dependency(\.calendar) var calendar

        let end = Date()
        let begin = calendar.date(byAdding: .day, value: -1, to: end)!
        
        let query = Events.List.Query(
            begin: begin,
            end: end,
            ascending: .yes
        )
        
        let response = try await client.list(query)
        
        #expect(response.items.allSatisfy {
            $0.timestamp! >= begin.timeIntervalSince1970 &&
            $0.timestamp! <= end.timeIntervalSince1970
        })
    }
    
    @Test("Should successfully list events filtered by event type")
    func testListEventsWithEventType() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        let query = Events.List.Query(
            limit: 25,
            event: .delivered
        )
        
        let response = try await client.list(query)
        
        if !response.items.isEmpty {
            #expect(response.items.allSatisfy { $0.event == .delivered })
            #expect(response.items.count <= 25)
        }
    }
    
    @Test("Should successfully list events with recipient filter")
    func testListEventsWithRecipientFilter() async throws {
        @Dependency(AuthenticatedClient.self) var client
        @Dependency(\.envVars.mailgunTestRecipient) var mailgunTestRecipient
        
        let recipient = try #require(mailgunTestRecipient)
        
        let query = Events.List.Query(
            limit: 25,
            recipient: recipient
        )
        
        let response = try await client.list(query)
        
        if !response.items.isEmpty {
            #expect(response.items.count <= 25)
            #expect(response.items.allSatisfy { !$0.id!.isEmpty })
        }
    }
    
    @Test("Should successfully list events with tag filter")
    func testListEventsWithTagFilter() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        let query = Events.List.Query(
            limit: 25,
            tags: ["test-tag"]
        )
        
        let response = try await client.list(query)
        
        if !response.items.isEmpty {
            #expect(response.items.count <= 25)
            #expect(response.items.allSatisfy { $0.tags?.contains("test-tag") == true })
        }
    }
    
    @Test("Should successfully handle pagination")
    func testListEventsPagination() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        
        let query = Events.List.Query(limit: 5)
        
        let response = try await client.list(query)
        
        if !response.items.isEmpty {
            #expect(response.items.count <= 5)
            #expect(response.paging.next != nil)
        }
    }
}
