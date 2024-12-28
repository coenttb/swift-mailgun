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
import Suppressions
//
//@Suite(
//    .dependency(\.envVars, .liveTest),
//    .dependency(\.calendar, .current),
//    .dependency(\.suppressions, .liveTest)
//)
//struct SuppressionsClientTests {
//    @Test
//    func testBounces() async throws {
//        try await MailgunBouncesTests().testImportBounceList()
//        try await MailgunBouncesTests().testGetBounceRecord()
//        try await MailgunBouncesTests().testDeleteBounceRecord()
//        try await MailgunBouncesTests().testListBounceRecords()
//        try await MailgunBouncesTests().testCreateBounceRecord()
//        try await MailgunBouncesTests().testDeleteAllBounceRecords()
//    }
//    
//    @Test
//    func testComplaints() async throws {
//        try await MailgunComplaintsTests().testImportComplaintsList()
//        try await MailgunComplaintsTests().testGetComplaintRecord()
//        try await MailgunComplaintsTests().testDeleteComplaintRecord()
//        try await MailgunComplaintsTests().testListComplaintRecords()
//        try await MailgunComplaintsTests().testCreateComplaintRecord()
//        try await MailgunComplaintsTests().testDeleteAllComplaintRecords()
//    }
//    
//    @Test
//    func testUnsubscribes() async throws {
//        try await MailgunUnsubscribeTests().testImportUnsubscribeList()
//        try await MailgunUnsubscribeTests().testGetUnsubscribeRecord()
//        try await MailgunUnsubscribeTests().testDeleteUnsubscribeRecord()
//        try await MailgunUnsubscribeTests().testListUnsubscribeRecords()
//        try await MailgunUnsubscribeTests().testCreateUnsubscribeRecord()
//        try await MailgunUnsubscribeTests().testDeleteAllUnsubscribeRecords()
//    }
//
//    @Test
//    func testWhitelist() async throws {
//        try await MailgunWhitelistTests().testGetWhitelistRecord()
//        try await MailgunWhitelistTests().testDeleteWhitelistRecord()
//        try await MailgunWhitelistTests().testListWhitelistRecords()
//        try await MailgunWhitelistTests().testCreateDomainWhitelistRecord()
//        try await MailgunWhitelistTests().testCreateAddressWhitelistRecord()
//        try await MailgunWhitelistTests().testDeleteAllWhitelistRecords()
//        try await MailgunWhitelistTests().testImportWhitelist()
//    }
//}
//
//private struct TestError: Error {
//    let message: String
//    
//    init(_ message: String) {
//        self.message = message
//    }
//}
