import Testing
import Dependencies
import Mailgun
import Mailgun_Domains
import Mailgun_Domains_Types
import TypesFoundation

@Suite(
    "Mailgun Domains Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunDomainsTests {
    @Dependency(Mailgun.Domains.Client.self) var client
    @Dependency(\.envVars.mailgunDomain) var domain
    
    @Test("Should successfully list domains")
    func testListDomains() async throws {
        let response = try await client.domain.list()
        
        #expect(response.items.count > 0)
        #expect(response.totalCount > 0)
        
        // Verify we can find our test domain
        let hasDomain = response.items.contains { $0.name == domain.description }
        #expect(hasDomain, "Test domain should be in the list")
    }
    
    @Test("Should successfully get domain details")
    func testGetDomainDetails() async throws {
        let response = try await client.domain.get(domain)
        
        #expect(response.domain.name == domain.description)
        #expect(!response.domain.id.isEmpty)
        #expect(response.domain.state == "active" || response.domain.state == "unverified")
    }
    
    @Test("Should successfully get DKIM tracking settings")
    func testGetDKIMTracking() async throws {
        let response = try await client.domainTracking.get(domain)
        
        // Verify tracking settings structure
        #expect(response.tracking != nil)
        #expect(response.tracking.click != nil)
        #expect(response.tracking.open != nil)
        #expect(response.tracking.unsubscribe != nil)
    }
    
    @Test("Should handle DKIM tracking updates")
    func testUpdateDKIMTracking() async throws {
        // Test click tracking update
        let clickRequest = Mailgun.Domains.DKIM_Tracking.UpdateClick.Request(
            active: true
        )
        
        let clickResponse = try await client.domainTracking.updateClick(domain, clickRequest)
        #expect(clickResponse.message.contains("updated") || clickResponse.message.contains("Domain tracking"))
        
        // Test open tracking update
        let openRequest = Mailgun.Domains.DKIM_Tracking.UpdateOpen.Request(
            active: true
        )
        
        let openResponse = try await client.domainTracking.updateOpen(domain, openRequest)
        #expect(openResponse.message.contains("updated") || openResponse.message.contains("Domain tracking"))
    }
    
    @Test("Should successfully verify domain connection")
    func testVerifyDomainConnection() async throws {
        let response = try await client.domain.verify(domain)
        
        #expect(response.message.contains("verified") || response.message.contains("Domain"))
    }
}