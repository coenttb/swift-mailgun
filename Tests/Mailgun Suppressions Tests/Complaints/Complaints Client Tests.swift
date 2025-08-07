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
//    "Complaints Client Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
// )
// struct ComplaintsClientTests {
//    @Test("Should successfully create complaint record")
//    func testCreateComplaintRecord() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//
//        let request = Mailgun.Suppressions.Complaints.Create.Request(
//            address: try .init("test@example.com")
//        )
//
//        let response = try await suppressions.client.complaints.create(request)
//
//        #expect(response.message == "Address has been added to the complaints table")
//    }
//
//    @Test("Should successfully import complaints list")
//    func testImportComplaintsList() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//        let csvContent = """
//        address, created_at
//        test@example.com,
//        another@example.com,
//        """
//
//        let response = try await suppressions.client.complaints.importList(Data(csvContent.utf8))
//
//        #expect(response.message == "file uploaded successfully for processing. standby...")
//    }
//
//    @Test("Should successfully get complaint record")
//    func testGetComplaintRecord() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//
//        let complaint = try await client.complaints.get(try .init("test@example.com"))
//
//        #expect(complaint.address.address == "test@example.com")
//        #expect(!complaint.createdAt.isEmpty)
//    }
//
//    @Test("Should successfully list complaint records")
//    func testListComplaintRecords() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//
//        let request = Mailgun.Suppressions.Complaints.List.Request(
//            address: try .init("test@example.com"),
//            term: nil,
//            limit: 25,
//            page: nil
//        )
//
//        let response = try await suppressions.client.complaints.list(request)
//
//        #expect(!response.items.isEmpty)
//        #expect(!response.paging.first.isEmpty)
//        #expect(!response.paging.last.isEmpty)
//    }
//
//    @Test("Should successfully delete complaint record")
//    func testDeleteComplaintRecord() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//
//        let response = try await suppressions.client.complaints.delete(try .init("test@example.com"))
//
//        #expect(response.message == "Spam complaint has been removed")
//        #expect(response.address.address == "test@example.com")
//    }
//
//    @Test("Should successfully delete all complaint records")
//    func testDeleteAllComplaintRecords() async throws {
//        @Dependency(Mailgun.Suppressions.self) var suppressions
//
//        let response = try await suppressions.client.complaints.deleteAll()
//
//        #expect(response.message == "Complaint addresses for this domain have been removed")
//    }
// }
