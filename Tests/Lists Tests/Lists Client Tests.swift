import Foundation
import Testing
import EnvironmentVariables
import Dependencies
import DependenciesTestSupport
import Lists
import TestShared
import IssueReporting
import Authenticated

@Suite(
    "Lists Client Tests",
    .dependency(\.envVars, .liveTest),
    .dependency(\.client, .liveTest),
    .serialized
)
struct ListsClientTests {
    @Test("Should successfully create a mailing list")
    func testCreateList() async throws {
        @Dependency(\.client) var client
        @Dependency(\.envVars.mailgunTestMailingList) var list
        
        let request = Lists.List.Create.Request(
            address: list,
            name: "Developers Test List",
            description: "A test mailing list for developers",
            accessLevel: .readonly,
            replyPreference: .list
        )
        
        let response = try await client.create(request)
        
        if response.message != "Duplicate object" {
            #expect(response.list.address == request.address)
            #expect(response.list.name == request.name)
            #expect(response.message.contains("created"))
        }
    }
    
    @Test("Should successfully add member")
    func testAddMember() async throws {
        @Dependency(\.client) var client
        @Dependency(\.envVars.mailgunTestMailingList) var list
        @Dependency(\.envVars.mailgunTestRecipient) var recipient
        
        let addRequest = Lists.Member.Add.Request(
            address: recipient,
            name: "Test Member",
            vars: ["role": "tester"]
        )
        
        let addResponse = try await client.addMember(list, addRequest)
        
        if !addResponse.message.contains("Address already exists") {
            #expect(addResponse.member.address == recipient)
        }
    }
    
    @Test("Should successfully get member")
    func testGetMember() async throws {
        @Dependency(\.client) var client
        @Dependency(\.envVars.mailgunTestMailingList) var list
        @Dependency(\.envVars.mailgunTestRecipient) var recipient
        
        let member = try await client.getMember(list, recipient)
        
        #expect(member.address == recipient)
        #expect(member.name == "Test Member")
    }
    
    @Test(
        "Should successfully update member",
        .bug(id: 1)
    )
    func testUpdateMember() async throws {
        @Dependency(\.client) var client
        @Dependency(\.envVars.mailgunTestMailingList) var list
        @Dependency(\.envVars.mailgunTestRecipient) var recipient
        
        let request: Lists.Member.Update.Request = .init(
            name: "Test Member Updated"
        )
        
        let response = try await client.updateMember(
            list,
            recipient,
            request
        )
        
        #expect(response.member.address == recipient)
        #expect(response.message == "Mailing list member has been updated")
        #expect(response.member.name == "Test Member Updated")
    }
    
    @Test(
        "Should successfully update list",
        .bug(id: 2)
    )
    func testUpdateList() async throws {
        @Dependency(\.client) var client
        @Dependency(\.envVars.mailgunTestMailingList) var list
        
        
        let updateRequest = Lists.List.Update.Request(
            description: "Updated description for the mailing list",
            name: "Updated Test List",
            accessLevel: .readonly
        )
        
        let updateResponse = try await client.update(list, updateRequest)
        #expect(updateResponse.list.name == updateRequest.name)
        #expect(updateResponse.list.description == updateRequest.description)
    }
    
    @Test(
        "Should successfully delete list"
    )
    func testDeleteList() async throws {
        @Dependency(\.client) var client
        @Dependency(\.envVars.mailgunTestMailingList) var list
        
        
        let deleteResponse = try await client.delete(list)
        #expect(deleteResponse.message.contains("removed"))
    }
}

