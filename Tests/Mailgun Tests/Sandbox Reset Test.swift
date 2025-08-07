//
//  Sandbox Reset Test.swift
//  coenttb-mailgun
//
//  Created by Claude on 07/08/2025.
//

import Testing
import Dependencies
import Foundation
@testable import Mailgun
import Mailgun_Types
import Mailgun_Messages_Types
import Mailgun_Suppressions_Types
import Mailgun_Templates_Types
import Mailgun_Lists_Types
import EnvironmentVariables

@Suite(
    "Sandbox Reset Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .disabled("Only run manually to reset sandbox")
)
struct SandboxResetTests {
    
    @Test("Reset entire sandbox (deletes all test data except authorized recipients)")
    func testResetSandbox() async throws {
        @Dependency(\.mailgun) var mailgun
        @Dependency(\.envVars.mailgunDomain) var domain
        
        print("🗑️ Starting sandbox reset for domain: \(domain)")
        
        // 1. Delete all suppressions (except allowlist/authorized recipients)
        print("Deleting suppressions...")
        try await deleteAllSuppressions()
        
        // 2. Delete all test tags
        print("Deleting test tags...")
        try await deleteAllTestTags()
        
        // 3. Delete all test templates
        print("Deleting test templates...")
        try await deleteAllTestTemplates()
        
        // 4. Delete all test mailing lists
        print("Deleting test mailing lists...")
        try await deleteAllTestMailingLists()
        
        print("✅ Sandbox reset complete!")
    }
    
    // MARK: - Suppressions Cleanup
    
    private func deleteAllSuppressions() async throws {
        @Dependency(\.mailgun) var mailgun
        
        // Delete all bounces
        do {
            let bounces = try await mailgun.client.suppressions.bounces.list(nil)
            for bounce in bounces.items {
                print("  Deleting bounce: \(bounce.address)")
                try await mailgun.client.suppressions.bounces.delete(bounce.address)
            }
            print("  ✓ Deleted \(bounces.items.count) bounces")
        } catch {
            print("  ⚠️ Error deleting bounces: \(error)")
        }
        
        // Delete all complaints
        do {
            let complaints = try await mailgun.client.suppressions.complaints.list(nil)
            for complaint in complaints.items {
                print("  Deleting complaint: \(complaint.address)")
                try await mailgun.client.suppressions.complaints.delete(complaint.address)
            }
            print("  ✓ Deleted \(complaints.items.count) complaints")
        } catch {
            print("  ⚠️ Error deleting complaints: \(error)")
        }
        
        // Delete all unsubscribes
        do {
            let unsubscribes = try await mailgun.client.suppressions.unsubscribe.list(nil)
            for unsubscribe in unsubscribes.items {
                print("  Deleting unsubscribe: \(unsubscribe.address)")
                try await mailgun.client.suppressions.unsubscribe.delete(unsubscribe.address)
            }
            print("  ✓ Deleted \(unsubscribes.items.count) unsubscribes")
        } catch {
            print("  ⚠️ Error deleting unsubscribes: \(error)")
        }
        
        // Note: We intentionally skip allowlist/authorized recipients
        print("  ℹ️ Preserved allowlist/authorized recipients")
    }
    
    // MARK: - Tags Cleanup
    
    private func deleteAllTestTags() async throws {
        @Dependency(\.mailgun) var mailgun
        
        do {
            let tags = try await mailgun.client.reporting.tags.list(nil)
            
            // Filter for test tags (you might want to adjust this filter)
            let testTags = tags.items.filter { tag in
                tag.tag.lowercased().contains("test") ||
                tag.tag.lowercased().contains("temp") ||
                tag.tag.lowercased().contains("demo")
            }
            
            for tag in testTags {
                print("  Deleting tag: \(tag.tag)")
                do {
                    _ = try await mailgun.client.reporting.tags.delete(tag.tag)
                } catch {
                    print("    ⚠️ Error deleting tag \(tag.tag): \(error)")
                }
            }
            print("  ✓ Deleted \(testTags.count) test tags")
        } catch {
            print("  ⚠️ Error listing/deleting tags: \(error)")
        }
    }
    
    // MARK: - Templates Cleanup
    
    private func deleteAllTestTemplates() async throws {
        @Dependency(\.mailgun) var mailgun
        
        do {
            let templates = try await mailgun.client.templates.list(nil)
            
            // Filter for test templates
            let testTemplates = (templates.items ?? []).filter { template in
                template.name.lowercased().contains("test") ||
                template.name.lowercased().contains("temp") ||
                template.name.lowercased().contains("demo") ||
                template.name.hasPrefix("swift-sdk-")
            }
            
            for template in testTemplates {
                print("  Deleting template: \(template.name)")
                do {
                    try await mailgun.client.templates.delete(template.name)
                } catch {
                    print("    ⚠️ Error deleting template \(template.name): \(error)")
                }
            }
            print("  ✓ Deleted \(testTemplates.count) test templates")
        } catch {
            print("  ⚠️ Error listing/deleting templates: \(error)")
        }
    }
    
