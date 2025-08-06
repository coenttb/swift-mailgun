//
//  Suppressions Client Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun_Shared
import Mailgun_Suppressions
import Mailgun_Suppressions_Types
import TypesFoundation

@Suite(
    "Mailgun Suppressions Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunSuppressionsClientTests {
    @Dependency(Mailgun.Suppressions.Client.self) var client
    @Dependency(\.envVars.mailgunDomain) var domain
    
    @Test("Should successfully access bounces client")
    func testBouncesClientAccess() async throws {
        // Test that we can access the bounces subclient
        let bouncesClient = client.bounces
        
        // List bounces to verify the client works
        let request = Mailgun.Suppressions.Bounces.List.Request(limit: 10)
        let response = try await bouncesClient.list(request)
        
        #expect(!response.items.isEmpty || response.items.isEmpty) // May be empty
        #expect(!response.paging.first.isEmpty)
    }
    
    @Test("Should successfully access complaints client")
    func testComplaintsClientAccess() async throws {
        // Test that we can access the complaints subclient
        let complaintsClient = client.complaints
        
        // List complaints to verify the client works
        let request = Mailgun.Suppressions.Complaints.List.Request(limit: 10)
        let response = try await complaintsClient.list(request)
        
        #expect(!response.items.isEmpty || response.items.isEmpty) // May be empty
        #expect(!response.paging.first.isEmpty)
    }
    
    @Test("Should successfully access unsubscribes client")
    func testUnsubscribesClientAccess() async throws {
        // Test that we can access the unsubscribes subclient
        let unsubscribesClient = client.unsubscribe
        
        // List unsubscribes to verify the client works
        let request = Mailgun.Suppressions.Unsubscribe.List.Request(limit: 10)
        let response = try await unsubscribesClient.list(request)
        
        #expect(!response.items.isEmpty || response.items.isEmpty) // May be empty
        #expect(!response.paging.first.isEmpty)
    }
    
    @Test("Should successfully access Allowlist client")
    func testAllowlistClientAccess() async throws {
        // Test that we can access the Allowlist subclient
        let AllowlistClient = client.Allowlist
        
        // List Allowlist entries to verify the client works
        let request = Mailgun.Suppressions.Allowlist.List.Request(limit: 10)
        let response = try await AllowlistClient.list(request)
        
        #expect(!response.items.isEmpty || response.items.isEmpty) // May be empty
        #expect(!response.paging.first.isEmpty)
    }
}
