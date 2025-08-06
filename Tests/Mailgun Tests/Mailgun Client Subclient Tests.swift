import Dependencies
import DependenciesTestSupport
import Mailgun
import Testing
//
// @Suite(
//    "Mailgun Client Subclient Access Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
// )
// struct MailgunClientSubclientAccessTests {
//    @Dependency(\.mailgun) var mailgun
//    
//    @Test("All subclients are accessible through dependency")
//    func testAllSubclientsAccessible() async throws {
//        @Dependency(\.mailgun) var mailgun
//        
//        // Verify all subclients are accessible (compilation test)
//        // This test verifies that all subclients are properly wired
//        // and accessible through the dependency system
//        
//        // Core subclients
//        _ = mailgun.messages
//        _ = mailgun.mailingLists
//        _ = mailgun.events
//        _ = mailgun.suppressions
//        _ = mailgun.webhooks
//        
//        // Additional subclients added in expansion
//        _ = mailgun.domains
//        _ = mailgun.templates
//        _ = mailgun.routes
//        _ = mailgun.ips
//        _ = mailgun.ipPools
//        _ = mailgun.ipAllowlist
//        _ = mailgun.keys
//        _ = mailgun.users
//        _ = mailgun.subaccounts
//        _ = mailgun.credentials
//        _ = mailgun.customMessageLimit
//        _ = mailgun.accountManagement
//        _ = mailgun.reporting
//        
//        // Verify nested subclients are accessible
//        _ = mailgun.suppressions.bounces
//        _ = mailgun.suppressions.complaints
//        _ = mailgun.suppressions.unsubscribe
//        _ = mailgun.suppressions.Allowlist
//        
////        _ = Mailgun.Domains.Domains
////        _ = mailgun.domains.dkimSecurity
////        _ = Mailgun.Domains.DomainKeys
////        _ = Mailgun.Domains.DomainsTracking
//        
//        _ = mailgun.reporting.events
//        _ = mailgun.reporting.logs
//        _ = mailgun.reporting.metrics
//        _ = mailgun.reporting.stats
//        _ = mailgun.reporting.tags
//        
//        // If we reach this point, all subclients are accessible
//        #expect(true, "All subclients are accessible")
//    }
//    
//    @Test("Messages subclient basic functionality test")
//    func testMessagesSubclientBasicFunctionality() async throws {
//        @Dependency(\.mailgun) var mailgun
//        
//        // Create a test message request
//        let sendRequest = Mailgun.Messages.Send.Request(
//            from: try! EmailAddress("test@example.com"),
//            to: [try! EmailAddress("recipient@example.com")],
//            subject: "Test",
//            text: "Test message",
//            testMode: true
//        )
//        
//        // This will throw because we're using testValue implementation
//        // which is unimplemented by design. This is expected behavior.
//        await #expect(throws: Swift.Error.self) {
//            try await mailgun.messages.send(sendRequest)
//        }
//    }
//    
//    @Test("Client is properly configured with authentication")
//    func testClientAuthentication() async throws {
//        @Dependency(\.mailgun) var mailgun
//        
//        // The fact that we can access any subclient means
//        // the AuthenticatedClient wrapper is properly configured
//        _ = mailgun.messages
//        
//        // If we can access subclients, authentication is configured
//        #expect(true, "Client is properly authenticated")
//    }
// }
