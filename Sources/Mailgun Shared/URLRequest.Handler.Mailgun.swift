//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 04/08/2025.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import URLRequestHandler


extension URLRequest.Handler {
    package enum Mailgun {}
}

extension URLRequest.Handler.Mailgun: DependencyKey {
    package static var liveValue: URLRequest.Handler {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        decoder.dateDecodingStrategy = .formatted(formatter)

        return .init(
            debug: false,
            decoder: decoder
        )
    }
}
