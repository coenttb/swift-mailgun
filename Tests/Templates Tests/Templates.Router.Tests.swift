//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 30/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Foundation
import URLRouting
import Templates
import Domain

@Suite("Templates Router Tests")
struct TemplatesRouterTests {
    
    @Test("Creates correct URL for listing templates")
    func testListTemplatesURL() throws {
        @Dependency(Templates.API.Router.self) var router
        
        let url = router.url(
            for: .list(
                domainId: try .init(
                    "test.domain.com"
                ),
                page: .first,
                limit: 100,
                p: ""
            )
        )
        #expect(url.path == "/v3/templates")
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(queryDict["page"] == "first")
        #expect(queryDict["limit"] == "100")
    }
    
    @Test("Creates correct URL for creating template")
    func testCreateTemplateURL() throws {
        @Dependency(Templates.API.Router.self) var router
        
        let request = Templates.Template.Create.Request(
            name: "Test Template",
            description: "Test Description",
            template: "<html>Hello {{name}}</html>",
            engine: "handlebars",
            tag: "v1",
            comment: "Initial version"
        )
        
        let url = router.url(for: .create(request: request))
        #expect(url.path == "/v3/templates")
    }
    
    @Test("Creates correct URL for getting template")
    func testGetTemplateURL() throws {
        @Dependency(Templates.API.Router.self) var router
        
        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        
        let url = router.url(for: .get(domainId: domain, templateId: templateId, active: "active"))
        #expect(url.path == "/v3/test.domain.com/templates/template123")
    }
    
    @Test("Creates correct URL for updating template")
    func testUpdateTemplateURL() throws {
        @Dependency(Templates.API.Router.self) var router
        
        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let request = Templates.Template.Update.Request(
            name: "Updated Template",
            description: "Updated Description"
        )
        
        let url = router.url(for: .update(domainId: domain, templateId: templateId, request: request))
        #expect(url.path == "/v3/test.domain.com/templates/template123")
    }
    
    @Test("Creates correct URL for deleting template")
    func testDeleteTemplateURL() throws {
        @Dependency(Templates.API.Router.self) var router
        
        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        
        let url = router.url(for: .delete(domainId: domain, templateId: templateId))
        #expect(url.path == "/v3/test.domain.com/templates/template123")
    }
    
    @Test("Creates correct URL for listing template versions")
    func testListTemplateVersionsURL() throws {
        @Dependency(Templates.API.Router.self) var router
        
        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        
        let url = router.url(for: .versions(domainId: domain, templateId: templateId, page: .next, limit: 50))
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions")
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(queryDict["page"] == "next")
        #expect(queryDict["limit"] == "50")
    }
    
    @Test("Creates correct URL for creating template version")
    func testCreateTemplateVersionURL() throws {
        @Dependency(Templates.API.Router.self) var router
        
        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let request = Templates.Version.Create.Request(
            template: "<html>Hello {{name}}</html>",
            tag: "v2",
            comment: "Second version",
            engine: "handlebars"
        )
        
        let url = router.url(for: .createVersion(domainId: domain, templateId: templateId, request: request))
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions")
    }
    
    @Test("Creates correct URL for getting template version")
    func testGetTemplateVersionURL() throws {
        @Dependency(Templates.API.Router.self) var router
        
        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let versionId = "version456"
        
        let url = router.url(for: .getVersion(domainId: domain, templateId: templateId, versionId: versionId))
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions/version456")
    }
    
    @Test("Creates correct URL for updating template version")
    func testUpdateTemplateVersionURL() throws {
        @Dependency(Templates.API.Router.self) var router
        
        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let versionId = "version456"
        let request = Templates.Version.Update.Request(
            template: "<html>Updated {{name}}</html>",
            tag: "v2-updated",
            active: true,
            engine: "handlebars",
            comment: "Updated version"
        )
        
        let url = router.url(for: .updateVersion(domainId: domain, templateId: templateId, versionId: versionId, request: request))
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions/version456")
    }
    
    @Test("Creates correct URL for deleting template version")
    func testDeleteTemplateVersionURL() throws {
        @Dependency(Templates.API.Router.self) var router
        
        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let versionId = "version456"
        
        let url = router.url(for: .deleteVersion(domainId: domain, templateId: templateId, versionId: versionId))
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions/version456")
    }
    
    @Test("Creates correct URL for copying template version")
    func testCopyTemplateVersionURL() throws {
        @Dependency(Templates.API.Router.self) var router
        
        let domain = try Domain("test.domain.com")
        let templateId = "template123"
        let versionId = "version456"
        let tag = "v3"
        let comment = "Copied version"
        
        let url = router.url(for: .copyVersion(domainId: domain, templateId: templateId, versionId: versionId, tag: tag, comment: comment))
        #expect(url.path == "/v3/test.domain.com/templates/template123/versions/version456/copy/v3")
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []
        let queryDict = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value) })
        
        #expect(queryDict["comment"] == "Copied version")
    }
}
