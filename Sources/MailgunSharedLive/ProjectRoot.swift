//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 03/08/2025.
//

import Foundation
import ServerFoundation
import Dependencies

extension ProjectRootKey: @retroactive DependencyKey {
    public static var liveValue: URL {
        .init(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}

extension URL {
    package static var mailgunLive: URL {
        .init(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }
}
