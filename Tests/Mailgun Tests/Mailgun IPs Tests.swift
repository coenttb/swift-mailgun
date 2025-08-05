import Testing
import Dependencies
import Mailgun
import Mailgun_IPs
import Mailgun_IPs_Types
import TypesFoundation

@Suite(
    "Mailgun IPs Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunIPsTests {
    @Dependency(Mailgun.IPs.Client.self) var client
    @Dependency(\.envVars.mailgunDomain) var domain
    
    @Test("Should successfully list all IPs")
    func testListIPs() async throws {
        let response = try await client.list()
        
        // Check response structure
        #expect(response.items != nil)
        #expect(response.totalCount >= 0)
        
        // If there are IPs, verify their structure
        if let firstIP = response.items.first {
            #expect(!firstIP.ip.isEmpty)
            #expect(firstIP.dedicated != nil)
        }
    }
    
    @Test("Should successfully list IPs for specific domain")
    func testListIPsForDomain() async throws {
        let response = try await client.listDomain(domain)
        
        // Check response structure
        #expect(response.items != nil)
        
        // Domain might not have dedicated IPs, so just verify structure
        if let firstIP = response.items.first {
            #expect(!firstIP.ip.isEmpty)
        }
    }
    
    @Test("Should successfully get IP details")
    func testGetIPDetails() async throws {
        // First get list of IPs to have a valid IP to test with
        let listResponse = try await client.list()
        
        guard let testIP = listResponse.items.first?.ip else {
            // Skip test if no IPs available
            return
        }
        
        let response = try await client.get(testIP)
        
        #expect(response.ip == testIP)
        #expect(response.dedicated != nil)
        #expect(response.rdns != nil)
    }
}