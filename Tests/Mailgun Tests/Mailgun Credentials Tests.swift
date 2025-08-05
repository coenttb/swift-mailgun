import Testing
import Dependencies
import Mailgun
import Mailgun_Credentials
import Mailgun_Credentials_Types
import TypesFoundation

@Suite(
    "Mailgun Credentials Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunCredentialsTests {
    @Dependency(Mailgun.Credentials.Client.self) var client
    @Dependency(\.envVars.mailgunDomain) var domain
    
    @Test("Should successfully list credentials")
    func testListCredentials() async throws {
        let response = try await client.list(domain)
        
        // The response contains an array of credentials
        #expect(response.items != nil)
        #expect(response.totalCount >= 0)
    }
    
    @Test("Should successfully create and delete credential")
    func testCreateAndDeleteCredential() async throws {
        let testLogin = "testuser\(Int.random(in: 1000...9999))"
        let testPassword = "TestPassword123!"
        
        // Create credential
        let createRequest = Mailgun.Credentials.Create.Request(
            login: testLogin,
            password: testPassword
        )
        
        let createResponse = try await client.create(domain, createRequest)
        #expect(createResponse.message.contains("Created"))
        
        // Clean up - delete the credential
        try await client.delete(domain, testLogin)
    }
    
    @Test("Should successfully update credential password")
    func testUpdateCredentialPassword() async throws {
        let testLogin = "testupdateuser\(Int.random(in: 1000...9999))"
        let initialPassword = "InitialPassword123!"
        let newPassword = "NewPassword456!"
        
        // First create a credential
        let createRequest = Mailgun.Credentials.Create.Request(
            login: testLogin,
            password: initialPassword
        )
        
        _ = try await client.create(domain, createRequest)
        
        // Update the password
        let updateRequest = Mailgun.Credentials.Update.Request(
            password: newPassword
        )
        
        let updateResponse = try await client.update(domain, testLogin, updateRequest)
        #expect(updateResponse.message.contains("Updated"))
        
        // Clean up
        try await client.delete(domain, testLogin)
    }
}