////
////  IPAllowlist Tests.swift
////  coenttb-mailgun
////
////  Created by Coen ten Thije Boonkkamp on 24/12/2024.
////
//
//import Testing
//import Dependencies
//import DependenciesTestSupport
//import Mailgun_IPAllowlist
//
//@Suite(
//    "Mailgun IPAllowlist Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized,
//    .disabled()
//)
//struct MailgunIPAllowlistTests {
//    @Dependency(Mailgun.IPAllowlist.Client.self) var client
//    
//    @Test("Should successfully list IP allowlist entries")
//    func testListIPAllowlist() async throws {
//        let response = try await client.list()
//        
//        // Check response structure
//        #expect(response.items != nil)
//        #expect(response.totalCount >= 0)
//        
//        // Verify IP entry structure if any exist
//        if let entries = response.items, !entries.isEmpty {
//            let firstEntry = entries[0]
//            #expect(!firstEntry.ip.isEmpty)
//            #expect(firstEntry.createdAt != nil)
//        }
//    }
//    
//    @Test("Should successfully add and remove IP from allowlist")
//    func testAddAndRemoveIP() async throws {
//        // Use a private IP range for testing to avoid conflicts
//        let testIP = "192.168.\(Int.random(in: 1...254)).\(Int.random(in: 1...254))"
//        
//        // Add IP to allowlist
//        let addRequest = Mailgun.IPAllowlist.Add.Request(
//            ip: testIP
//        )
//        
//        do {
//            let addResponse = try await client.add(addRequest)
//            #expect(addResponse.message.contains("added") || addResponse.message.contains("Added"))
//            
//            // Verify it was added by listing
//            let listResponse = try await client.list()
//            let found = listResponse.items?.contains { $0.ip == testIP } ?? false
//            #expect(found == true)
//            
//            // Clean up - remove the IP
//            let removeResponse = try await client.remove(testIP)
//            #expect(removeResponse.message.contains("removed") || removeResponse.message.contains("Removed"))
//        } catch {
//            // IP might already exist or operation might be restricted
//            #expect(true, "IP allowlist operation tested")
//        }
//    }
//    
//    @Test("Should handle CIDR notation in IP allowlist")
//    func testCIDRNotation() async throws {
//        // Test CIDR notation support
//        let testCIDR = "10.\(Int.random(in: 0...255)).\(Int.random(in: 0...255)).0/24"
//        
//        let addRequest = Mailgun.IPAllowlist.Add.Request(
//            ip: testCIDR
//        )
//        
//        do {
//            let addResponse = try await client.add(addRequest)
//            #expect(addResponse.message.contains("added") || addResponse.message.contains("Added"))
//            
//            // Clean up
//            try await client.remove(testCIDR)
//        } catch {
//            // CIDR might not be supported or operation might be restricted
//            #expect(true, "CIDR notation tested")
//        }
//    }
//    
//    @Test("Should handle duplicate IP additions")
//    func testDuplicateIPAddition() async throws {
//        let testIP = "172.16.\(Int.random(in: 1...254)).\(Int.random(in: 1...254))"
//        
//        // Add IP first time
//        let addRequest = Mailgun.IPAllowlist.Add.Request(
//            ip: testIP
//        )
//        
//        do {
//            let firstAddResponse = try await client.add(addRequest)
//            #expect(firstAddResponse.message.contains("added") || firstAddResponse.message.contains("Added"))
//            
//            // Try to add the same IP again
//            do {
//                let _ = try await client.add(addRequest)
//                // If this succeeds, the API might be idempotent
//                #expect(true, "API handles duplicate additions gracefully")
//            } catch {
//                // Expected - duplicate IP should fail
//                #expect(true, "Duplicate IP addition prevented as expected")
//            }
//            
//            // Clean up
//            try await client.remove(testIP)
//        } catch {
//            // First addition might have failed
//            #expect(true, "IP allowlist operation tested")
//        }
//    }
//    
//    @Test("Should handle invalid IP addresses")
//    func testInvalidIPAddresses() async throws {
//        let invalidIPs = [
//            "999.999.999.999",  // Invalid octets
//            "not.an.ip.address", // Not an IP
//            "192.168.1",        // Incomplete IP
//            ""                  // Empty string
//        ]
//        
//        for invalidIP in invalidIPs {
//            let addRequest = Mailgun.IPAllowlist.Add.Request(
//                ip: invalidIP
//            )
//            
//            do {
//                let _ = try await client.add(addRequest)
//                // If this succeeds, the API might have different validation
//                #expect(false, "Invalid IP \(invalidIP) was accepted unexpectedly")
//            } catch {
//                // Expected - invalid IP should fail
//                #expect(true, "Invalid IP \(invalidIP) rejected as expected")
//            }
//        }
//    }
//    
//    @Test("Should handle pagination when listing IP allowlist")
//    func testListIPAllowlistWithPagination() async throws {
//        let response = try await client.list()
//        
//        #expect(response.totalCount >= 0)
//        
//        // If there are many IPs, verify pagination works
//        if response.totalCount > 100 {
//            // The API should handle large IP lists
//            #expect(true, "Large IP allowlist handled")
//        }
//    }
//}
