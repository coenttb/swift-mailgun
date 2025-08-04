//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 04/08/2025.
//

import Foundation
import Coenttb_Server

extension URLRequest.Handler {
    package enum Mailgun {}
}

extension URLRequest.Handler.Mailgun: DependencyKey {
    package static var liveValue: URLRequest.Handler {
        .init(
            debug: false,
            decoder: JSONDecoder()
        )
    }
}
