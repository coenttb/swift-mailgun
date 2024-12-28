//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import Foundation

public extension URL {
    static let mailgun_eu_baseUrl: Self = URL(string: "https://api.eu.mailgun.net")!
    static let mailgun_usa_baseUrl: Self = URL(string: "https://api.mailgun.net")!
}
