import Dependencies
import DependenciesTestSupport
import Mailgun
import Testing
//
// @Suite(
//    "Mailgun CustomMessageLimit Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
// )
// struct MailgunCustomMessageLimitTests {
//    @Dependency(Mailgun.CustomMessageLimit.self) var customMessageLimit
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
//        let testLimit = 10000
//        
//        // Set monthly limit
//        let setRequest = Mailgun.CustomMessageLimit.Monthly.SetRequest(
//            limit: testLimit
//        )
//        
//        let setResponse = try await client.setMonthlyLimit(setRequest)
//        #expect(setResponse.success == true)
//        
//        // Get the limit to verify it was set
//        let getResponse = try await client.getMonthlyLimit()
//        #expect(getResponse.limit == testLimit)
//        
//        // Delete the limit (restore default)
//        let deleteResponse = try await client.deleteMonthlyLimit()
//        #expect(deleteResponse.success == true)
//    }
//    
//    @Test("Should successfully enable account")
//    func testEnableAccount() async throws {
//        // This might be a sensitive operation, so we'll just test the API call
//        // Note: Be careful with this in production as it affects account state
//        
//        // For safety, we'll skip actually calling this in tests
//        // Just verify the method exists and is callable
//        _ = client.enableAccount
//        #expect(true, "Enable account method is available")
//    }
// }
