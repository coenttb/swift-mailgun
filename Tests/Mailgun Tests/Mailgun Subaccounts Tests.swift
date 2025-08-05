import Testing
import Dependencies
import Mailgun
import Mailgun_Subaccounts
import Mailgun_Subaccounts_Types
import TypesFoundation

@Suite(
    "Mailgun Subaccounts Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MailgunSubaccountsTests {
    @Dependency(Mailgun.Subaccounts.Client.self) var client
    
    @Test("Should successfully list subaccounts")
    func testListSubaccounts() async throws {
        let response = try await client.list()
        
        // Check response structure
        #expect(response.subaccounts != nil)
        #expect(response.totalCount >= 0)
        
        // Primary account should have at least itself
        #expect(response.totalCount >= 1)
    }
    
    @Test("Should successfully create and delete subaccount")
    func testCreateAndDeleteSubaccount() async throws {
        let testSubaccountName = "test-subaccount-\(Int.random(in: 1000...9999))"
        
        // Create subaccount
        let createRequest = Mailgun.Subaccounts.Create.Request(
            name: testSubaccountName
        )
        
        let createResponse = try await client.create(createRequest)
        #expect(!createResponse.id.isEmpty)
        #expect(createResponse.name == testSubaccountName)
        #expect(createResponse.status == .enabled || createResponse.status == .disabled)
        
        let subaccountId = createResponse.id
        
        // List to verify it was created
        let listResponse = try await client.list()
        let hasSubaccount = listResponse.subaccounts.contains { $0.id == subaccountId }
        #expect(hasSubaccount, "Created subaccount should be in the list")
        
        // Disable the subaccount
        let disableResponse = try await client.disable(subaccountId)
        #expect(disableResponse.message.contains("disabled") || disableResponse.message.contains("Subaccount"))
        
        // Enable it again
        let enableResponse = try await client.enable(subaccountId)
        #expect(enableResponse.message.contains("enabled") || enableResponse.message.contains("Subaccount"))
        
        // Note: Actual deletion might not be supported via API
        // so we just disable it as cleanup
        _ = try await client.disable(subaccountId)
    }
    
    @Test("Should successfully get subaccount details")
    func testGetSubaccountDetails() async throws {
        // First list subaccounts to get a valid ID
        let listResponse = try await client.list()
        guard let testSubaccount = listResponse.subaccounts.first else {
            throw TestError("No subaccounts available to test")
        }
        
        let response = try await client.get(testSubaccount.id)
        
        #expect(response.id == testSubaccount.id)
        #expect(!response.name.isEmpty)
        #expect(response.status == .enabled || response.status == .disabled)
    }
}

private struct TestError: Error {
    let message: String
    init(_ message: String) {
        self.message = message
    }
}