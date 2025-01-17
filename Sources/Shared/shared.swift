//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation
import Parsing
import URLRouting

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe) package static let pages = Path {
        "pages"
    }
}
