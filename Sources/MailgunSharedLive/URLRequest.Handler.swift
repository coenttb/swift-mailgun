//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 03/08/2025.
//

import Foundation
import Coenttb_Server

extension URLRequest.Handler: @retroactive DependencyKey {
    public static var liveValue: Self {
        .init(
            debug: false,
            decoder: JSONDecoder()
        )
    }
}
