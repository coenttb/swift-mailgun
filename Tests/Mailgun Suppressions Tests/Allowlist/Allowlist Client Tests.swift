//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

 import Dependencies
 import DependenciesTestSupport
 import Mailgun_Suppressions
 import Testing

 @Suite(
    "Allowlist Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
 )
 struct SuppressionsAllowlistClientTests {
    @Test("Should successfully create Allowlist record for domain")
    func testCreateDomainAllowlistRecord() async throws {
        @Dependency(Mailgun.Suppressions.self) var suppressions

        let request = Mailgun.Suppressions.Allowlist.Create.Request.domain(try .init("example.com"))

        let response = try await suppressions.client.Allowlist.create(request)

        #expect(response.message == "Address/Domain has been added to the allowlists table")
        #expect(response.type == "domain")
        #expect(response.value == "example.com")
    }

    @Test("Should successfully create Allowlist record for address")
    func testCreateAddressAllowlistRecord() async throws {
        @Dependency(Mailgun.Suppressions.self) var suppressions

        let request = Mailgun.Suppressions.Allowlist.Create.Request.address(try .init("test@example.com"))

        let response = try await suppressions.client.Allowlist.create(request)

        #expect(response.message == "Address/Domain has been added to the allowlists table")
        #expect(response.type == "address")
        #expect(response.value == "test@example.com")
    }

    @Test("Should successfully get Allowlist record")
    func testGetAllowlistRecord() async throws {
        @Dependency(Mailgun.Suppressions.self) var suppressions

        let Allowlist = try await suppressions.client.Allowlist.get("example.com")

        #expect(Allowlist.type == "domain")
        #expect(Allowlist.value == "example.com")
        #expect(!Allowlist.createdAt.isEmpty)
    }

    @Test(
        "Should successfully import Allowlist"
    )
    func testImportAllowlist() async throws {
        @Dependency(Mailgun.Suppressions.self) var suppressions

        let csvContent = """
        address,domain
        test@example.com,example.com
        another@example.com,anotherdomain.com
        """
        let testData = Data(csvContent.utf8)

        let response = try await suppressions.client.Allowlist.importList(testData)

        #expect(response.message == "file uploaded successfully for processing. standby...")
    }

    @Test("Should successfully list Allowlist records")
    func testListAllowlistRecords() async throws {
        @Dependency(Mailgun.Suppressions.self) var suppressions

        // First create an allowlist record to ensure there's something to list
        let testDomain = "list-test-\(Int.random(in: 10000...99999)).com"
        let createRequest = Mailgun.Suppressions.Allowlist.Create.Request.domain(try .init(testDomain))

        _ = try await suppressions.client.Allowlist.create(createRequest)

        // Now list allowlist records
        let request = Mailgun.Suppressions.Allowlist.List.Request(
            address: nil,
            term: nil,
            limit: 25,
            page: nil
        )

        let response = try await suppressions.client.Allowlist.list(request)

        #expect(!response.items.isEmpty)
        #expect(!response.paging.first.isEmpty)
        #expect(!response.paging.last.isEmpty)

        // Clean up
        _ = try? await suppressions.client.Allowlist.delete(testDomain)
    }

    @Test("Should successfully delete Allowlist record")
    func testDeleteAllowlistRecord() async throws {
        @Dependency(Mailgun.Suppressions.self) var suppressions

        // First create an allowlist record to delete
        let testDomain = "delete-test-\(Int.random(in: 10000...99999)).com"
        let createRequest = Mailgun.Suppressions.Allowlist.Create.Request.domain(try .init(testDomain))

        _ = try await suppressions.client.Allowlist.create(createRequest)

        // Now delete it
        let response = try await suppressions.client.Allowlist.delete(testDomain)

        #expect(response.message == "Allowlist address/domain has been removed")
        #expect(response.value == testDomain)
    }

    @Test("Should successfully delete all Allowlist records")
    func testDeleteAllAllowlistRecords() async throws {
        @Dependency(Mailgun.Suppressions.self) var suppressions

        let response = try await suppressions.client.Allowlist.deleteAll()

        #expect(response.message == "Allowlist addresses/domains for this domain have been removed")
    }
 }
