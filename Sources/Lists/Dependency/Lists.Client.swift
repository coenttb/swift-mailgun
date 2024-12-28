//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import CoenttbWeb
import DependenciesMacros

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    /// Creates a new mailing list
    @DependencyEndpoint
    public var create: @Sendable (_ request: Lists.List.Create.Request) async throws -> Lists.List.Create.Response
    
    /// Gets all mailing lists with optional filtering
    @DependencyEndpoint
    public var list: @Sendable (_ request: Lists.List.Request) async throws -> Lists.List.Response
    
    /// Gets members of a specific mailing list
    @DependencyEndpoint
    public var members: @Sendable (_ listAddress: EmailAddress, _ request: Lists.List.Members.Request) async throws -> Lists.List.Members.Response
    
    /// Adds a new member to a mailing list
    @DependencyEndpoint
    public var addMember: @Sendable (_ listAddress: EmailAddress, _ request: Lists.Member.Add.Request) async throws -> Lists.Member.Add.Response
    
    /// Bulk adds members to a mailing list using JSON
    @DependencyEndpoint
    public var bulkAdd: @Sendable (_ listAddress: EmailAddress, _ members: [Lists.Member.Bulk], _ upsert: Bool?) async throws -> Lists.Member.Bulk.Response
    
    /// Bulk adds members to a mailing list using CSV
    @DependencyEndpoint
    public var bulkAddCSV: @Sendable (_ listAddress: EmailAddress, _ csvData: Data, _ subscribed: Bool?, _ upsert: Bool?) async throws -> Lists.Member.Bulk.Response
    
    /// Gets a specific member from a mailing list
    @DependencyEndpoint
    public var getMember: @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress) async throws -> Lists.Member
    
    /// Updates a specific member in a mailing list
    @DependencyEndpoint
    public var updateMember: @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress, _ request: Lists.Member.Update.Request) async throws -> Lists.Member.Update.Response
    
    /// Deletes a member from a mailing list
    @DependencyEndpoint
    public var deleteMember: @Sendable (_ listAddress: EmailAddress, _ memberAddress: EmailAddress) async throws -> Lists.Member.Delete.Response
    
    /// Updates a mailing list's properties
    @DependencyEndpoint
    public var update: @Sendable (_ listAddress: EmailAddress, _ request: Lists.List.Update.Request) async throws -> Lists.List.Update.Response
    
    /// Deletes a mailing list
    @DependencyEndpoint
    public var delete: @Sendable (_ listAddress: EmailAddress) async throws -> Lists.List.Delete.Response
    
    /// Gets details of a specific mailing list
    @DependencyEndpoint
    public var get: @Sendable (_ listAddress: EmailAddress) async throws -> Lists.List.Get.Response
    
    /// Gets mailing lists with pagination
    @DependencyEndpoint
    public var pages: @Sendable (_ limit: Int?) async throws -> Lists.List.Pages.Response
    
    /// Gets members of a mailing list with pagination
    @DependencyEndpoint
    public var memberPages: @Sendable (_ listAddress: EmailAddress, _ request: Lists.List.Members.Pages.Request) async throws -> Lists.List.Members.Pages.Response
}
