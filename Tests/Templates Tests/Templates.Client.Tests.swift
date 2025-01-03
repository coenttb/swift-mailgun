//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/12/2024.
//

import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import Templates
import TestShared
import IssueReporting
import Authenticated

@Suite(
    "Templates Client Tests",
    .dependency(\.envVars, .liveTest),
    .dependency(AuthenticatedClient.testValue),
    .serialized
)
struct TemplatesClientTests {
    @Test("Should successfully create a template")
    func testCreateTemplate() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        let request = Templates.Template.Create.Request(
            name: "Test Template",
            description: "A test email template",
            template: "<html><body>Hello {{name}}</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )
        
        let response = try await client.create(request)
        
        if response.message != "Duplicate template" {
            #expect(response.template.name == request.name)
            #expect(response.template.description == request.description)
            #expect(response.message.contains("stored"))
        }
    }
    
    @Test("Should successfully list templates")
    func testListTemplates() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        let response = try await client.list(.init(p: ""))
        #expect(response.items.count <= 10)
        
        if let firstTemplate = response.items.first {
            #expect(firstTemplate.name != nil)
            #expect(firstTemplate.createdAt != nil)
        }
    }
    
    @Test("Should successfully get template")
    func testGetTemplate() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        // First create a template to ensure we have one to get
        let createRequest = Templates.Template.Create.Request(
            name: "Get Test Template",
            description: "Template for testing get operation",
            template: "<html><body>Test</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )
        
        let createResponse = try await client.create(createRequest)
        let templateId = createResponse.template.id
        
        let getResponse = try await client.get(templateId, "active")
        #expect(getResponse.template.id == templateId)
        #expect(getResponse.template.name == createRequest.name)
    }
    
    @Test("Should successfully update template")
    func testUpdateTemplate() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        // First create a template to update
        let createRequest = Templates.Template.Create.Request(
            name: "Update Test Template",
            description: "Template for testing update operation",
            template: "<html><body>Test</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )
        
        let createResponse = try await client.create(createRequest)
        let templateId = createResponse.template.id
        
        let updateRequest = Templates.Template.Update.Request(
            name: "Updated Template Name",
            description: "Updated template description"
        )
        
        let updateResponse = try await client.update(templateId, updateRequest)
        #expect(updateResponse.template.name == updateRequest.name)
        #expect(updateResponse.template.description == updateRequest.description)
        #expect(updateResponse.message.contains("updated"))
    }
    
    @Test("Should successfully create and manage template versions")
    func testTemplateVersions() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        // Create initial template
        let createRequest = Templates.Template.Create.Request(
            name: "Version Test Template",
            description: "Template for testing versions",
            template: "<html><body>Version 1</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )
        
        let createResponse = try await client.create(createRequest)
        let templateId = createResponse.template.id
        
        // Create new version
        let versionRequest = Templates.Version.Create.Request(
            template: "<html><body>Version 2</body></html>",
            tag: "v2",
            comment: "Second version",
            engine: "handlebars"
        )
        
        let versionResponse = try await client.createVersion(templateId, versionRequest)
        #expect(versionResponse.template.version?.tag == "v2")
        
        // List versions
        let versionsResponse = try await client.versions(templateId, .init())
        #expect(versionsResponse.items.count >= 2) // Should have at least v1 and v2
        
        // Get specific version
        if let versionId = versionResponse.template.version?.id {
            let getVersionResponse = try await client.getVersion(templateId, versionId)
            #expect(getVersionResponse.template.version?.id == versionId)
            #expect(getVersionResponse.template.version?.tag == "v2")
        }
    }
    
    @Test("Should successfully delete template")
    func testDeleteTemplate() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        // First create a template to delete
        let createRequest = Templates.Template.Create.Request(
            name: "Delete Test Template",
            description: "Template for testing delete operation",
            template: "<html><body>Test</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )
        
        let createResponse = try await client.create(createRequest)
        let templateId = createResponse.template.id
        
        let deleteResponse = try await client.delete(templateId)
        #expect(deleteResponse.message.contains("deleted"))
    }
    
    @Test("Should successfully copy template version")
    func testCopyTemplateVersion() async throws {
        @Dependency(AuthenticatedClient.self) var client
        
        // First create a template with initial version
        let createRequest = Templates.Template.Create.Request(
            name: "Copy Test Template",
            description: "Template for testing version copying",
            template: "<html><body>Original</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )
        
        let createResponse = try await client.create(createRequest)
        let templateId = createResponse.template.id
        
        // Get the version ID from the created template
        if let versionId = createResponse.template.version?.id {
            let copyResponse = try await client.copyVersion(
                templateId,
                versionId,
                "v1-copy",
                "Copied from v1"
            )
            
            #expect(copyResponse.template.version?.tag == "v1-copy")
            #expect(copyResponse.message.contains("copied"))
        }
    }
}
