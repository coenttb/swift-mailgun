//
//  Debug Test.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//

import Testing
import Foundation
import Dependencies
import DependenciesTestSupport
import Mailgun_Domains
import Mailgun_Shared

@Suite(
    "Debug API Responses",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct DebugAPIResponses {
    @Dependency(\.envVars.mailgunDomain) var domain
    @Dependency(\.envVars.mailgunPrivateApiKey) var apiKey
    @Dependency(\.envVars.mailgunBaseUrl) var baseUrl
    
    @Test("Debug List Domains Response")
    func debugListDomains() async throws {
        var request = URLRequest(url: baseUrl.appendingPathComponent("v3/domains"))
        request.httpMethod = "GET"
        
        let credentials = "\(apiKey.rawValue):"
        let base64Credentials = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let jsonString = String(data: data, encoding: .utf8) ?? "No data"
        
        print("=== LIST DOMAINS RESPONSE ===")
        print(jsonString)
        print("=============================")
        
        // Try to decode it to see what fails
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let items = json["items"] as? [[String: Any]],
           let firstItem = items.first {
            print("\n=== FIRST DOMAIN ITEM ===")
            for (key, value) in firstItem {
                print("\(key): \(value) (type: \(type(of: value)))")
            }
            print("=========================")
        }
    }
    
    @Test("Debug Create Domain Key Response")
    func debugCreateDomainKey() async throws {
        var request = URLRequest(url: baseUrl.appendingPathComponent("v1/domains/\(domain.description)/dkim_keys"))
        request.httpMethod = "POST"
        
        let credentials = "\(apiKey.rawValue):"
        let base64Credentials = Data(credentials.utf8).base64EncodedString()
        request.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let testSelector = "test-debug-\(Int.random(in: 1000...9999))"
        let bodyString = "signing_domain=\(domain.description)&selector=\(testSelector)&bits=2048"
        request.httpBody = bodyString.data(using: .utf8)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let jsonString = String(data: data, encoding: .utf8) ?? "No data"
            
            print("=== CREATE DOMAIN KEY RESPONSE ===")
            print(jsonString)
            print("===================================")
            
            // Try to decode it to see structure
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                print("\n=== RESPONSE STRUCTURE ===")
                for (key, value) in json {
                    print("\(key): \(type(of: value))")
                    if key == "dns_record", let dnsRecord = value as? [String: Any] {
                        print("  DNS Record fields:")
                        for (dnsKey, dnsValue) in dnsRecord {
                            print("    \(dnsKey): \(type(of: dnsValue))")
                        }
                    }
                }
                print("==========================")
            }
        } catch {
            print("Error: \(error)")
        }
    }
}