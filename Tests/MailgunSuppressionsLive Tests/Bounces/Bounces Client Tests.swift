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
@testable import Suppressions

@Suite(
    "Bounces Client Tests",
    .dependency(\.context, .live),
    .dependency(\.projectRoot, .mailgunLive),
    .dependency(\.envVars, .development),
    .serialized
)
struct BouncesClientTests {
    @Test("Should successfully create bounce record")
    func testCreateBounceRecord() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        
        let request = Bounces.Create.Request(
            address: try .init("test@example.com"),
            code: "550",
            error: "Test error"
        )
        
        let response = try await client.bounces.create(request)
        
        #expect(response.message == "Address has been added to the bounces table")
    }
    
    @Test("Should successfully import bounce list")
    func testImportBounceList() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        let csvContent = """
        address, code, error, created_at
        test@example.com,,,
        another@example.com,,,
        """
        
        let response = try await client.bounces.importList(Data(csvContent.utf8))
        
        #expect(response.message == "file uploaded successfully for processing. standby...")
    }
    
    @Test("Should successfully get bounce record")
    func testGetBounceRecord() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        
        let bounce = try await client.bounces.get(.init("test@example.com"))
        
        #expect(bounce.address.address == "test@example.com")
        #expect(!bounce.code.isEmpty)
        #expect(bounce.error == "Test error")
        #expect(!bounce.createdAt.isEmpty)
    }
    
    @Test("Should successfully list bounce records")
    func testListBounceRecords() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        
        let request = Bounces.List.Request(
            limit: 25,
            page: nil,
            term: nil
        )
        
        let response = try await client.bounces.list(request)
        
        #expect(!response.items.isEmpty)
        #expect(!response.paging.first.isEmpty)
        #expect(!response.paging.last.isEmpty)
    }
    
    @Test("Should successfully delete bounce record")
    func testDeleteBounceRecord() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        
        let response = try await client.bounces.delete(.init("test@example.com"))
        
        #expect(response.message == "Bounced address has been removed")
        #expect(response.address.address == "test@example.com")
    }
    
    @Test("Should successfully delete all bounce records")
    func testDeleteAllBounceRecords() async throws {
        @Dependency(Suppressions.Client.Authenticated.self) var client
        
        let response = try await client.bounces.deleteAll()
        
        #expect(response.message == "Bounced addresses for this domain have been removed")
    }
}
