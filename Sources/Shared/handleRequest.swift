//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 26/12/2024.
//

import Foundation
import IssueReporting

@Sendable
package func handleRequest<ResponseType: Decodable>(
    for request: URLRequest,
    decodingTo type: ResponseType.Type,
    session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse),
    debug: Bool = true
) async throws -> ResponseType {
    if debug {
        print("\n🌐 Request Details:")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Method: \(request.httpMethod ?? "nil")")
        print("Headers:")
        if let headers = request.allHTTPHeaderFields {
            for (key, value) in headers {
                if key.lowercased() == "authorization" {
                    print("  \(key): *****")
                } else {
                    print("  \(key): \(value)")
                }
            }
        }
        if let body = request.httpBody {
            print("Body: \(String(data: body, encoding: .utf8) ?? "Unable to decode body")")
        }
    }
    
    let (data, response) = try await session(request)
    
    if debug {
        print("\n📥 Response Details:")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers:")
            for (key, value) in httpResponse.allHeaderFields {
                print("  \(key): \(value)")
            }
        }
        print("Body: \(String(data: data, encoding: .utf8) ?? "Unable to decode response body")")
    }
    
    guard let httpResponse = response as? HTTPURLResponse else {
        let error = MailgunError.invalidResponse
        if debug {
            print("\n❌ Error: Invalid Response")
            print("Expected HTTPURLResponse but got: \(String(describing: response))")
        }
        throw error
    }
    
    guard (200...299).contains(httpResponse.statusCode) else {
        let errorMessage: String
        if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            errorMessage = errorResponse.message
        } else {
            errorMessage = String(decoding: data, as: UTF8.self)
        }
        
        let error = MailgunError.httpError(
            statusCode: httpResponse.statusCode,
            message: errorMessage
        )
        
        if debug {
            print("\n❌ HTTP Error:")
            print("Status Code: \(httpResponse.statusCode)")
            print("Error Message: \(errorMessage)")
            print("Raw Response: \(String(data: data, encoding: .utf8) ?? "Unable to decode error response")")
        }
        
        throw error
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return try decoder.decode(type, from: data)
    } catch {
        if debug {
            print("\n❌ Decoding Error:")
            print("Error: \(error)")
            print("Raw Data: \(String(data: data, encoding: .utf8) ?? "Unable to show raw data")")
            
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print("JSON Structure:")
                print(json)
            }
        }
        reportIssue(error)
        throw error
    }
}

struct ErrorResponse: Decodable {
    let message: String
}
