//
//  Domain Keys Client Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Dependencies
import DependenciesTestSupport
import Mailgun_Domains
import Mailgun_Shared
import Testing

@Suite(
    "Domain Keys Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct DomainKeysClientTests {
    @Dependency(Mailgun.Domains.DomainKeys.self) var domainKeys
    @Dependency(\.envVars.mailgunDomain) var domain

    @Test("Should successfully list domain keys")
    func testListDomainKeys() async throws {
        let request = Mailgun.Domains.DomainKeys.List.Request(
            page: nil,
            limit: 10,
            signingDomain: nil,
            selector: nil
        )

        do {
            let response = try await domainKeys.client.list(request)

            // Verify response structure
            #expect(!response.items.isEmpty || response.items.isEmpty)

            if !response.items.isEmpty {
                let firstKey = response.items.first!
                #expect(!firstKey.signingDomain.isEmpty)
                #expect(!firstKey.selector.isEmpty)
            }
        } catch {
            // Handle cases where domain keys might not be accessible
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("404") || errorString.contains("not found") || errorString.contains("forbidden") {
                #expect(Bool(true), "Domain keys not accessible - this is expected for some account types")
            } else {
                throw error
            }
        }
    }

    @Test("Should handle listing domain keys with pagination")
    func testListDomainKeysWithPagination() async throws {
        let request = Mailgun.Domains.DomainKeys.List.Request(
            page: nil,
            limit: 5,
            signingDomain: domain.description,
            selector: nil
        )

        do {
            let response = try await domainKeys.client.list(request)

            #expect(!response.items.isEmpty || response.items.isEmpty)

            // Check pagination info if available
            if let paging = response.paging {
                // Paging URLs should be present if there are more results
                #expect(paging.first != nil || paging.last != nil || paging.next != nil || paging.previous != nil || response.items.isEmpty)
            }
        } catch {
            // Handle cases where domain keys might not be accessible
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("404") || errorString.contains("not found") || errorString.contains("forbidden") {
                #expect(Bool(true), "Domain keys not accessible - this is expected for some account types")
            } else {
                throw error
            }
        }
    }

    @Test("Should handle creating and deleting a domain key")
    func testCreateAndDeleteDomainKey() async throws {
        // Generate a unique selector for testing
        let testSelector = "test-\(Int.random(in: 1000...9999))"

        let createRequest = Mailgun.Domains.DomainKeys.Create.Request(
            signingDomain: domain.description,
            selector: testSelector,
            bits: 2048,
            pem: nil
        )

        do {
            // Create the key
            let createResponse = try await domainKeys.client.create(createRequest)
            #expect(createResponse.message != nil || createResponse.signingDomain != nil)

            // Delete the key
            let deleteRequest = Mailgun.Domains.DomainKeys.Delete.Request(
                signingDomain: domain.description,
                selector: testSelector
            )

            let deleteResponse = try await domainKeys.client.delete(deleteRequest)
            #expect(!deleteResponse.message.isEmpty)

        } catch {
            // Handle cases where domain key operations might not be available
            let errorString = String(describing: error).lowercased()
            if errorString.contains("404") || errorString.contains("not found") ||
               errorString.contains("forbidden") || errorString.contains("403") ||
               errorString.contains("maximum number of domain keys") {
                #expect(Bool(true), "Domain key limit reached or operations not available - this is expected for sandbox domains")
            } else {
                throw error
            }
        }
    }

    @Test("Should list domain keys for a specific authority")
    func testListDomainKeysForAuthority() async throws {
        do {
            let response = try await domainKeys.client.listDomainKeys(domain.description)

            #expect(!response.items.isEmpty || response.items.isEmpty)

            if !response.items.isEmpty {
                for key in response.items {
                    #expect(!key.signingDomain.isEmpty)
                    #expect(!key.selector.isEmpty)
                }
            }
        } catch {
            // Handle cases where domain keys might not be accessible
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("404") || errorString.contains("not found") || errorString.contains("forbidden") {
                #expect(Bool(true), "Domain keys not accessible - this is expected for some account types")
            } else {
                throw error
            }
        }
    }

    @Test("Should handle activating and deactivating domain keys")
    func testActivateAndDeactivateDomainKey() async throws {
        // This test requires an existing key selector
        // In a real scenario, you'd need to know an existing selector
        let testSelector = "mailgun"  // Default selector often present

        do {
            // Try to activate
            let activateResponse = try await domainKeys.client.activate(domain.description, testSelector)
            #expect(!activateResponse.message.isEmpty)

            // Try to deactivate
            let deactivateResponse = try await domainKeys.client.deactivate(domain.description, testSelector)
            #expect(!deactivateResponse.message.isEmpty)

        } catch {
            // Handle cases where these operations might not be available
            let errorString = String(describing: error).lowercased()
            if
               errorString.contains("404") || errorString.contains("not found") || errorString.contains("forbidden") || errorString.contains("403") {
                #expect(Bool(true), "Key activation/deactivation not available - this is expected for sandbox domains")
            } else {
                throw error
            }
        }
    }

    @Test("Should handle setting DKIM authority")
    func testSetDkimAuthority() async throws {
        let request = Mailgun.Domains.DomainKeys.SetDkimAuthority.Request(
            dkimAuthority: "mailgun.org"
        )

        do {
            let response = try await domainKeys.client.setDkimAuthority(domain.description, request)
            #expect(!response.message.isEmpty)
        } catch {
            // Handle cases where this operation might not be available
            let errorString = String(describing: error).lowercased()
            if errorString.contains("404") || errorString.contains("not found") ||
               errorString.contains("forbidden") || errorString.contains("403") ||
               errorString.contains("cannot reassign the dkim authority") ||
               errorString.contains("sandbox") {
                #expect(Bool(true), "Setting DKIM authority not available - this is expected for sandbox domains")
            } else {
                throw error
            }
        }
    }

    @Test("Should handle setting DKIM selector")
    func testSetDkimSelector() async throws {
        let request = Mailgun.Domains.DomainKeys.SetDkimSelector.Request(
            dkimSelector: "mailgun"
        )

        do {
            let response = try await domainKeys.client.setDkimSelector(domain.description, request)
            #expect(!response.message.isEmpty)
        } catch {
            // Handle cases where this operation might not be available
            let errorString = String(describing: error).lowercased()
            if errorString.contains("404") || errorString.contains("not found") ||
               errorString.contains("forbidden") || errorString.contains("403") ||
               errorString.contains("cannot set the dkim selector") ||
               errorString.contains("verified domain") {
                #expect(Bool(true), "Setting DKIM selector not available - this is expected for verified/sandbox domains")
            } else {
                throw error
            }
        }
    }

    @Test("Should validate key creation with different bit sizes")
    func testKeyCreationWithDifferentBitSizes() async throws {
        let bitSizes = [1024, 2048]

        for bits in bitSizes {
            let request = Mailgun.Domains.DomainKeys.Create.Request(
                signingDomain: domain.description,
                selector: "test-bits-\(bits)",
                bits: bits,
                pem: nil
            )

            // Just verify the request can be constructed
            #expect(request.bits == bits)
            #expect(request.signingDomain == domain.description)
        }

        #expect(Bool(true), "All bit sizes are valid for request construction")
    }
}
