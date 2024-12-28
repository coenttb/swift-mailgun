//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 28/12/2024.
//

import Foundation
import Parsing
import UrlFormCoding

public enum FormEncodingType {
    case multipart
    case urlEncoded
    
    var contentType: String {
        switch self {
        case .multipart:
            return "multipart/form-data"
        case .urlEncoded:
            return "application/x-www-form-urlencoded"
        }
    }
}

public struct MultipartFormCodingMailgun<Value: Codable>: Conversion {
    public let decoder: UrlFormDecoder
    private let boundary: String
    private let encodingType: FormEncodingType
    
    public init(
        _ type: Value.Type,
        encodingType: FormEncodingType = .multipart,
        decoder: UrlFormDecoder = .init()
    ) {
        self.decoder = decoder
        self.boundary = "Boundary-\(UUID().uuidString)"
        self.encodingType = encodingType
    }
    
    public func apply(_ input: Data) throws -> Value {
        do {
            return try decoder.decode(Value.self, from: input)
        } catch {
            throw MultipartFormCodingError.decodingFailed(error)
        }
    }
    
    public func unapply(_ output: Value) -> Data {
        switch encodingType {
        case .urlEncoded:
            return encodeUrlForm(output)
        case .multipart:
            return encodeMultipartForm(output)
        }
    }
    
    private func encodeUrlForm(_ output: Value) -> Data {
        // Handle special case for raw data
        if output is Data {
            return output as? Data ?? Data()
        }
        
        // Convert to dictionary for encoding
        guard let jsonData = try? JSONEncoder().encode(output),
              let dict = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            return Data()
        }
        
        let pairs = dict.compactMap { key, value -> String? in
            // Handle special case for address/domain parameter
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? key
            let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "\(value)"
            return "\(encodedKey)=\(encodedValue)"
        }
        
        return pairs.joined(separator: "&").data(using: .utf8) ?? Data()
    }
    
    private func encodeMultipartForm(_ output: Value) -> Data {
        let body = NSMutableData()
        
        // Function to append string data
        let appendString = { (string: String) in
            if let data = string.data(using: .utf8) {
                body.append(data)
            }
        }
        
        // Handle file upload case
        if let fileData = output as? Data {
            appendString("--\(boundary)\r\n")
            appendString("Content-Disposition: form-data; name=\"file\"; filename=\"list.csv\"\r\n")
            appendString("Content-Type: text/csv\r\n\r\n")
            body.append(fileData)
            appendString("\r\n--\(boundary)--\r\n")
            return body as Data
        }
        
        // Handle regular form data
        guard let jsonData = try? JSONEncoder().encode(output),
              let dict = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            return Data()
        }
        
        for (key, value) in dict {
            appendString("--\(boundary)\r\n")
            
            switch value {
            case is String, is Int, is Double, is Bool:
                appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                appendString("\(value)\r\n")
                
            case let array as [Any]:
                appendString("Content-Disposition: form-data; name=\"\(key)[]\"\r\n\r\n")
                appendString("\(array.map { "\($0)" }.joined(separator: ","))\r\n")
                
            case let data as Data:
                appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).dat\"\r\n")
                appendString("Content-Type: application/octet-stream\r\n\r\n")
                body.append(data)
                appendString("\r\n")
                
            default:
                continue
            }
        }
        
        appendString("--\(boundary)--\r\n")
        return body as Data
    }
    
    public var contentTypeHeader: String {
        switch encodingType {
        case .multipart:
            return "\(encodingType.contentType); boundary=\(boundary)"
        case .urlEncoded:
            return encodingType.contentType
        }
    }
}

// MARK: - Custom Error Handling
public enum MultipartFormCodingError: Error {
    case decodingFailed(Error)
}

// Specific Mailgun helpers
extension Conversion {
    @inlinable
    public static func multipartMailgun<Value>(
        _ type: Value.Type,
        encodingType: FormEncodingType = .multipart,
        decoder: UrlFormDecoder = .init()
    ) -> Self where Self == MultipartFormCodingMailgun<Value> {
        .init(type, encodingType: encodingType, decoder: decoder)
    }
    
//    @inlinable
//    public static func mailgunWhitelist<T>(_ type: T.Type) -> Self where Self == MultipartFormCodingMailgun<T> {
//        .init(type, encodingType: .urlEncoded)
//    }
//    
//    @inlinable
//    public static func mailgunImport(_ type: Data.Type) -> Self where Self == MultipartFormCodingMailgun<Data> {
//        .init(type, encodingType: .multipart)
//    }
}
