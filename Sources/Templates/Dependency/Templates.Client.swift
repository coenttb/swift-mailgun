//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Coenttb_Web
import DependenciesMacros

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    @DependencyEndpoint
    public var create: @Sendable (_ request: Templates.Template.Create.Request) async throws -> Templates.Template.Create.Response
    
    @DependencyEndpoint
    public var list: @Sendable (_ page: Page, _ limit: Int, _ p: String) async throws -> Templates.Template.List.Response
    
    @DependencyEndpoint
    public var get: @Sendable (_ templateId: String, _ active: String) async throws -> Templates.Template.Get.Response
    
    @DependencyEndpoint
    public var update: @Sendable (_ templateId: String, _ request: Templates.Template.Update.Request) async throws -> Templates.Template.Update.Response
    
    @DependencyEndpoint
    public var delete: @Sendable (_ templateId: String) async throws -> Templates.Template.Delete.Response
    
    @DependencyEndpoint
    public var versions: @Sendable (_ templateId: String, _ page: Page, _ limit: Int) async throws -> Templates.Template.Versions.Response
    
    @DependencyEndpoint
    public var createVersion: @Sendable (_ templateId: String, _ request: Templates.Version.Create.Request) async throws -> Templates.Version.Create.Response
    
    @DependencyEndpoint
    public var getVersion: @Sendable (_ templateId: String, _ versionId: String) async throws -> Templates.Version.Get.Response
    
    @DependencyEndpoint
    public var updateVersion: @Sendable (_ templateId: String, _ versionId: String, _ request: Templates.Version.Update.Request) async throws -> Templates.Version.Update.Response
    
    @DependencyEndpoint
    public var deleteVersion: @Sendable (_ templateId: String, _ versionId: String) async throws -> Templates.Version.Delete.Response
    
    @DependencyEndpoint
    public var copyVersion: @Sendable (_ templateId: String, _ versionId: String, _ tag: String, _ comment: String?) async throws -> Templates.Version.Copy.Response
}
