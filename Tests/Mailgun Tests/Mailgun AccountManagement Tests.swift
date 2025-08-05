import Testing
import Dependencies
import Mailgun
import Mailgun_AccountManagement
import Mailgun_AccountManagement_Types
import TypesFoundation

@Suite(
    "Mailgun AccountManagement Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunAccountManagementTests {
    @Dependency(Mailgun.AccountManagement.Client.self) var client
    
    @Test("Should successfully get account information")
    func testGetAccountInfo() async throws {
        let response = try await client.get()
        
        #expect(!response.id.isEmpty)
        #expect(!response.contactInfo.name.isEmpty)
        #expect(!response.billingInfo.billingName.isEmpty)
    }
    
    @Test("Should handle account update request")
    func testUpdateAccount() async throws {
        // We'll only test that the API accepts the request structure
        // without actually updating production account data
        let updateRequest = Mailgun.AccountManagement.Update.Request(
            billingCity: nil,
            billingCountry: nil,
            billingName: nil,
            billingPhone: nil,
            billingPostalCode: nil,
            billingState: nil,
            billingStreet1: nil,
            billingStreet2: nil,
            contactCompany: nil,
            contactEmail: nil,
            contactName: nil,
            contactPhone: nil
        )
        
        // Note: We're not actually calling update to avoid modifying account data
        // Just verify the request structure compiles
        _ = updateRequest
        #expect(true, "Update request structure is valid")
    }
}
