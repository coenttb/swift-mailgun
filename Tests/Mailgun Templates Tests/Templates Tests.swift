//
//  Templates Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun_Templates
import Foundation

@Suite(
    "Mailgun Templates Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunTemplatesTests {
    
    @Test("Should successfully list templates")
    func testListTemplates() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client
        
        let response = try await client.list(nil)
        
        #expect(response.paging.first.contains("/templates"))
        #expect(response.paging.last.contains("/templates"))
        
        if let items = response.items, !items.isEmpty {
            let firstTemplate = items[0]
            #expect(!firstTemplate.name.isEmpty)
        }
    }
    
    @Test("Should successfully create and delete template")
    func testCreateAndDeleteTemplate() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client
        
        let testTemplateName = "test-template-\(UUID().uuidString.prefix(8))".lowercased()
        
        let createRequest = Mailgun.Templates.Create.Request(
            name: testTemplateName,
            description: "Test template for automated testing",
            template: "<html><body>Hello {{name}}!</body></html>",
            tag: "initial",
            comment: "Initial version created by tests"
        )
        
        // Create template
        let createResponse = try await client.create(createRequest)
        #expect(createResponse.message.contains("stored"))
        
        if let template = createResponse.template {
            #expect(template.name == testTemplateName)
            #expect(template.description == "Test template for automated testing")
            
            // Delete the template
            let deleteResponse = try await client.delete(testTemplateName)
            #expect(deleteResponse.message.contains("deleted"))
            #expect(deleteResponse.template.name == testTemplateName)
        }
    }
    
    @Test("Should successfully get template")
    func testGetTemplate() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client
        
        let testTemplateName = "test-get-template-\(UUID().uuidString.prefix(8))".lowercased()
        
        // First create a template
        let createRequest = Mailgun.Templates.Create.Request(
            name: testTemplateName,
            description: "Template for get test"
        )
        
        let createResponse = try await client.create(createRequest)
        
        if createResponse.template != nil {
            // Get the template
            let getResponse = try await client.get(testTemplateName, nil)
            
            if let template = getResponse.template {
                #expect(template.name == testTemplateName)
                #expect(template.description == "Template for get test")
            }
            
            // Get with active version
            let getActiveResponse = try await client.get(
                testTemplateName, 
                Mailgun.Templates.Get.Request(active: "yes")
            )
            
            if let template = getActiveResponse.template {
                #expect(template.name == testTemplateName)
            }
            
            // Clean up
            _ = try? await client.delete(testTemplateName)
        }
    }
    
    @Test("Should successfully update template")
    func testUpdateTemplate() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client
        
        let testTemplateName = "test-update-template-\(UUID().uuidString.prefix(8))".lowercased()
        
        // Create template
        let createRequest = Mailgun.Templates.Create.Request(
            name: testTemplateName,
            description: "Original description"
        )
        
        let createResponse = try await client.create(createRequest)
        
        if createResponse.template != nil {
            // Update template
            let updateRequest = Mailgun.Templates.Update.Request(
                description: "Updated description"
            )
            
            let updateResponse = try await client.update(testTemplateName, updateRequest)
            #expect(updateResponse.message.contains("updated"))
            #expect(updateResponse.template.name == testTemplateName)
            
            // Verify update
            let getResponse = try await client.get(testTemplateName, nil)
            if let template = getResponse.template {
                #expect(template.description == "Updated description")
            }
            
            // Clean up
            _ = try? await client.delete(testTemplateName)
        }
    }
    
    @Test("Should successfully manage template versions")
    func testTemplateVersions() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client
        
        let testTemplateName = "test-versions-template-\(UUID().uuidString.prefix(8))".lowercased()
        
        // Create template with initial version
        let createRequest = Mailgun.Templates.Create.Request(
            name: testTemplateName,
            description: "Template for version testing",
            template: "<html><body>Version 1: Hello {{name}}!</body></html>",
            tag: "v1",
            comment: "Initial version"
        )
        
        let createResponse = try await client.create(createRequest)
        
        if createResponse.template != nil {
            // Create a new version
            let versionRequest = Mailgun.Templates.Version.Create.Request(
                template: "<html><body>Version 2: Hi {{name}}!</body></html>",
                tag: "v2",
                comment: "Second version",
                active: "yes"
            )
            
            let versionResponse = try await client.createVersion(testTemplateName, versionRequest)
            #expect(versionResponse.message.contains("stored"))
            
            // List versions
            let versionsResponse = try await client.versions(testTemplateName, nil)
            
            if let template = versionsResponse.template,
               let versions = template.versions {
                #expect(versions.count >= 2)
                #expect(versions.contains { $0.tag == "v1" })
                #expect(versions.contains { $0.tag == "v2" })
            }
            
            // Get specific version
            let getVersionResponse = try await client.getVersion(testTemplateName, "v2")
            if let template = getVersionResponse.template,
               let version = template.version {
                #expect(version.tag == "v2")
                #expect(version.template?.contains("Version 2") == true)
            }
            
            // Update version
            let updateVersionRequest = Mailgun.Templates.Version.Update.Request(
                comment: "Updated comment for v2",
                active: "no"  // Make it inactive before deletion
            )
            
            let updateVersionResponse = try await client.updateVersion(
                testTemplateName,
                "v2",
                updateVersionRequest
            )
            #expect(updateVersionResponse.message.contains("updated"))
            
            // Delete version (should work now that it's inactive)
            let deleteVersionResponse = try await client.deleteVersion(testTemplateName, "v1")  // Delete v1 instead since v2 might still be active
            #expect(deleteVersionResponse.message.contains("deleted"))
            
            // Clean up
            _ = try? await client.delete(testTemplateName)
        }
    }
    
    @Test("Should successfully copy template version")
    func testCopyVersion() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client
        
        let testTemplateName = "test-copy-template-\(UUID().uuidString.prefix(8))".lowercased()
        
        // Create template with initial version
        let createRequest = Mailgun.Templates.Create.Request(
            name: testTemplateName,
            description: "Template for copy testing",
            template: "<html><body>Original: {{content}}</body></html>",
            tag: "original",
            comment: "Original version"
        )
        
        let createResponse = try await client.create(createRequest)
        
        if createResponse.template != nil {
            // Copy the version
            let copyRequest = Mailgun.Templates.Version.Copy.Request(
                comment: "Copied from original"
            )
            
            let copyResponse = try await client.copyVersion(
                testTemplateName,
                "original",
                "copied",
                copyRequest
            )
            
            #expect(copyResponse.message.contains("copied"))
            
            if let version = copyResponse.version {
                #expect(version.tag == "copied")
                #expect(version.template?.contains("Original") == true)
            }
            
            // Clean up
            _ = try? await client.delete(testTemplateName)
        }
    }
    
    @Test("Should handle listing with pagination")
    func testListWithPagination() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client
        
        let request = Mailgun.Templates.List.Request(
            page: .first,
            limit: 1
        )
        
        let response = try await client.list(request)
        
        #expect(response.paging.first.contains("limit=1"))
        
        if let items = response.items {
            #expect(items.count <= 1)
        }
    }
    
    @Test("Should handle version listing with pagination")
    func testVersionsWithPagination() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client
        
        let testTemplateName = "test-pagination-template-\(UUID().uuidString.prefix(8))".lowercased()
        
        // Create template
        let createRequest = Mailgun.Templates.Create.Request(
            name: testTemplateName,
            description: "Template for pagination testing"
        )
        
        let createResponse = try await client.create(createRequest)
        
        if createResponse.template != nil {
            // List versions with pagination
            let versionsRequest = Mailgun.Templates.Versions.Request(
                page: .first,
                limit: 1
            )
            
            let versionsResponse = try await client.versions(testTemplateName, versionsRequest)
            
            #expect(versionsResponse.paging.first.contains("limit=1"))
            
            // Clean up
            _ = try? await client.delete(testTemplateName)
        }
    }
}