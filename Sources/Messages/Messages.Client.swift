//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 19/12/2024.
//

import Coenttb_Web
import DependenciesMacros
import Shared
import Coenttb_Authentication

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    @DependencyEndpoint
    public var send: @Sendable (_ request: Messages.Send.Request) async throws -> Messages.Send.Response
    
    @DependencyEndpoint
    public var sendMime: @Sendable (_ request: Messages.Send.Mime.Request) async throws -> Messages.Send.Response
    
    @DependencyEndpoint
    public var retrieve: @Sendable (_ storageKey: String) async throws -> Messages.StoredMessage
    
    @DependencyEndpoint
    public var queueStatus: @Sendable () async throws -> Messages.Queue.Status
    
    @DependencyEndpoint
    public var deleteAll: @Sendable () async throws -> Messages.Delete.Response
}

public typealias AuthenticatedClient = Shared.AuthenticatedClient<
    API,
    API.Router,
    Client
>
