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
import TestShared
import Shared
import Authenticated
import Suppressions

@Suite(
    "Complaints Client Tests",
    .dependency(\.envVars, .liveTest),
    .dependency(\.calendar, .current)
)
struct MailgunComplaintsTests {
    @Test("Should successfully import complaints list")
    func testImportComplaintsList() async throws {
        @Dependency(\.suppressions.complaints) var client
        let testData = Data("test@example.com".utf8)
        
        let response = try await client.importList(testData)
        
        #expect(response.message == "file uploaded successfully")
    }
    
    @Test("Should successfully get complaint record")
    func testGetComplaintRecord() async throws {
        @Dependency(\.suppressions.complaints) var client
        
        let complaint = try await client.get(try .init("test@example.com"))
        
        #expect(complaint.address.address == "test@example.com")
        #expect(!complaint.createdAt.isEmpty)
    }
    
    @Test("Should successfully delete complaint record")
    func testDeleteComplaintRecord() async throws {
        @Dependency(\.suppressions.complaints) var client
        
        let response = try await client.delete(try .init("test@example.com"))
        
        #expect(response.message == "Complaint has been removed")
        #expect(response.address.address == "test@example.com")
    }
    
    @Test("Should successfully list complaint records")
    func testListComplaintRecords() async throws {
        @Dependency(\.suppressions.complaints) var client
        
        let request = Complaints.List.Request(
            address: try .init("test@example.com"),
            term: nil,
            limit: 25,
            page: nil
        )
        
        let response = try await client.list(request)
        
        #expect(!response.items.isEmpty)
        #expect(!response.paging.first.isEmpty)
        #expect(!response.paging.last.isEmpty)
    }
    
    @Test("Should successfully create complaint record")
    func testCreateComplaintRecord() async throws {
        @Dependency(\.suppressions.complaints) var client
        
        let request = Complaints.Create.Request(
            address: try .init("test@example.com")
        )
        
        let response = try await client.create(request)
        
        #expect(response.message == "Complaint event has been created")
    }
    
    @Test("Should successfully delete all complaint records")
    func testDeleteAllComplaintRecords() async throws {
        @Dependency(\.suppressions.complaints) var client
        
        let response = try await client.deleteAll()
        
        #expect(response.message == "Complaint addresses for this domain have been removed")
    }
}
