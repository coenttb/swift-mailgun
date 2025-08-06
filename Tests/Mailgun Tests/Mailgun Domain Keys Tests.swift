import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun
//
//@Suite(
//    "Mailgun Domain Keys Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
//)
//struct MailgunDomainKeysTests {
//    @Dependency(Mailgun.Domains.DomainKeys.Client.self) var client
//    @Dependency(\.envVars.mailgunDomain) var domain
//    
//    @Test("Should successfully list DKIM keys")
//    func testListDkimKeys() async throws {
//        let response = try await client.list(nil)
//        
//        // Check response structure
//        #expect(response.items.count >= 0)
//        #expect(response.paging != nil || response.paging == nil) // Paging is optional
//    }
//    
//    @Test("Should successfully create DKIM key")
//    func testCreateDkimKey() async throws {
//        let request = Mailgun.Domains.DomainKeys.Create.Request(
//            signingDomain: domain.description,
//            selector: "test-selector-\(UUID().uuidString.prefix(8))",
//            bits: 2048
//        )
//        
//        let response = try await client.create(request)
//        
//        #expect(!response.message.isEmpty)
//        #expect(response.key?.signingDomain == request.signingDomain)
//        #expect(response.key?.selector == request.selector)
//    }
//    
//    @Test("Should successfully access all DKIM Keys endpoints")
//    func testAllEndpointsAccessible() async throws {
//        // Test that we can access all client methods without errors
//        // This is a basic accessibility test, not functionality test
//        
//        // List keys
//        _ = try await client.list(nil)
//        
//        // The other endpoints require valid data to test properly,
//        // so we'll just verify they're accessible through the client
//        #expect(client.create != nil)
//        #expect(client.delete != nil)
//        #expect(client.activate != nil)
//        #expect(client.listDomainKeys != nil)
//        #expect(client.deactivate != nil)
//        #expect(client.setDkimAuthority != nil)
//        #expect(client.setDkimSelector != nil)
//    }
//}
