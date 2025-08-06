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
//    "Unsubscribe Client Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
// )
// struct UnsubscribeClientTests {
//    @Test("Should successfully create unsubscribe record")
//    func testCreateUnsubscribeRecord() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let request = Mailgun.Suppressions.Unsubscribe.Create.Request(
//            address: try .init("test@example.com"),
//            tags: ["newsletter"]
//        )
//
//        let response = try await client.unsubscribe.create(request)
//
//        #expect(response.message == "Address has been added to the unsubscribes table")
//    }
//
//    @Test("Should successfully import unsubscribe list")
//    func testImportUnsubscribeList() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let csvContent = """
//        address,tags,created_at
//        test@example.com,,
//        another@example.com,,
//        """
//
//        let response = try await client.unsubscribe.importList(request: Data(csvContent.utf8))
//
//        #expect(response.message == "file uploaded successfully for processing. standby...")
//    }
//
//    @Test("Should successfully get unsubscribe record")
//    func testGetUnsubscribeRecord() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let unsubscribe = try await client.unsubscribe.get(.init("test@example.com"))
//
//        #expect(unsubscribe.address.address == "test@example.com")
//        #expect(!unsubscribe.tags.isEmpty)
//        #expect(!unsubscribe.createdAt.isEmpty)
//    }
//
//    @Test("Should successfully list unsubscribe records")
//    func testListUnsubscribeRecords() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let request = Mailgun.Suppressions.Unsubscribe.List.Request(
//            address: try .init("test@example.com"),
//            term: nil,
//            limit: 25,
//            page: nil
//        )
//
//        let response = try await client.unsubscribe.list(request)
//
//        #expect(!response.items.isEmpty)
//        #expect(!response.paging.first.isEmpty)
//        #expect(!response.paging.last.isEmpty)
//    }
//
//    @Test("Should successfully delete unsubscribe record")
//    func testDeleteUnsubscribeRecord() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let response = try await client.unsubscribe.delete(try .init("test@example.com"))
//
//        #expect(response.message == "Unsubscribe event has been removed")
//        #expect(response.address.address == "test@example.com")
//    }
//
//    @Test("Should successfully delete all unsubscribe records")
//    func testDeleteAllUnsubscribeRecords() async throws {
//        @Dependency(Mailgun.Suppressions.Client.self) var client
//
//        let response = try await client.unsubscribe.deleteAll()
//
//        #expect(response.message == "Unsubscribe addresses for this domain have been removed")
//    }
// }
