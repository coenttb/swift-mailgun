//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 04/08/2025.
//

import Coenttb_Server
import Foundation

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
