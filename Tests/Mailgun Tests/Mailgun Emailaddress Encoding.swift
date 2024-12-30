//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 22/12/2024.
//

import Testing
import EmailAddress
import Coenttb_Web
@testable import Messages

@Suite("Mailgun Form Encoding Tests")
struct MailgunFormEncodingTests {
    
    @Test("Send Request encodes EmailAddress correctly in form data")
    func testSendRequestFormEncoding() throws {
        let request = Messages.Send.Request(
            from: try EmailAddress("John Doe <test@example.com>"),
            to: [try .init("recipient@example.com")],
            subject: "Test Subject"
        )
        
        let formEncoded = urlFormEncode(value: request)
        
        let components = formEncoded.split(separator: "&")
        
        let fromField = components.first { $0.hasPrefix("from=") }
    
        let decodedFrom = try #require(fromField?.dropFirst("from=".count))
            .removingPercentEncoding
        
        #expect(decodedFrom == "John Doe <test@example.com>")
        
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        
        let decoded = try decoder.decode(
            Messages.Send.Request.self,
            from: Data(formEncoded.utf8)
        )
        
        #expect(decoded.from.description == "John Doe <test@example.com>")
        #expect(try decoded.to == [.init("recipient@example.com")])
        #expect(decoded.subject == "Test Subject")
    }
    
    @Test("Send Request handles EmailAddress without display name")
    func testSendRequestFormEncodingWithoutDisplayName() throws {
        let request = Messages.Send.Request(
            from: try EmailAddress("test@example.com"),
            to: [try .init("recipient@example.com")],
            subject: "Test Subject"
        )
        
        let formEncoded = urlFormEncode(value: request)
        let components = formEncoded.split(separator: "&")
        let fromField = components.first { $0.hasPrefix("from=") }
        let decodedFrom = try #require(fromField?.dropFirst("from=".count))
            .removingPercentEncoding
        
        #expect(decodedFrom == "test@example.com")
        
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        
        let decoded = try decoder.decode(
            Messages.Send.Request.self,
            from: Data(formEncoded.utf8)
        )
        
        #expect(decoded.from.description == "test@example.com")
    }
    
    @Test("Send Request handles quoted display names")
    func testSendRequestFormEncodingWithQuotedDisplayName() throws {
        let request = Messages.Send.Request(
            from: try EmailAddress("\"Doe, John\" <test@example.com>"),
            to: [try .init("recipient@example.com")],
            subject: "Test Subject"
        )
        
        let formEncoded = urlFormEncode(value: request)
        let components = formEncoded.split(separator: "&")
        let fromField = components.first { $0.hasPrefix("from=") }
        let decodedFrom = try #require(fromField?.dropFirst("from=".count))
            .removingPercentEncoding
        
        #expect(decodedFrom == "\"Doe, John\" <test@example.com>")
        
        let decoder = UrlFormDecoder()
        decoder.parsingStrategy = .bracketsWithIndices
        
        let decoded = try decoder.decode(
            Messages.Send.Request.self,
            from: Data(formEncoded.utf8)
        )
        
        #expect(decoded.from.name == "Doe, John")
        #expect(decoded.from.description == "\"Doe, John\" <test@example.com>")
    }
}
