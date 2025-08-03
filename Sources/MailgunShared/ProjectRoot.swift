//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 03/08/2025.
//

import Dependencies
import Foundation
import ServerFoundation

extension ProjectRootKey: @retroactive DependencyKey {
    public static var liveValue: URL {
        .init(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}

extension URL {
    package static var mailgun: URL {
        .init(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}
