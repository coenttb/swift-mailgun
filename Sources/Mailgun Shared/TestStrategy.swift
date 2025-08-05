//
//  File.swift
//  coenttb-web
//
//  Created by Coen ten Thije Boonkkamp on 10/01/2025.
//

import Dependencies
import Foundation

package enum TestStrategy: Codable, Hashable, Sendable {
    case local
    case liveTest
    case live
}

extension TestStrategy: TestDependencyKey {
    package static let testValue: TestStrategy = .local
}

extension DependencyValues {
    package var testStrategy: TestStrategy {
        get { self[TestStrategy.self] }
        set { self[TestStrategy.self] = newValue }
    }
}
