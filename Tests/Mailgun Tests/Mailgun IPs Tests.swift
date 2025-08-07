import Dependencies
import DependenciesTestSupport
import Mailgun
import Testing
//
// @Suite(
//    "Mailgun IPs Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
// )
// struct MailgunIPsTests {
//    @Dependency(Mailgun.IPs.self) var ips
//    @Dependency(\.envVars.mailgun.domain) var domain
//    
//    @Test("Should successfully list all IPs")
//    func testListIPs() async throws {
//        let response = try await client.list()
//        
//        // Check response structure
//        #expect(response.items.count >= 0)
//        #expect(response.totalCount >= 0)
//        
//        // If there are IPs, verify their structure
//        if let firstIP = response.items.first {
//            #expect(!firstIP.ip.isEmpty)
//            #expect(firstIP.dedicated == true || firstIP.dedicated == false)
//        }
//    }
//    
//    @Test("Should successfully get IP details")
//    func testGetIPDetails() async throws {
//        // First get list of IPs to have a valid IP to test with
//        let listResponse = try await client.list()
//        
//        guard let testIP = listResponse.items.first?.ip else {
//            // Skip test if no IPs available
//            return
//        }
//        
//        let response = try await client.get(testIP)
//        
//        #expect(response.ip == testIP)
//        #expect(response.dedicated == true || response.dedicated == false)
//    }
//    
//    @Test("Should successfully list domains for IP")
//    func testListDomainsForIP() async throws {
//        // First get list of IPs
//        let listResponse = try await client.list()
//        
//        guard let testIP = listResponse.items.first?.ip else {
//            // Skip test if no IPs available
//            return
//        }
//        
//        let response = try await client.listDomains(testIP)
//        
//        // Should return a domain list response (even if empty)
//        #expect(response.items.count >= 0)
//    }
// }
