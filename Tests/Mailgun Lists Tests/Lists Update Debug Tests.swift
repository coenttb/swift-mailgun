import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun_Lists
import Testing

@Suite(
    "Lists Update Debug Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct ListsUpdateDebugTests {

    @Test("Debug member update issue")
    func testMemberUpdateDebug() async throws {
        @Dependency(Mailgun.Lists.self) var lists
        @Dependency(\.envVars.mailgunTestMailingList) var list

        // Ensure the test list exists
        let createListRequest = Mailgun.Lists.List.Create.Request(
            address: list,
            name: "Test List for Debugging",
            description: "Test list for debugging member updates",
            accessLevel: .readonly
        )
        _ = try? await lists.client.create(createListRequest)

        // Use a unique email for this test
        let uniqueEmail = try EmailAddress("debug_\(UUID().uuidString.prefix(8))@example.com")

        // Add member with initial name
        let addRequest = Mailgun.Lists.Member.Add.Request(
            address: uniqueEmail,
            name: "Initial Name"
        )

        let addResponse = try await lists.client.addMember(list, addRequest)
        print("Added member: \(addResponse.member.name ?? "nil")")
        #expect(addResponse.member.name == "Initial Name")

        // Update the member
        let updateRequest = Mailgun.Lists.Member.Update.Request(
            name: "Updated Name"
        )

        let updateResponse = try await lists.client.updateMember(list, uniqueEmail, updateRequest)
        print("Update response message: \(updateResponse.message)")
        print("Updated member name: \(updateResponse.member.name ?? "nil")")

        // The expectation
        #expect(updateResponse.member.name == "Updated Name")

        // Clean up
        _ = try? await lists.client.deleteMember(list, uniqueEmail)
    }

    @Test("Debug list update issue")
    func testListUpdateDebug() async throws {
        @Dependency(Mailgun.Lists.self) var lists

        // Create a unique list for this test
        let uniqueList = try EmailAddress("debug_\(UUID().uuidString.prefix(8))@sandbox5f32d4b6aad14a6d9cb17d67f85e44e9.mailgun.org")

        // Create list with initial values
        let createRequest = Mailgun.Lists.List.Create.Request(
            address: uniqueList,
            name: "Initial List Name",
            description: "Initial description",
            accessLevel: .readonly
        )

        let createResponse = try await lists.client.create(createRequest)
        print("Created list: \(createResponse.list.name ?? "nil")")
        #expect(createResponse.list.name == "Initial List Name")

        // Update the list
        let updateRequest = Mailgun.Lists.List.Update.Request(
            description: "Updated description",
            name: "Updated List Name"
        )

        do {
            let updateResponse = try await lists.client.update(uniqueList, updateRequest)
            print("Update response message: \(updateResponse.message)")
            print("Updated list name: \(updateResponse.list.name ?? "nil")")
            #expect(updateResponse.list.name == "Updated List Name")
        } catch {
            print("Update error: \(error)")
            throw error
        }

        // Clean up
        _ = try? await lists.client.delete(uniqueList)
    }
}
