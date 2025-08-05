//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
import IssueReporting
import Mailgun_Shared
import Mailgun_Suppressions
import Testing

@Suite(
    "Whitelist Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct SuppressionsWhitelistClientTests {
    @Test("Should successfully create whitelist record for domain")
    func testCreateDomainWhitelistRecord() async throws {
        @Dependency(Mailgun.Suppressions.Client.self) var client

        let request = Mailgun.Suppressions.Whitelist.Create.Request.domain(try .init("example.com"))

        let response = try await client.whitelist.create(request)

        #expect(response.message == "Address/Domain has been added to the allowlists table")
        #expect(response.type == "domain")
        #expect(response.value == "example.com")
    }

    @Test("Should successfully create whitelist record for address")
    func testCreateAddressWhitelistRecord() async throws {
        @Dependency(Mailgun.Suppressions.Client.self) var client

        let request = Mailgun.Suppressions.Whitelist.Create.Request.address(try .init("test@example.com"))

        let response = try await client.whitelist.create(request)

        #expect(response.message == "Address/Domain has been added to the allowlists table")
        #expect(response.type == "address")
        #expect(response.value == "test@example.com")
    }

    @Test("Should successfully get whitelist record")
    func testGetWhitelistRecord() async throws {
        @Dependency(Mailgun.Suppressions.Client.self) var client

        let whitelist = try await client.whitelist.get("example.com")

        #expect(whitelist.type == "domain")
        #expect(whitelist.value == "example.com")
        #expect(!whitelist.createdAt.isEmpty)
    }

    @Test(
        "Should successfully import whitelist"
    )
    func testImportWhitelist() async throws {
        @Dependency(Mailgun.Suppressions.Client.self) var client

        let csvContent = """
        address,domain
        test@example.com,example.com
        another@example.com,anotherdomain.com
        """
        let testData = Data(csvContent.utf8)

        let response = try await client.whitelist.importList(testData)

        #expect(response.message == "file uploaded successfully for processing. standby...")
    }

    @Test("Should successfully list whitelist records")
    func testListWhitelistRecords() async throws {
        @Dependency(Mailgun.Suppressions.Client.self) var client

        let request = Mailgun.Suppressions.Whitelist.List.Request(
            address: try .init("test@example.com"),
            term: nil,
            limit: 25,
            page: nil
        )

        let response = try await client.whitelist.list(request)

        #expect(!response.items.isEmpty)
        #expect(!response.paging.first.isEmpty)
        #expect(!response.paging.last.isEmpty)
    }

    @Test("Should successfully delete whitelist record")
    func testDeleteWhitelistRecord() async throws {
        @Dependency(Mailgun.Suppressions.Client.self) var client

        let response = try await client.whitelist.delete("example.com")

        #expect(response.message == "Allowlist address/domain has been removed")
        #expect(response.value == "example.com")
    }

    @Test("Should successfully delete all whitelist records")
    func testDeleteAllWhitelistRecords() async throws {
        @Dependency(Mailgun.Suppressions.Client.self) var client

        let response = try await client.whitelist.deleteAll()

        #expect(response.message == "Allowlist addresses/domains for this domain have been removed")
    }
}
