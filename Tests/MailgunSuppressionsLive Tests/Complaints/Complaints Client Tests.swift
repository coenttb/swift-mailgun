//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import IssueReporting
import MailgunSharedLive
import Suppressions
import MailgunSuppressionsLive

@Suite(
    "Complaints Client Tests",
    .dependency(\.context, .live),
    .dependency(\.projectRoot, .mailgunLive),
    .dependency(\.envVars, .development),
    .serialized
)
struct ComplaintsClientTests {
    @Test("Should successfully create complaint record")
    func testCreateComplaintRecord() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        
        let request = Complaints.Create.Request(
            address: try .init("test@example.com")
        )
        
        let response = try await client.complaints.create(request)
        
        #expect(response.message == "Address has been added to the complaints table")
    }
    
    @Test("Should successfully import complaints list")
    func testImportComplaintsList() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        let csvContent = """
        address, created_at
        test@example.com,
        another@example.com,
        """
        
        let response = try await client.complaints.importList(Data(csvContent.utf8))
        
        #expect(response.message == "file uploaded successfully for processing. standby...")
    }
    
    @Test("Should successfully get complaint record")
    func testGetComplaintRecord() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        
        let complaint = try await client.complaints.get(try .init("test@example.com"))
        
        #expect(complaint.address.address == "test@example.com")
        #expect(!complaint.createdAt.isEmpty)
    }
    
    @Test("Should successfully list complaint records")
    func testListComplaintRecords() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        
        let request = Complaints.List.Request(
            address: try .init("test@example.com"),
            term: nil,
            limit: 25,
            page: nil
        )
        
        let response = try await client.complaints.list(request)
        
        #expect(!response.items.isEmpty)
        #expect(!response.paging.first.isEmpty)
        #expect(!response.paging.last.isEmpty)
    }
    
    @Test("Should successfully delete complaint record")
    func testDeleteComplaintRecord() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        
        let response = try await client.complaints.delete(try .init("test@example.com"))
        
        #expect(response.message == "Spam complaint has been removed")
        #expect(response.address.address == "test@example.com")
    }
    
    @Test("Should successfully delete all complaint records")
    func testDeleteAllComplaintRecords() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        
        let response = try await client.complaints.deleteAll()
        
        #expect(response.message == "Complaint addresses for this domain have been removed")
    }
}
