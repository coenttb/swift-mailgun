//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import Dependencies

public struct Client: Sendable {
    public let metrics: Metrics.Client
    public let stats: Stats.Client
    
    public init(
        metrics: Metrics.Client,
        stats: Stats.Client
    ) {
        self.metrics = metrics
        self.stats = stats
    }
}

extension Client: TestDependencyKey {
    public static let testValue: Client = Client.init(metrics: .testValue, stats: .testValue)
}
