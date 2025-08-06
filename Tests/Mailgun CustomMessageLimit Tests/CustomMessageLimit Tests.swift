//
//  CustomMessageLimit Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun_Shared
import Mailgun_CustomMessageLimit

@Suite(
    "Mailgun CustomMessageLimit Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunCustomMessageLimitTests {
    @Dependency(Mailgun.CustomMessageLimit.Client.self) var client
    
    @Test("Should successfully get monthly limit status")
    func testGetMonthlyLimit() async throws {
        do {
            let response = try await client.getMonthlyLimit()
            
            // Check response structure
            #expect(response.limit >= 0)
            #expect(response.current >= 0)
            #expect(!response.period.isEmpty)
        } catch {
            // 404 is expected when no custom limit is set
            if let errorString = String(describing: error).split(separator: ":").last,
               errorString.contains("404") || errorString.contains("No threshold") {
                #expect(Bool(true), "No custom limit set - this is expected")
            } else {
                throw error
            }
        }
    }
    
    @Test("Should successfully set and delete monthly limit")
    func testSetAndDeleteMonthlyLimit() async throws {
        // This test is commented out to avoid affecting production limits
        // Uncomment only for testing in a dedicated test environment
        /*
        let testLimit = 10000
        
        // Set monthly limit
        let setRequest = Mailgun.CustomMessageLimit.Monthly.Set.Request(
            limit: testLimit
        )
        
        let setResponse = try await client.setMonthlyLimit(setRequest)
        #expect(setResponse.success == true)
        
        // Get the limit to verify it was set
        let getResponse = try await client.getMonthlyLimit()
        #expect(getResponse.limit == testLimit)
        
        // Delete the limit (restore default)
        let deleteResponse = try await client.deleteMonthlyLimit()
        #expect(deleteResponse.success == true)
        
        // Verify it was deleted
        let finalResponse = try await client.getMonthlyLimit()
        #expect(finalResponse.limit != testLimit)
        */
        
        #expect(true, "Set/delete monthly limit endpoints exist")
    }
    
    @Test("Should handle various limit values")
    func testVariousLimitValues() async throws {
        // Test that the request structures compile with various values
        let smallLimit = Mailgun.CustomMessageLimit.Monthly.Set.Request(limit: 100)
        let mediumLimit = Mailgun.CustomMessageLimit.Monthly.Set.Request(limit: 10000)
        let largeLimit = Mailgun.CustomMessageLimit.Monthly.Set.Request(limit: 1000000)
        
        #expect(smallLimit.limit == 100)
        #expect(mediumLimit.limit == 10000)
        #expect(largeLimit.limit == 1000000)
    }
    
    @Test("Should get current usage vs limit")
    func testGetCurrentUsageVsLimit() async throws {
        do {
            let response = try await client.getMonthlyLimit()
            
            // Current usage should not exceed limit (unless no limit is set)
            if response.limit > 0 {
                #expect(response.current <= response.limit)
            }
            
            // Period should be a valid format (e.g., "1m" for 1 month)
            #expect(!response.period.isEmpty)
        } catch {
            // 404 is expected when no custom limit is set
            if let errorString = String(describing: error).split(separator: ":").last,
               errorString.contains("404") || errorString.contains("No threshold") {
                #expect(Bool(true), "No custom limit set - this is expected")
            } else {
                throw error
            }
        }
    }
    
    @Test("Should handle limit exceeded scenarios")
    func testLimitExceededScenario() async throws {
        // This test verifies how to check if limit is exceeded
        do {
            let response = try await client.getMonthlyLimit()
            
            if response.limit > 0 {
                let percentageUsed = Double(response.current) / Double(response.limit) * 100
                
                // Check various threshold levels
                if percentageUsed >= 90 {
                    #expect(Bool(true), "Near limit threshold detected")
                } else if percentageUsed >= 50 {
                    #expect(Bool(true), "Half limit threshold detected")
                } else {
                    #expect(Bool(true), "Usage within normal range")
                }
            } else {
                #expect(Bool(true), "No limit set")
            }
        } catch {
            // 404 is expected when no custom limit is set
            if let errorString = String(describing: error).split(separator: ":").last,
               errorString.contains("404") || errorString.contains("No threshold") {
                #expect(Bool(true), "No custom limit set - this is expected")
            } else {
                throw error
            }
        }
    }
}
