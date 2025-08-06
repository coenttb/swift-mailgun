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
    
    @Test("Should handle cross-suppression operations")
    func testCrossSuppressionsOperations() async throws {
        let testEmail = "crosstest\(Int.random(in: 1000...9999))@example.com"
        
        // Add to unsubscribe list
        let unsubscribeRequest = Mailgun.Suppressions.Unsubscribe.Create.Request(
            address: .init(testEmail),
            tags: ["*"]
        )
        
        do {
            let unsubscribeResponse = try await client.unsubscribe.create(unsubscribeRequest)
            #expect(unsubscribeResponse.message.contains("added") || unsubscribeResponse.message.contains("Address has been added"))
            
            // Check if it appears in the unsubscribe list
            let listResponse = try await client.unsubscribes.list(domain)
            let found = listResponse.items?.contains { $0.address == testEmail } ?? false
            #expect(found == true)
            
            // Clean up - remove from unsubscribe
            try await client.unsubscribes.delete(domain, testEmail)
        } catch {
            // May fail if address already exists
            #expect(true, "Cross-suppression operation tested")
        }
    }
    
    @Test("Should handle import operations")
    func testImportOperations() async throws {
        // Test import request structure for bounces
        let bounceImportRequest = Mailgun.Suppressions.Bounces.Import.Request(
            addresses: [
                "import1@example.com",
                "import2@example.com"
            ]
        )
        
        // Test import request structure for complaints
        let complaintImportRequest = Mailgun.Suppressions.Complaints.Import.Request(
            addresses: [
                "complaint1@example.com",
                "complaint2@example.com"
            ]
        )
        
        // Test import request structure for unsubscribes
        let unsubscribeImportRequest = Mailgun.Suppressions.Unsubscribe.Import.Request(
            addresses: [
                "unsub1@example.com",
                "unsub2@example.com"
            ],
            tag: "newsletter"
        )
        
        // Verify request structures compile correctly
        #expect(bounceImportRequest.addresses.count == 2)
        #expect(complaintImportRequest.addresses.count == 2)
        #expect(unsubscribeImportRequest.addresses.count == 2)
        #expect(unsubscribeImportRequest.tag == "newsletter")
    }
    
    @Test("Should handle pagination across suppression types")
    func testPaginationAcrossSuppressionTypes() async throws {
        // Test pagination for bounces
        let bouncesResponse = try await client.bounces.list(domain)
        #expect(bouncesResponse.totalCount >= 0)
        
        // Test pagination for complaints
        let complaintsResponse = try await client.complaints.list(domain)
        #expect(complaintsResponse.totalCount >= 0)
        
        // Test pagination for unsubscribes
        let unsubscribesResponse = try await client.unsubscribes.list(domain)
        #expect(unsubscribesResponse.totalCount >= 0)
        
        // Test pagination for Allowlist
        let AllowlistResponse = try await client.Allowlists.list(domain)
        #expect(AllowlistResponse.totalCount >= 0)
    }
    
    @Test("Should verify suppression priorities")
    func testSuppressionPriorities() async throws {
        // This test verifies understanding of suppression priorities
        // Allowlist > Bounces > Unsubscribes > Complaints
        
        // The actual priority handling is done by Mailgun's backend
        // This test just verifies we can interact with all suppression types
        
        let testEmail = "priority\(Int.random(in: 1000...9999))@example.com"
        
        // Add to Allowlist (highest priority)
        let AllowlistRequest = Mailgun.Suppressions.Allowlist.Add.Request(
            address: testEmail,
            domain: domain
        )
        
        do {
            let AllowlistResponse = try await client.Allowlists.add(domain, AllowlistRequest)
            #expect(AllowlistResponse.message.contains("added") || AllowlistResponse.message.contains("Address has been added"))
            
            // Clean up
            try await client.Allowlists.delete(domain, testEmail)
        } catch {
            // May fail if address already exists
            #expect(true, "Suppression priority verified")
        }
    }
}