    // MARK: - Mailing Lists Cleanup
    
    private func deleteAllTestMailingLists() async throws {
        @Dependency(\.mailgun) var mailgun
        
        do {
            let lists = try await mailgun.client.mailingLists.list(.init())
            
            // Filter for test mailing lists
            let testLists = lists.items.filter { list in
                list.address.rawValue.contains("test") ||
                list.address.rawValue.contains("temp") ||
                list.address.rawValue.contains("demo") ||
                list.name?.lowercased().contains("test") == true
            }
            
            for list in testLists {
                print("  Deleting mailing list: \(list.address.rawValue)")
                do {
                    try await mailgun.client.mailingLists.delete(list.address)
                } catch {
                    print("    ⚠️ Error deleting list \(list.address.rawValue): \(error)")
                }
            }
            print("  ✓ Deleted \(testLists.count) test mailing lists")
        } catch {
            print("  ⚠️ Error listing/deleting mailing lists: \(error)")
        }
    }
    
    // MARK: - Helper function for manual cleanup of specific items
    
    @Test("Clean up specific test data by pattern")
    func testCleanupByPattern() async throws {
        @Dependency(\.mailgun) var mailgun
        
        // Example: Delete all tags starting with "integration-test-"
        let pattern = "integration-test-"
        
        let tags = try await mailgun.client.reporting.tags.list(nil)
        let matchingTags = tags.items.filter { $0.tag.hasPrefix(pattern) }
        
        for tag in matchingTags {
            print("Deleting tag: \(tag.tag)")
            _ = try await mailgun.client.reporting.tags.delete(tag.tag)
        }
        
        print("✓ Deleted \(matchingTags.count) tags matching pattern '\(pattern)'")
    }
    
    // MARK: - Dry run to see what would be deleted
    
    @Test("Dry run - show what would be deleted")
    func testDryRun() async throws {
        @Dependency(\.mailgun) var mailgun
        @Dependency(\.envVars.mailgunDomain) var domain
        
        print("🔍 Dry run for domain: \(domain)")
        print("The following items would be deleted:")
        
        // Show suppressions
        print("\n📧 Suppressions:")
        do {
            let bounces = try await mailgun.client.suppressions.bounces.list(nil)
            print("  - \(bounces.items.count) bounces")
            
            let complaints = try await mailgun.client.suppressions.complaints.list(nil)
            print("  - \(complaints.items.count) complaints")
            
            let unsubscribes = try await mailgun.client.suppressions.unsubscribe.list(nil)
            print("  - \(unsubscribes.items.count) unsubscribes")
        } catch {
            print("  Error fetching suppressions: \(error)")
        }
        
        // Show test tags
        print("\n🏷️ Test Tags:")
        do {
            let tags = try await mailgun.client.reporting.tags.list(nil)
            let testTags = tags.items.filter { tag in
                tag.tag.lowercased().contains("test") ||
                tag.tag.lowercased().contains("temp") ||
                tag.tag.lowercased().contains("demo")
            }
            print("  - \(testTags.count) test tags")
            for tag in testTags.prefix(5) {
                print("    • \(tag.tag)")
            }
            if testTags.count > 5 {
                print("    ... and \(testTags.count - 5) more")
            }
        } catch {
            print("  Error fetching tags: \(error)")
        }
        
        // Show test templates
        print("\n📄 Test Templates:")
        do {
            let templates = try await mailgun.client.templates.list(nil)
            let testTemplates = (templates.items ?? []).filter { template in
                template.name.lowercased().contains("test") ||
                template.name.lowercased().contains("temp") ||
                template.name.lowercased().contains("demo") ||
                template.name.hasPrefix("swift-sdk-")
            }
            print("  - \(testTemplates.count) test templates")
            for template in testTemplates.prefix(5) {
                print("    • \(template.name)")
            }
            if testTemplates.count > 5 {
                print("    ... and \(testTemplates.count - 5) more")
            }
        } catch {
            print("  Error fetching templates: \(error)")
        }
        
        // Show test mailing lists
        print("\n📋 Test Mailing Lists:")
        do {
            let lists = try await mailgun.client.mailingLists.list(.init())
            let testLists = lists.items.filter { list in
                list.address.rawValue.contains("test") ||
                list.address.rawValue.contains("temp") ||
                list.address.rawValue.contains("demo") ||
                list.name?.lowercased().contains("test") == true
            }
            print("  - \(testLists.count) test mailing lists")
            for list in testLists.prefix(5) {
                print("    • \(list.address.rawValue)")
            }
            if testLists.count > 5 {
                print("    ... and \(testLists.count - 5) more")
            }
        } catch {
            print("  Error fetching mailing lists: \(error)")
        }
        
        print("\n⚠️ This is a dry run. No data was deleted.")
        print("Remove the .disabled attribute from testResetSandbox to actually delete.")
    }
}
