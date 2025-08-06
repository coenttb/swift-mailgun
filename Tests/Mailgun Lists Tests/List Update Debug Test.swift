import Testing
import Foundation
import Mailgun_Lists_Types
import Mailgun_Types_Shared
import Mailgun_Shared
import URLRouting

@Suite("List Update Debug")
struct ListUpdateDebugTest {
    
    @Test("Debug list update request encoding")
    func testListUpdateEncoding() throws {
        let request = Mailgun.Lists.List.Update.Request(
            description: "Updated description",
            name: "Updated List Name",
            accessLevel: .readonly
        )
        
        // Test form encoding
        let formEncoder = Form.Encoder.mailgun
        let formData = try formEncoder.encode(request)
        let formString = String(data: formData, encoding: .utf8)!
        print("Form encoded: \(formString)")
        
        // Test via router
        let router = Mailgun.Lists.API.Router()
        let api = Mailgun.Lists.API.update(
            listAddress: try .init("test@example.com"),
            request: request
        )
        
        let urlRequest = try router.request(for: api)
        let bodyData = urlRequest.httpBody ?? Data()
        let bodyString = String(data: bodyData, encoding: .utf8) ?? ""
        
        print("URL: \(urlRequest.url?.absoluteString ?? "nil")")
        print("Method: \(urlRequest.httpMethod ?? "nil")")
        print("Content-Type: \(urlRequest.value(forHTTPHeaderField: "Content-Type") ?? "nil")")
        print("Body: \(bodyString)")
        
        #expect(bodyString.contains("description"))
        #expect(bodyString.contains("name"))
        #expect(bodyString.contains("access_level"))
    }
}