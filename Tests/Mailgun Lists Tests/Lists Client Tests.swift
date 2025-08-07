import Dependencies
import DependenciesTestSupport
import Mailgun_Lists
import Testing

@Suite(
    "Lists Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct ListsClientTests {
    @Test("Should successfully create a mailing list")
    func testCreateList() async throws {
        @Dependency(Mailgun.Lists.self) var lists
        @Dependency(\.envVars.mailgunTestMailingList) var list

        let request = Mailgun.Lists.List.Create.Request(
            address: list,
            name: "Developers Test List",
            description: "A test mailing list for developers",
            accessLevel: .readonly,
            replyPreference: .list
        )

        let response = try await lists.client.create(request)

        if response.message != "Duplicate object" {
            #expect(response.list.address == request.address)
            #expect(response.list.name == request.name)
            #expect(response.message.contains("created"))
        }
    }

    @Test("Should successfully add member")
    func testAddMember() async throws {
        @Dependency(Mailgun.Lists.self) var lists
        @Dependency(\.envVars.mailgunTestMailingList) var list
        @Dependency(\.envVars.mailgunTestRecipient) var recipient

        let addRequest = Mailgun.Lists.Member.Add.Request(
            address: recipient,
            name: "Test Member",
            vars: ["role": "tester"]
        )

        let addResponse = try await lists.client.addMember(list, addRequest)

        if !addResponse.message.contains("Address already exists") {
            #expect(addResponse.member.address == recipient)
        }
    }

    @Test("Should successfully get member")
    func testGetMember() async throws {
        @Dependency(Mailgun.Lists.self) var lists
        @Dependency(\.envVars.mailgunTestMailingList) var list
        @Dependency(\.envVars.mailgunTestRecipient) var recipient

        let member = try await lists.client.getMember(list, recipient)

        #expect(member.address == recipient)
        #expect(member.name == "Test Member")
    }

    @Test(
        "Should successfully update member",
        .bug(id: 1)
    )
    func testUpdateMember() async throws {
        @Dependency(Mailgun.Lists.self) var lists
        @Dependency(\.envVars.mailgunTestMailingList) var list
        @Dependency(\.envVars.mailgunTestRecipient) var recipient

        // First, ensure the member exists with a known name
        let addRequest = Mailgun.Lists.Member.Add.Request(
            address: recipient,
            name: "Original Test Name",
            upsert: true
        )
        _ = try? await lists.client.addMember(list, addRequest)

        // Now update the member
        let request: Mailgun.Lists.Member.Update.Request = .init(
            name: "Test Member Updated"
        )

        let response = try await lists.client.updateMember(
            list,
            recipient,
            request
        )

        #expect(response.member.address == recipient)
        #expect(response.message == "Mailing list member has been updated")
        #expect(response.member.name == "Test Member Updated")
    }

    @Test(
        "Should successfully update list"
    )
    func testUpdateList() async throws {
        @Dependency(Mailgun.Lists.self) var lists
        @Dependency(\.envVars.mailgunTestMailingList) var list

        // First, ensure the list exists
        let createRequest = Mailgun.Lists.List.Create.Request(
            address: list,
            name: "Original List Name",
            description: "Original description",
            accessLevel: .readonly
        )
        _ = try? await lists.client.create(createRequest)

        let updateRequest = Mailgun.Lists.List.Update.Request(
            description: "Updated description for the mailing list",
            name: "Updated Test List",
            accessLevel: .readonly,
            replyPreference: .list
        )

        let updateResponse = try await lists.client.update(list, updateRequest)
        #expect(updateResponse.list.name == updateRequest.name)
        #expect(updateResponse.list.description == updateRequest.description)
    }

    @Test(
        "Should successfully delete list"
    )
    func testDeleteList() async throws {
        @Dependency(Mailgun.Lists.self) var lists
        @Dependency(\.envVars.mailgunTestMailingList) var list

        let deleteResponse = try await lists.client.delete(list)
        #expect(deleteResponse.message.contains("removed"))
    }
}
