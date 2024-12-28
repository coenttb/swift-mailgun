//
//  File.swift
//  coenttb-mailgun
//
//  Created by coenttb on 26/12/2024.
//

import CoenttbWeb
import DependenciesMacros

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@DependencyClient
public struct Client: Sendable {
    /// Lists events for a domain with optional filtering
    ///
    /// Mailgun keeps track of every inbound and outbound message event and stores this data for at least 3 days.
    /// You can filter events by various parameters including date range, recipients, and event types.
    @DependencyEndpoint
    public var list: @Sendable (_ query: Events.List.Query?) async throws -> Events.List.Response
}
