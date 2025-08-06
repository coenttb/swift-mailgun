////
////  File.swift
////  coenttb-mailgun
////
////  Created by Coen ten Thije Boonkkamp on 27/12/2024.
////
//
// import Testing
// import Dependencies
// import DependenciesTestSupport
// import Mailgun_Suppressions
//
// @Suite(
//    "Allowlist Client Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
// )
// struct SuppressionsAllowlistClientTests {
//    @Test("Should successfully create Allowlist record for domain")
//    func testCreateDomainAllowlistRecord() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let request = Mailgun.Suppressions.Allowlist.Create.Request.domain(try .init("example.com"))
//
//        let response = try await client.Allowlist.create(request)
//
//        #expect(response.message == "Address/Domain has been added to the allowlists table")
//        #expect(response.type == "domain")
//        #expect(response.value == "example.com")
//    }
//
//    @Test("Should successfully create Allowlist record for address")
//    func testCreateAddressAllowlistRecord() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let request = Mailgun.Suppressions.Allowlist.Create.Request.address(try .init("test@example.com"))
//
//        let response = try await client.Allowlist.create(request)
//
//        #expect(response.message == "Address/Domain has been added to the allowlists table")
//        #expect(response.type == "address")
//        #expect(response.value == "test@example.com")
//    }
//
//    @Test("Should successfully get Allowlist record")
//    func testGetAllowlistRecord() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let Allowlist = try await client.Allowlist.get("example.com")
//
//        #expect(Allowlist.type == "domain")
//        #expect(Allowlist.value == "example.com")
//        #expect(!Allowlist.createdAt.isEmpty)
//    }
//
//    @Test(
//        "Should successfully import Allowlist"
//    )
//    func testImportAllowlist() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let csvContent = """
//        address,domain
//        test@example.com,example.com
//        another@example.com,anotherdomain.com
//        """
//        let testData = Data(csvContent.utf8)
//
//        let response = try await client.Allowlist.importList(testData)
//
//        #expect(response.message == "file uploaded successfully for processing. standby...")
//    }
//
//    @Test("Should successfully list Allowlist records")
//    func testListAllowlistRecords() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let request = Mailgun.Suppressions.Allowlist.List.Request(
//            address: try .init("test@example.com"),
//            term: nil,
//            limit: 25,
//            page: nil
//        )
//
//        let response = try await client.Allowlist.list(request)
//
//        #expect(!response.items.isEmpty)
//        #expect(!response.paging.first.isEmpty)
//        #expect(!response.paging.last.isEmpty)
//    }
//
//    @Test("Should successfully delete Allowlist record")
//    func testDeleteAllowlistRecord() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let response = try await client.Allowlist.delete("example.com")
//
//        #expect(response.message == "Allowlist address/domain has been removed")
//        #expect(response.value == "example.com")
//    }
//
//    @Test("Should successfully delete all Allowlist records")
//    func testDeleteAllAllowlistRecords() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let response = try await client.Allowlist.deleteAll()
//
//        #expect(response.message == "Allowlist addresses/domains for this domain have been removed")
//    }
// }
