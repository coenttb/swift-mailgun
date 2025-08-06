import Foundation
import Mailgun_Lists_Types
import Mailgun_Shared
import Mailgun_Types_Shared
import Testing
import URLMultipartFormCoding
import URLRouting

@Suite("Multipart Debug Tests")
struct MultipartDebugTests {

    @Test("Debug multipart vs regular form encoding")
    func testEncodingComparison() throws {
        let request = Mailgun.Lists.Member.Update.Request(
            name: "Updated Name"
        )

        // Test regular form encoding
        let formEncoder = Form.Encoder.mailgun
        let formData = try formEncoder.encode(request)
        let formString = String(data: formData, encoding: .utf8)!
        print("Regular form encoding: \(formString)")
        #expect(formString == "name=Updated%20Name")

        // Test via router to see actual request body
        let router = Mailgun.Lists.API.Router()
        let api = Mailgun.Lists.API.updateMember(
            listAddress: try .init("test@example.com"),
            memberAddress: try .init("member@example.com"),
            request: request
        )

        let urlRequest = try router.request(for: api)
        let bodyData = urlRequest.httpBody ?? Data()
        let bodyString = String(data: bodyData, encoding: .utf8) ?? ""

        print("Router-generated body:\n\(bodyString)")

        // Check Content-Type header
        let contentType = urlRequest.value(forHTTPHeaderField: "Content-Type") ?? ""
        print("Content-Type: \(contentType)")

        #expect(contentType.contains("multipart/form-data"))
        #expect(bodyString.contains("name"))
        #expect(bodyString.contains("Updated Name"))
    }
}
