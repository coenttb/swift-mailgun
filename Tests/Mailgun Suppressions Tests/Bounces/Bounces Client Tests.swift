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
//    "Bounces Client Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
// )
// struct BouncesClientTests {
//    @Test("Should successfully create bounce record")
//    func testCreateBounceRecord() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//
//        // Use a unique email address to avoid conflicts with Allowlist
//        // Note: Using test-bounces.com domain to avoid conflicts with Allowlisted example.com
//        let timestamp = Date().timeIntervalSince1970
//        let uniqueEmail = "bounce-test-\(Int(timestamp))@test-bounces.com"
//        
//        let request = Mailgun.Suppressions.Bounces.Create.Request(
//            address: try .init(uniqueEmail),
//            code: "550",
//            error: "Test error"
//        )
//
//        let response = try await suppressions.client.bounces.create(request)
//
//        #expect(response.message == "Address has been added to the bounces table")
//        
//        // Clean up - delete the bounce record we just created
//        _ = try? await client.bounces.delete(.init(uniqueEmail))
//    }
//
//    @Test("Should successfully import bounce list")
//    func testImportBounceList() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//        let timestamp = Int(Date().timeIntervalSince1970)
//        let csvContent = """
//        address, code, error, created_at
//        bounce-import1-\(timestamp)@test-bounces.com,,,
//        bounce-import2-\(timestamp)@test-bounces.com,,,
//        """
//
//        let response = try await suppressions.client.bounces.importList(Data(csvContent.utf8))
//
//        #expect(response.message == "file uploaded successfully for processing. standby...")
//    }
//
//    @Test("Should successfully get bounce record")
//    func testGetBounceRecord() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//
//        // First create a bounce record to ensure it exists
//        let timestamp = Date().timeIntervalSince1970
//        let uniqueEmail = "bounce-get-test-\(Int(timestamp))@test-bounces.com"
//        
//        let createRequest = Mailgun.Suppressions.Bounces.Create.Request(
//            address: try .init(uniqueEmail),
//            code: "550",
//            error: "Test error for get"
//        )
//        
//        _ = try await client.bounces.create(createRequest)
//        
//        // Now get the bounce record
//        let bounce = try await client.bounces.get(.init(uniqueEmail))
//
//        #expect(bounce.address.address == uniqueEmail)
//        #expect(!bounce.code.isEmpty)
//        #expect(!bounce.createdAt.isEmpty)
//        
//        // Clean up
//        _ = try? await client.bounces.delete(.init(uniqueEmail))
//    }
//
//    @Test("Should successfully list bounce records")
//    func testListBounceRecords() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//
//        let request = Mailgun.Suppressions.Bounces.List.Request(
//            limit: 25,
//            page: nil,
//            term: nil
//        )
//
//        let response = try await suppressions.client.bounces.list(request)
//
//        #expect(!response.items.isEmpty)
//        #expect(!response.paging.first.isEmpty)
//        #expect(!response.paging.last.isEmpty)
//    }
//
//    @Test("Should successfully delete bounce record")
//    func testDeleteBounceRecord() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//
//        // First create a bounce record to delete
//        let timestamp = Date().timeIntervalSince1970
//        let uniqueEmail = "bounce-delete-test-\(Int(timestamp))@test-bounces.com"
//        
//        let createRequest = Mailgun.Suppressions.Bounces.Create.Request(
//            address: try .init(uniqueEmail),
//            code: "550",
//            error: "Test error for deletion"
//        )
//        
//        _ = try await client.bounces.create(createRequest)
//        
//        // Now delete it
//        let response = try await suppressions.client.bounces.delete(.init(uniqueEmail))
//
//        #expect(response.message == "Bounced address has been removed")
//        #expect(response.address.address == uniqueEmail)
//    }
//
//    @Test("Should successfully delete all bounce records")
//    func testDeleteAllBounceRecords() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//
//        let response = try await suppressions.client.bounces.deleteAll()
//
//        #expect(response.message == "Bounced addresses for this domain have been removed")
//    }
// }
