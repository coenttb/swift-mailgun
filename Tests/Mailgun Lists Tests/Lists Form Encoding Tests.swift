import Foundation
import Mailgun_Lists_Types
import Mailgun_Shared
import Mailgun_Types_Shared
import Testing
import URLRouting

@Suite("Lists Form Encoding Tests")
struct ListsFormEncodingTests {

    @Test("Should correctly encode member update request")
    func testMemberUpdateEncoding() throws {
        let request = Mailgun.Lists.Member.Update.Request(
            name: "Test Member Updated"
        )

        let encoder = Form.Encoder.mailgun
        let data = try encoder.encode(request)
        let encodedString = String(data: data, encoding: .utf8)!

        print("Encoded form data: \(encodedString)")

        // Check that name is encoded
        #expect(encodedString.contains("name=Test%20Member%20Updated") || encodedString.contains("name=Test+Member+Updated"))

        // Check that nil fields are not included
        #expect(!encodedString.contains("address="))
        #expect(!encodedString.contains("vars="))
        #expect(!encodedString.contains("subscribed="))
    }

    @Test("Should correctly generate update member request")
    func testMemberUpdateRequest() throws {
        let router = Mailgun.Lists.API.Router()
        let request = Mailgun.Lists.Member.Update.Request(
            name: "Test Member Updated"
        )

        let api = Mailgun.Lists.API.updateMember(
            listAddress: try .init("test@example.com"),
            memberAddress: try .init("member@example.com"),
            request: request
        )

        let urlRequest = try router.request(for: api)

        #expect(urlRequest.url?.absoluteString == "/v3/lists/test@example.com/members/member@example.com")
        #expect(urlRequest.httpMethod == "PUT")
        #expect(urlRequest.httpBody != nil)

        let bodyString = String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? ""
        print("Request body: \(bodyString)")

        #expect(bodyString.contains("name"))
    }

    @Test("Should correctly encode list update request")
    func testListUpdateEncoding() throws {
        let request = Mailgun.Lists.List.Update.Request(
            description: "Updated description",
            name: "Updated List Name",
            accessLevel: .readonly
        )

        let encoder = Form.Encoder.mailgun
        let data = try encoder.encode(request)
        let encodedString = String(data: data, encoding: .utf8)!

        print("Encoded list update form data: \(encodedString)")

        // Check that fields are encoded
        #expect(encodedString.contains("description="))
        #expect(encodedString.contains("name="))
        #expect(encodedString.contains("access_level=readonly"))

        // Check that nil fields are not included
        #expect(!encodedString.contains("address="))
        #expect(!encodedString.contains("reply_preference="))
    }

    @Test("Should correctly generate update list request")
    func testListUpdateRequest() throws {
        let router = Mailgun.Lists.API.Router()
        let request = Mailgun.Lists.List.Update.Request(
            description: "Updated description",
            name: "Updated List Name",
            accessLevel: .readonly
        )

        let api = Mailgun.Lists.API.update(
            listAddress: try .init("test@example.com"),
            request: request
        )

        let urlRequest = try router.request(for: api)

        #expect(urlRequest.url?.absoluteString == "/v3/lists/test@example.com")
        #expect(urlRequest.httpMethod == "PUT")
        #expect(urlRequest.httpBody != nil)

        let bodyString = String(data: urlRequest.httpBody ?? Data(), encoding: .utf8) ?? ""
        print("List update request body: \(bodyString)")

        #expect(bodyString.contains("name"))
        #expect(bodyString.contains("description"))
        #expect(bodyString.contains("access_level"))
    }
}
