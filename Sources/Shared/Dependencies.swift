////
////  File.swift
////  coenttb-mailgun
////
////  Created by Coen ten Thije Boonkkamp on 23/01/2025.
////
//
//import Foundation
//import Coenttb_Web
//
//
//extension DependencyValues {
//    public struct Mailgun: Equatable, Sendable {
//        public let baseUrl: URL
//    }
//}
//
//extension DependencyValues.Mailgun: DependencyKey {
//    public static let testValue: DependencyValues.Mailgun = .init(baseUrl: URL(string: "https://api.mailgun.com")!)
//    public static let liveValue: DependencyValues.Mailgun = .init(baseUrl: URL(string: "https://api.mailgun.com")!)
//}
