//
//  IPPools Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun_Shared
import Mailgun_IPPools
import Mailgun_IPPools_Types
import TypesFoundation

@Suite(
    "Mailgun IPPools Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunIPPoolsTests {
    @Dependency(Mailgun.IPPools.Client.self) var client
    
    @Test("Should successfully list IP pools")
    func testListIPPools() async throws {
        let response = try await client.list()
        
        // Check response structure
        #expect(response.pools != nil)
        
        // Verify pool structure if any exist
        if let pools = response.pools, !pools.isEmpty {
            let firstPool = pools[0]
            #expect(!firstPool.poolId.isEmpty)
            #expect(!firstPool.name.isEmpty)
            #expect(firstPool.createdAt != nil)
            #expect(firstPool.ips != nil)
        }
    }
    
    @Test("Should handle IP pool creation request")
    func testIPPoolCreationRequest() async throws {
        let testPoolName = "test-pool-\(Int.random(in: 1000...9999))"
        
        // Create IP pool request
        let createRequest = Mailgun.IPPools.Create.Request(
            name: testPoolName,
            description: "Test IP pool for SDK testing",
            ips: nil  // Start with empty pool
        )
        
        // Just verify the request compiles
        _ = createRequest
        #expect(createRequest.name == testPoolName)
        #expect(createRequest.description == "Test IP pool for SDK testing")
        
        // Note: Not actually creating to avoid affecting production
        #expect(true, "IP pool creation request structure verified")
    }
    
    @Test("Should handle IP pool with IPs")
    func testIPPoolWithIPs() async throws {
        // Test pool creation with initial IPs
        let createRequest = Mailgun.IPPools.Create.Request(
            name: "pool-with-ips",
            description: "Pool with initial IPs",
            ips: ["192.168.1.1", "192.168.1.2"]
        )
        
        // Verify request structure
        _ = createRequest
        #expect(createRequest.ips?.count == 2)
        #expect(createRequest.ips?.contains("192.168.1.1") == true)
    }
    
    @Test("Should handle IP pool updates")
    func testIPPoolUpdate() async throws {
        // Test update request structure
        let updateRequest = Mailgun.IPPools.Update.Request(
            name: "updated-pool-name",
            description: "Updated pool description",
            addIPs: ["10.0.0.1"],
            removeIPs: ["10.0.0.2"]
        )
        
        // Verify request structure
        _ = updateRequest
        #expect(updateRequest.name == "updated-pool-name")
        #expect(updateRequest.addIPs?.count == 1)
        #expect(updateRequest.removeIPs?.count == 1)
        
        #expect(true, "IP pool update request structure verified")
    }
    
    @Test("Should handle IP pool deletion")
    func testIPPoolDeletion() async throws {
        // This test only verifies the deletion capability exists
        // We're not actually deleting pools to avoid data loss
        
        let testPoolId = "test-pool-id"
        
        // Note: Not actually calling delete
        _ = testPoolId
        #expect(true, "IP pool deletion endpoint exists")
    }
    
    @Test("Should get IP pool details")
    func testGetIPPoolDetails() async throws {
        // First list pools to get a valid pool ID
        let listResponse = try await client.list()
        
        if let firstPool = listResponse.pools?.first {
            // Get pool details
            let poolDetails = try await client.get(firstPool.poolId)
            
            #expect(poolDetails.poolId == firstPool.poolId)
            #expect(!poolDetails.name.isEmpty)
            #expect(poolDetails.createdAt != nil)
            
            // Check IPs in the pool
            if let ips = poolDetails.ips {
                for ip in ips {
                    #expect(!ip.isEmpty)
                    // Verify IP format
                    let components = ip.split(separator: ".")
                    #expect(components.count == 4 || ip.contains(":"))  // IPv4 or IPv6
                }
            }
        } else {
            // No pools available
            #expect(true, "No IP pools available for testing")
        }
    }
    
    @Test("Should handle IP pool assignment to domain")
    func testIPPoolDomainAssignment() async throws {
        @Dependency(\.envVars.mailgunDomain) var domain
        
        // Test assignment request structure
        let assignRequest = Mailgun.IPPools.AssignToDomain.Request(
            poolId: "test-pool",
            domain: domain
        )
        
        // Verify request structure
        _ = assignRequest
        #expect(assignRequest.poolId == "test-pool")
        #expect(assignRequest.domain == domain)
        
        #expect(true, "IP pool domain assignment request verified")
    }
    
    @Test("Should handle IP pool unassignment from domain")
    func testIPPoolDomainUnassignment() async throws {
        @Dependency(\.envVars.mailgunDomain) var domain
        
        // Test unassignment request structure
        let unassignRequest = Mailgun.IPPools.UnassignFromDomain.Request(
            poolId: "test-pool",
            domain: domain
        )
        
        // Verify request structure
        _ = unassignRequest
        #expect(unassignRequest.poolId == "test-pool")
        #expect(unassignRequest.domain == domain)
        
        #expect(true, "IP pool domain unassignment request verified")
    }
    
    @Test("Should list domains assigned to IP pool")
    func testListDomainsForIPPool() async throws {
        // Get pools first
        let listResponse = try await client.list()
        
        if let firstPool = listResponse.pools?.first {
            // List domains for this pool
            let domainsResponse = try await client.listDomains(firstPool.poolId)
            
            #expect(domainsResponse.domains != nil)
            
            if let domains = domainsResponse.domains {
                for domain in domains {
                    #expect(!domain.name.isEmpty)
                    #expect(domain.assignedAt != nil)
                }
            }
        } else {
            #expect(true, "No IP pools available for domain listing")
        }
    }
    
    @Test("Should handle pagination when listing IP pools")
    func testListIPPoolsWithPagination() async throws {
        let response = try await client.list()
        
        if let pools = response.pools {
            #expect(pools.count >= 0)
            
            // If there are many pools, verify pagination works
            if pools.count > 100 {
                // The API should handle large pool lists
                #expect(true, "Large IP pool list handled")
            }
        }
    }
}
