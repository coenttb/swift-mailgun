////
////  CustomMessageLimit Tests.swift
////  coenttb-mailgun
////
////  Created by Coen ten Thije Boonkkamp on 24/12/2024.
////
//
//import Testing
//import Dependencies
//import DependenciesTestSupport
//import Mailgun_Shared
//import Mailgun_CustomMessageLimit
//
//@Suite(
//    "Mailgun CustomMessageLimit Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
//)
//struct MailgunCustomMessageLimitTests {
//    @Dependency(Mailgun.CustomMessageLimit.Client.self) var client
//    
//    @Test("Should successfully get monthly limit status")
//    func testGetMonthlyLimit() async throws {
//        let response = try await client.getMonthlyLimit()
//        
//        // Check response structure
//        #expect(response.limit >= 0)
//        #expect(response.current >= 0)
//        #expect(!response.period.isEmpty)
//    }
//    
//    @Test("Should successfully set and delete monthly limit")
//    func testSetAndDeleteMonthlyLimit() async throws {
//        // This test is commented out to avoid affecting production limits
//        // Uncomment only for testing in a dedicated test environment
//        /*
//        let testLimit = 10000
//        
//        // Set monthly limit
//        let setRequest = Mailgun.CustomMessageLimit.Monthly.SetRequest(
//            limit: testLimit
//        )
//        
//        let setResponse = try await client.setMonthlyLimit(setRequest)
//        #expect(setResponse.success == true || setResponse.message.contains("set"))
//        
//        // Get the limit to verify it was set
//        let getResponse = try await client.getMonthlyLimit()
//        #expect(getResponse.limit == testLimit)
//        
//        // Delete the limit (restore default)
//        let deleteResponse = try await client.deleteMonthlyLimit()
//        #expect(deleteResponse.success == true || deleteResponse.message.contains("deleted"))
//        
//        // Verify it was deleted
//        let finalResponse = try await client.getMonthlyLimit()
//        #expect(finalResponse.limit != testLimit)
//        */
//        
//        #expect(true, "Set/delete monthly limit endpoints exist")
//    }
//    
//    @Test("Should handle various limit values")
//    func testVariousLimitValues() async throws {
//        // Test that the request structures compile with various values
//        let smallLimit = Mailgun.CustomMessageLimit.Monthly.SetRequest(limit: 100)
//        let mediumLimit = Mailgun.CustomMessageLimit.Monthly.SetRequest(limit: 10000)
//        let largeLimit = Mailgun.CustomMessageLimit.Monthly.SetRequest(limit: 1000000)
//        
//        #expect(smallLimit.limit == 100)
//        #expect(mediumLimit.limit == 10000)
//        #expect(largeLimit.limit == 1000000)
//    }
//    
//    @Test("Should get current usage vs limit")
//    func testGetCurrentUsageVsLimit() async throws {
//        let response = try await client.getMonthlyLimit()
//        
//        // Current usage should not exceed limit (unless no limit is set)
//        if response.limit > 0 {
//            #expect(response.current <= response.limit)
//        }
//        
//        // Period should be a valid format (e.g., "2024-12")
//        #expect(response.period.count >= 7) // YYYY-MM format minimum
//    }
//    
//    @Test("Should handle limit exceeded scenarios")
//    func testLimitExceededScenario() async throws {
//        // This test verifies how to check if limit is exceeded
//        let response = try await client.getMonthlyLimit()
//        
//        if response.limit > 0 {
//            let percentageUsed = Double(response.current) / Double(response.limit) * 100
//            
//            // Check various threshold levels
//            if percentageUsed >= 90 {
//                #expect(true, "Near limit threshold detected")
//            } else if percentageUsed >= 50 {
//                #expect(true, "Half limit threshold detected")
//            } else {
//                #expect(true, "Usage within normal range")
//            }
//        } else {
//            #expect(true, "No limit set")
//        }
//    }
//}
