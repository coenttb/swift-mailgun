//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Coenttb_Web
import DependenciesMacros

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    @DependencyEndpoint
    public var create: @Sendable (_ request: Lists.List.Create.Request) async throws -> Lists.List.Create.Response
    
    @DependencyEndpoint
    public var list: @Sendable (_ request: Lists.List.Request) async throws -> Lists.List.Response
    
    @DependencyEndpoint
    public var members: @Sendable (_ listAddress: EmailAddress, _ request: Lists.List.Members.Request) async throws -> Lists.List.Members.Response
    
    @DependencyEndpoint
    public var addMember: @Sendable (_ listAddress: EmailAddress, _ request: Lists.Member.Add.Request) async throws -> Lists.Member.Add.Response
    
    @DependencyEndpoint
    public var bulkAdd: @Sendable (_ listAddress: EmailAddress, _ members: [Lists.Member.Bulk], _ upsert: Bool?) async throws -> Lists.Member.Bulk.Response
    
    @DependencyEndpoint
    public var bulkAddCSV: @Sendable (_ listAddress: EmailAddress, _ csvData: Data, _ subscribed: Bool?, _ upsert: Bool?) async throws -> Lists.Member.Bulk.Response
    
    @DependencyEndpoint
    public var getMember: @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress) async throws -> Lists.Member
    
    @DependencyEndpoint
    public var updateMember: @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress, _ request: Lists.Member.Update.Request) async throws -> Lists.Member.Update.Response
    
    @DependencyEndpoint
    public var deleteMember: @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress) async throws -> Lists.Member.Delete.Response
    
    @DependencyEndpoint
    public var update: @Sendable (_ listAddress: EmailAddress, _ request: Lists.List.Update.Request) async throws -> Lists.List.Update.Response
    
    @DependencyEndpoint
    public var delete: @Sendable (_ listAddress: EmailAddress) async throws -> Lists.List.Delete.Response
    
    @DependencyEndpoint
    public var get: @Sendable (_ listAddress: EmailAddress) async throws -> Lists.List.Get.Response
    
    @DependencyEndpoint
    public var pages: @Sendable (_ limit: Int?) async throws -> Lists.List.Pages.Response
    
    @DependencyEndpoint
    public var memberPages: @Sendable (_ listAddress: EmailAddress, _ request: Lists.List.Members.Pages.Request) async throws -> Lists.List.Members.Pages.Response
}
