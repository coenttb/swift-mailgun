//
//  File.swift
//  coenttb-mailgun
//
//  Created by coenttb on 26/12/2024.
//

import Coenttb_Web
import DependenciesMacros

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    @DependencyEndpoint
    public var list: @Sendable (_ query: Events.List.Query?) async throws -> Events.List.Response
}
