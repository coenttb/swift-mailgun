//
//  Complaints Client Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Mailgun_Suppressions
import Testing

@Suite(
    "Mailgun Suppressions Complaints Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunSuppressionsComplaintsTests {
    @Dependency(Mailgun.Suppressions.Complaints.self) var complaints
    
    @Test("Should successfully list complaints")
    func testListComplaints() async throws {
        // First create a complaint to ensure there's something to list
        let testEmail = try EmailAddress("testcomplaint-list-\(Int.random(in: 10000...99999))@example.com")
        
        let createRequest = Mailgun.Suppressions.Complaints.Create.Request(
            address: testEmail,
            createdAt: nil
        )
        
        _ = try await complaints.client.create(createRequest)
        
        // Now list complaints
        let request = Mailgun.Suppressions.Complaints.List.Request(limit: 10)
        let response = try await complaints.client.list(request)
        
        // The response contains an array of complaints
        #expect(response.items.count >= 1)
        #expect(!response.paging.first.isEmpty)
        #expect(!response.paging.last.isEmpty)
        
        // Clean up
        _ = try? await complaints.client.delete(testEmail)
    }
    
    @Test("Should successfully create and delete complaint")
    func testCreateAndDeleteComplaint() async throws {
        let testEmail = try EmailAddress("testcomplaint\(Int.random(in: 1000...9999))@example.com")
        
        // Create complaint using form-data request
        let createRequest = Mailgun.Suppressions.Complaints.Create.Request(
            address: testEmail,
            createdAt: nil
        )
        
        let createResponse = try await complaints.client.create(createRequest)
        #expect(createResponse.message.contains("added") || createResponse.message.contains("Address already exists"))
        
        // Get the complaint to verify it was created
        do {
            let complaint = try await complaints.client.get(testEmail)
            #expect(complaint.address == testEmail)
            
            // Clean up - delete the complaint
            let deleteResponse = try await complaints.client.delete(testEmail)
            #expect(deleteResponse.message.contains("removed") || deleteResponse.message.contains("deleted"))
            #expect(deleteResponse.address == testEmail)
        } catch {
            // If get fails, try to delete anyway in case it exists
            _ = try? await complaints.client.delete(testEmail)
        }
    }
    
    @Test("Should handle complaint not found")
    func testComplaintNotFound() async throws {
        let nonExistentEmail = try EmailAddress("nonexistent@example.com")
        
        do {
            _ = try await complaints.client.get(nonExistentEmail)
            Issue.record("Expected an error for non-existent complaint")
        } catch {
            #expect(String(describing: error).contains("404") || String(describing: error).contains("not found"))
        }
    }
    
    @Test("Should successfully list complaints with pagination")
    func testListComplaintsWithPagination() async throws {
        // First page
        let firstPageRequest = Mailgun.Suppressions.Complaints.List.Request(
            limit: 5,
            page: nil
        )
        
        let firstPage = try await complaints.client.list(firstPageRequest)
        #expect(!firstPage.paging.first.isEmpty)
        
        if !firstPage.items.isEmpty {
            // Try to get next page using last item's address as cursor
            let lastAddress = firstPage.items.last?.address
            let secondPageRequest = Mailgun.Suppressions.Complaints.List.Request(
                address: lastAddress,
                limit: 5,
                page: "next"
            )
            
            let secondPage = try await complaints.client.list(secondPageRequest)
            #expect(!secondPage.paging.first.isEmpty)
        }
    }
    
    @Test("Should successfully create multiple complaints")
    func testCreateMultipleComplaints() async throws {
        let testEmails = try (1...3).map { i in
            try EmailAddress("testcomplaint\(Int.random(in: 10000...99999))-\(i)@example.com")
        }
        
        // Create complaints one by one
        for email in testEmails {
            let createRequest = Mailgun.Suppressions.Complaints.Create.Request(
                address: email,
                createdAt: nil
            )
            
            let createResponse = try await complaints.client.create(createRequest)
            #expect(createResponse.message.contains("added") || createResponse.message.contains("Address already exists"))
        }
        
        // Clean up - delete all test complaints
        for email in testEmails {
            _ = try? await complaints.client.delete(email)
        }
    }
    
    @Test("Should successfully filter complaints by term")
    func testListComplaintsWithTermFilter() async throws {
        let request = Mailgun.Suppressions.Complaints.List.Request(
            term: "test",
            limit: 10
        )
        
        let response = try await complaints.client.list(request)
        
        // If there are results, they should start with "test"
        if !response.items.isEmpty {
            for item in response.items {
                #expect(item.address.rawValue.lowercased().starts(with: "test"))
            }
        }
    }
}
