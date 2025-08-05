//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/12/2024.
//

import Dependencies
import DependenciesTestSupport
import EnvironmentVariables
import Foundation
@testable import Mailgun_Templates
import Testing

@Suite(
    "Templates Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct TemplatesClientTests {
    @Test("Should successfully create a template")
    func testCreateTemplate() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client

        let request = Mailgun.Templates.Template.Create.Request(
            name: "Test Template",
            description: "A test email template",
            template: "<html><body>Hello {{name}}</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )

        let response = try await client.create(request)

        if response.message != "Duplicate template" {
            #expect(response.template.name == request.name?.lowercased())
            #expect(response.template.description == request.description)
            #expect(response.message.contains("stored"))
        }
    }

    @Test("Should successfully list templates")
    func testListTemplates() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client

        let response = try await client.list(.init())
        #expect(response.items.count <= 10)

        if let firstTemplate = response.items.first {
            #expect(firstTemplate.name != nil)
            #expect(firstTemplate.createdAt != nil)
        }
    }

    @Test("Should successfully get template")
    func testGetTemplate() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client

        // First create a template to ensure we have one to get
        let createRequest = Mailgun.Templates.Template.Create.Request(
            name: "Get Test Template",
            description: "Template for testing get operation",
            template: "<html><body>Test</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )

        let createResponse = try await client.create(createRequest)
        let templateName = createResponse.template.name

        let getResponse = try await client.get(templateName, "yes")
        #expect(getResponse.template.id == createResponse.template.id)
        #expect(getResponse.template.name == createRequest.name?.lowercased())
    }

    @Test("Should successfully update template")
    func testUpdateTemplate() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client

        // First create a template to update
        let createRequest = Mailgun.Templates.Template.Create.Request(
            name: "Update Test Template",
            description: "Template for testing update operation",
            template: "<html><body>Test</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )

        let createResponse = try await client.create(createRequest)
        let templateName = createResponse.template.name

        let updateRequest = Mailgun.Templates.Template.Update.Request(
            name: "Updated Template Name",
            description: "Updated template description"
        )

        let updateResponse = try await client.update(templateName, updateRequest)
//        #expect(updateResponse.template.name == updateRequest.name?.lowercased())
        #expect(updateResponse.message.contains("updated"))
    }

    @Test("Should successfully create and manage template versions")
    func testTemplateVersions() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client

        // Create initial template
        let createRequest = Mailgun.Templates.Template.Create.Request(
            name: "Version Test Template",
            description: "Template for testing versions",
            template: "<html><body>Version 1</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )

        let createResponse = try await client.create(createRequest)
        let templateName = createResponse.template.name

        // Create new version
        let versionRequest = Mailgun.Templates.Version.Create.Request(
            template: "<html><body>Version 2</body></html>",
            tag: "v2",
            comment: "Second version",
            engine: "handlebars"
        )

        let versionResponse = try await client.createVersion(templateName, versionRequest)
        #expect(versionResponse.template.version?.tag == "v2")

        // List versions
        let versionsResponse = try await client.versions(templateName, .first, nil, nil)
        #expect(versionsResponse.template.versions!.count >= 2) // Should have at least v1 and v2

        // Get specific version
        if let versionTag = versionResponse.template.version?.tag {
            let getVersionResponse = try await client.getVersion(templateName, versionTag)
            #expect(getVersionResponse.template.version?.tag == "v2")
        }
    }

    @Test("Should successfully delete template")
    func testDeleteTemplate() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client

        // First create a template to delete
        let createRequest = Mailgun.Templates.Template.Create.Request(
            name: "Delete Test Template",
            description: "Template for testing delete operation",
            template: "<html><body>Test</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )

        let createResponse = try await client.create(createRequest)
        let templateName = createResponse.template.name

        let deleteResponse = try await client.delete(templateName)
        #expect(deleteResponse.message.contains("deleted"))
    }

    @Test("Should successfully copy template version")
    func testCopyTemplateVersion() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client

        // First create a template with initial version
        let createRequest = Mailgun.Templates.Template.Create.Request(
            name: "Copy Test Template",
            description: "Template for testing version copying",
            template: "<html><body>Original</body></html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )

        let createResponse = try await client.create(createRequest)

        let templateName = createResponse.template.name

        // Get the version ID from the created template
        let versionName = createResponse.template.version?.tag

        let copyResponse = try await client.copyVersion(
            templateName.lowercased(),
            versionName!.lowercased(),
            "v2",
            "comment"
        )

        #expect(copyResponse.version?.tag == "v2")
        #expect(copyResponse.message.contains("copied"))

    }

    @Test("Should successfully delete all templates")
    func testDeleteAllTemplates() async throws {
        @Dependency(Mailgun.Templates.Client.self) var client

        let deleteResponse = try await client.deleteAll()
        #expect(deleteResponse.message.contains("deleted"))
    }
}
