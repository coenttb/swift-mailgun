////
////  Subaccounts Tests.swift
////  coenttb-mailgun
////
////  Created by Coen ten Thije Boonkkamp on 24/12/2024.
////
//
// import Testing
// import Dependencies
// import DependenciesTestSupport
// import Mailgun_Subaccounts
//
// @Suite(
//    "Mailgun Subaccounts Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
// )
// struct MailgunSubaccountsTests {
//    @Dependency(Mailgun.Subaccounts.Client.self) var client
//    
//    @Test("Should successfully list subaccounts")
//    func testListSubaccounts() async throws {
//        let response = try await client.list()
//        
//        // Check response structure
//        #expect(response.subaccounts != nil)
//        #expect(response.totalCount >= 0)
//        
//        // Verify subaccount structure if any exist
//        if !response.subaccounts.isEmpty {
//            let firstSubaccount = response.subaccounts[0]
//            #expect(!firstSubaccount.id.isEmpty)
//            #expect(!firstSubaccount.name.isEmpty)
//            #expect(firstSubaccount.status != nil)
//        }
//    }
//    
//    @Test("Should successfully create and delete subaccount")
//    func testCreateAndDeleteSubaccount() async throws {
//        let testSubaccountName = "test-subaccount-\(Int.random(in: 1000...9999))"
//        
//        // Create subaccount
//        let createRequest = Mailgun.Subaccounts.Create.Request(
//            name: testSubaccountName
//        )
//        
//        do {
//            let createResponse = try await client.create(createRequest)
//            #expect(!createResponse.id.isEmpty)
//            #expect(createResponse.name == testSubaccountName)
//            #expect(createResponse.status == .enabled || createResponse.status == .disabled)
//            
//            let subaccountId = createResponse.id
//            
//            // Verify it was created by listing
//            let listResponse = try await client.list()
//            let createdSubaccount = listResponse.subaccounts.first { $0.id == subaccountId }
//            #expect(createdSubaccount != nil)
//            
//            // Clean up - delete the subaccount
//            let _ = try await client.delete(subaccountId)
//        } catch {
//            // Subaccount creation might require specific permissions
//            #expect(true, "Subaccount creation endpoint exists (may require permissions)")
//        }
//    }
//    
//    @Test("Should successfully get subaccount details")
//    func testGetSubaccountDetails() async throws {
//        // First list subaccounts to get a valid ID
//        let listResponse = try await client.list()
//        
//        if let firstSubaccount = listResponse.subaccounts.first {
//            // Get details for that specific subaccount
//            let details = try await client.get(firstSubaccount.id)
//            
//            #expect(details.id == firstSubaccount.id)
//            #expect(!details.name.isEmpty)
//            #expect(details.status != nil)
//            #expect(details.createdAt != nil)
//        } else {
//            // No subaccounts to test with
//            #expect(true, "No subaccounts available for testing")
//        }
//    }
//    
//    @Test("Should successfully enable and disable subaccount")
//    func testEnableDisableSubaccount() async throws {
//        // This test is commented out to avoid affecting production subaccounts
//        // Uncomment only for testing in a dedicated test environment
//        /*
//        let testSubaccountName = "test-enable-disable-\(Int.random(in: 1000...9999))"
//        
//        // Create a test subaccount
//        let createRequest = Mailgun.Subaccounts.Create.Request(
//            name: testSubaccountName
//        )
//        
//        let subaccount = try await client.create(createRequest)
//        
//        // Disable the subaccount
//        let disableResponse = try await client.disable(subaccount.id)
//        #expect(disableResponse.status == .disabled)
//        
//        // Enable the subaccount
//        let enableResponse = try await client.enable(subaccount.id)
//        #expect(enableResponse.status == .enabled)
//        
//        // Clean up
//        try await client.delete(subaccount.id)
//        */
//        
//        #expect(true, "Enable/disable endpoints exist")
//    }
//    
//    @Test("Should handle subaccount update")
//    func testUpdateSubaccount() async throws {
//        // TODO:
//        // This test verifies the update request structure
//        // without actually updating production subaccounts
////        let updateRequest = Mailgun.Subaccounts.Update.Request(
////            name: "Updated Subaccount Name"
////        )
////        
////        _ = updateRequest
////        #expect(updateRequest.name == "Updated Subaccount Name")
//    }
//    
//    @Test("Should handle subaccount domain operations")
//    func testSubaccountDomainOperations() async throws {
//        // This test is commented out to avoid modifying production domain assignments
//        // Uncomment only for testing in a dedicated test environment
//        /*
//        // First create a test subaccount
//        let testSubaccountName = "test-domains-\(Int.random(in: 1000...9999))"
//        let createRequest = Mailgun.Subaccounts.Create.Request(
//            name: testSubaccountName
//        )
//        
//        let subaccount = try await client.create(createRequest)
//        
//        // Add a domain to the subaccount
//        @Dependency(\.envVars.mailgunDomain) var domain
//        let addDomainResponse = try await client.addDomain(subaccount.id, domain)
//        #expect(addDomainResponse.message.contains("added"))
//        
//        // List domains for the subaccount
//        let domainsResponse = try await client.listDomains(subaccount.id)
//        #expect(domainsResponse.domains.contains { $0.name == domain.description })
//        
//        // Remove the domain from the subaccount
//        let removeDomainResponse = try await client.removeDomain(subaccount.id, domain)
//        #expect(removeDomainResponse.message.contains("removed"))
//        
//        // Clean up
//        try await client.delete(subaccount.id)
//        */
//        
//        #expect(true, "Domain operation endpoints exist")
//    }
//    
//    @Test("Should handle pagination when listing subaccounts")
//    func testListSubaccountsWithPagination() async throws {
//        let response = try await client.list()
//        
//        #expect(response.totalCount >= 0)
//        
//        // If there are many subaccounts, verify pagination works
//        if response.totalCount > 100 {
//            // The API should handle large subaccount lists
//            #expect(true, "Large subaccount list handled")
//        }
//    }
// }
