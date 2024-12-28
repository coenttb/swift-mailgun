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
    .dependency(\.envVars, .liveTest),
    .dependency(\.calendar, .current)
)
struct MailgunWhitelistTests {
    @Test("Should successfully get whitelist record")
    func testGetWhitelistRecord() async throws {
        @Dependency(\.suppressions!.whitelist) var client
        
        let whitelist = try await client.get("example.com")
        
        #expect(whitelist.type == "domain")
        #expect(whitelist.value == "example.com")
        #expect(!whitelist.reason.isEmpty)
        #expect(!whitelist.createdAt.isEmpty)
    }
    
    @Test("Should successfully delete whitelist record")
    func testDeleteWhitelistRecord() async throws {
        @Dependency(\.suppressions!.whitelist) var client
        
        let response = try await client.delete("example.com")
        
        #expect(response.message == "Whitelist record has been removed")
        #expect(response.value == "example.com")
    }
    
    @Test("Should successfully list whitelist records")
    func testListWhitelistRecords() async throws {
        @Dependency(\.suppressions!.whitelist) var client
        
        let request = Whitelist.List.Request(
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
    
    @Test("Should successfully create whitelist record for domain")
    func testCreateDomainWhitelistRecord() async throws {
        @Dependency(\.suppressions!.whitelist) var client
        
        let request = Whitelist.Create.Request(
            address: nil,
            domain: try .init("example.com")
        )
        
        let response = try await client.create(request)
        
        #expect(response.message == "Address/Domain has been added to the whitelists table")
        #expect(response.type == "domain")
        #expect(response.value == "example.com")
    }
    
    @Test("Should successfully create whitelist record for address")
    func testCreateAddressWhitelistRecord() async throws {
        @Dependency(\.suppressions!.whitelist) var client
        
        let request = Whitelist.Create.Request(
            address: try .init("test@example.com")
        )
        
        let response = try await client.create(request)
        
        #expect(response.message == "Address/Domain has been added to the whitelists table")
        #expect(response.type == "address")
        #expect(response.value == "test@example.com")
    }
    
    @Test("Should successfully delete all whitelist records")
    func testDeleteAllWhitelistRecords() async throws {
        @Dependency(\.suppressions!.whitelist) var client
        
        let response = try await client.deleteAll()
        
        #expect(response.message == "All whitelist records have been removed")
    }
    
    @Test("Should successfully import whitelist")
    func testImportWhitelist() async throws {
        @Dependency(\.suppressions!.whitelist) var client
        let testData = Data("test@example.com".utf8)
        
        let response = try await client.importList(testData)
        
        #expect(response.message == "file uploaded successfully")
    }
}
