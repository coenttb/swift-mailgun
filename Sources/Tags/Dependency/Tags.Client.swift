//
//  Tags.Client.swift
//  coenttb-mailgun
//
//  Created by Claude on 31/12/2024.
//

import ServerFoundation
import DependenciesMacros

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    @DependencyEndpoint
    public var list: @Sendable (_ request: Tag.List.Request) async throws -> Tag.List.Response
    
    @DependencyEndpoint
    public var get: @Sendable (_ tag: String) async throws -> Tag
    
    @DependencyEndpoint
    public var update: @Sendable (_ tag: String, _ description: String) async throws -> Tag
    
    @DependencyEndpoint
    public var delete: @Sendable (_ tag: String) async throws -> String
    
    @DependencyEndpoint
    public var stats: @Sendable (_ tag: String, _ request: Tag.Stats.Request) async throws -> Tag.Stats.Response
    
    @DependencyEndpoint
    public var aggregates: @Sendable (_ tag: String, _ request: Tag.Aggregates.Request) async throws -> Tag.Aggregates.Response
    
    @DependencyEndpoint
    public var limits: @Sendable () async throws -> Tag.Limits.Response
}

