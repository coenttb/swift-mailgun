//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import Dependencies

public struct Client: Sendable {
    public let bounces: Bounces.Client
    public let complaints: Complaints.Client
    public let unsubscribe: Unsubscribe.Client
    public let whitelist: Whitelist.Client
    
    public init(bounces: Bounces.Client, complaints: Complaints.Client, unsubscribe: Unsubscribe.Client, whitelist: Whitelist.Client) {
        self.bounces = bounces
        self.complaints = complaints
        self.unsubscribe = unsubscribe
        self.whitelist = whitelist
    }
}

extension Suppressions.Client: TestDependencyKey {
    public static let testValue: Suppressions.Client = Suppressions.Client.init(
        bounces: .testValue,
        complaints: .testValue,
        unsubscribe: .testValue,
        whitelist: .testValue
    )
}
