import Dependencies
import DependenciesTestSupport
import Foundation
import Mailgun
import Mailgun_AccountManagement
import Mailgun_Messages
import Testing

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Messages Integration Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MessagesIntegrationTests {

    // Helper to get authorized sandbox recipients
    func getAuthorizedRecipients() async throws -> [EmailAddress] {
        @Dependency(\.mailgun) var mailgun

        let response = try await mailgun.client.accountManagement.getSandboxAuthRecipients()

        // Filter only activated recipients and convert to EmailAddress
        let recipients = response.recipients
            .filter { $0.activated }
            .map(\.email)

        // Ensure we have at least one recipient
        guard !recipients.isEmpty else {
            throw TestError.noAuthorizedRecipients
        }

        return recipients
    }

    enum TestError: Swift.Error {
        case noAuthorizedRecipients
        case insufficientRecipients(needed: Int, available: Int)
    }

    @Test("Send to multiple authorized recipients")
    func testSendToMultipleAuthorizedRecipients() async throws {
        @Dependency(\.mailgun) var mailgun
        @Dependency(\.envVars.mailgunFrom) var from

        // Get all authorized recipients
        let authorizedRecipients = try await getAuthorizedRecipients()

        // Use at least 2 recipients if available
        let recipientsToUse = Array(authorizedRecipients.prefix(3))

        guard recipientsToUse.count >= 2 else {
            throw TestError.insufficientRecipients(needed: 2, available: recipientsToUse.count)
        }

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: recipientsToUse,
            subject: "Test Email to Multiple Authorized Recipients",
            html: """
                <h2>Multiple Recipients Test</h2>
                <p>This email is being sent to \(recipientsToUse.count) authorized recipients:</p>
                <ul>
                \(recipientsToUse.map { "<li>\($0.rawValue)</li>" }.joined())
                </ul>
                """,
            text: "This email is being sent to \(recipientsToUse.count) authorized recipients: \(recipientsToUse.map { $0.rawValue }.joined(separator: ", "))",
            testMode: true
        )

        let response = try await mailgun.client.messages.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send batch email with recipient variables using authorized recipients")
    func testBatchEmailWithAuthorizedRecipients() async throws {
        @Dependency(\.mailgun) var mailgun
        @Dependency(\.envVars.mailgunFrom) var from

        // Get authorized recipients
        let authorizedRecipients = try await getAuthorizedRecipients()

        // Create recipient variables for each authorized recipient
        var recipientVarsDict: [String: [String: Any]] = [:]
        for (index, recipient) in authorizedRecipients.enumerated() {
            recipientVarsDict[recipient.rawValue] = [
                "name": "User \(index + 1)",
                "id": index + 1,
                "email": recipient.rawValue
            ]
        }

        // Convert to JSON string
        let recipientVariables = try String(
            data: JSONSerialization.data(withJSONObject: recipientVarsDict),
            encoding: .utf8
        )!

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: authorizedRecipients,
            subject: "Personalized Email for %recipient.name%",
            html: """
                <h2>Hello %recipient.name%!</h2>
                <p>This is a personalized email for you.</p>
                <p>Your user ID is: <strong>%recipient.id%</strong></p>
                <p>Your email is: <strong>%recipient.email%</strong></p>
                """,
            text: "Hello %recipient.name%! Your user ID is %recipient.id% and your email is %recipient.email%.",
            testMode: true,
            recipientVariables: recipientVariables
        )

        let response = try await mailgun.client.messages.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send with CC and BCC using authorized recipients")
    func testSendWithCcBccAuthorized() async throws {
        @Dependency(\.mailgun) var mailgun
        @Dependency(\.envVars.mailgunFrom) var from

        // Get authorized recipients
        let authorizedRecipients = try await getAuthorizedRecipients()

        guard authorizedRecipients.count >= 3 else {
            throw TestError.insufficientRecipients(needed: 3, available: authorizedRecipients.count)
        }

        // Assign roles to recipients
        let toRecipient = authorizedRecipients[0]
        let ccRecipient = authorizedRecipients[1]
        let bccRecipient = authorizedRecipients[2]

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [toRecipient],
            subject: "Email with CC and BCC (Authorized Recipients)",
            html: """
                <h2>CC and BCC Test</h2>
                <p>This email demonstrates CC and BCC functionality with authorized recipients:</p>
                <ul>
                    <li>TO: \(toRecipient.rawValue)</li>
                    <li>CC: \(ccRecipient.rawValue)</li>
                    <li>BCC: \(bccRecipient.rawValue) (hidden from other recipients)</li>
                </ul>
                """,
            text: "Email with TO: \(toRecipient.rawValue), CC: \(ccRecipient.rawValue), BCC: \(bccRecipient.rawValue)",
            cc: [ccRecipient],
            bcc: [bccRecipient],
            testMode: true
        )

        let response = try await mailgun.client.messages.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("Send template email with authorized recipients")
    func testTemplateEmailWithAuthorizedRecipients() async throws {
        @Dependency(\.mailgun) var mailgun
        @Dependency(\.envVars.mailgunFrom) var from

        // Get authorized recipients
        let authorizedRecipients = try await getAuthorizedRecipients()

        // Create template variables for batch sending
        var recipientVarsDict: [String: [String: Any]] = [:]
        for (index, recipient) in authorizedRecipients.enumerated() {
            recipientVarsDict[recipient.rawValue] = [
                "firstName": "User",
                "lastName": "\(index + 1)",
                "accountType": index % 2 == 0 ? "Premium" : "Basic",
                "renewalDate": "2024-\(String(format: "%02d", (index % 12) + 1))-15"
            ]
        }

        let recipientVariables = try String(
            data: JSONSerialization.data(withJSONObject: recipientVarsDict),
            encoding: .utf8
        )!

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: authorizedRecipients,
            subject: "Account Update for %recipient.firstName% %recipient.lastName%",
            template: "account-update",
            templateVariables: """
                {
                    "company": "Test Company",
                    "year": "2024",
                    "supportEmail": "support@example.com"
                }
                """,
            testMode: true,
            recipientVariables: recipientVariables
        )

        let response = try await mailgun.client.messages.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }

    @Test("List and verify authorized recipients")
    func testListAuthorizedRecipients() async throws {
        @Dependency(\.mailgun) var mailgun

        let response = try await mailgun.client.accountManagement.getSandboxAuthRecipients()

        // Verify we have recipients
        #expect(!response.recipients.isEmpty)

        // Log recipients for debugging
        print("Found \(response.recipients.count) authorized recipients:")
        for recipient in response.recipients {
            print("  - \(recipient.email) (activated: \(recipient.activated))")
        }

        // Verify at least one is activated
        let activatedCount = response.recipients.filter { $0.activated }.count
        #expect(activatedCount > 0)
    }

    @Test(
        "Send MIME with multiple authorized recipients",
        .bug(id: 2, "MIME message field needs to be sent as file attachment, not form field")
    )
    func testMimeWithAuthorizedRecipients() async throws {
        @Dependency(\.mailgun) var mailgun
        @Dependency(\.envVars.mailgunFrom) var from

        // Get authorized recipients
        let authorizedRecipients = try await getAuthorizedRecipients()

        let recipientList = authorizedRecipients.map { $0.rawValue }.joined(separator: ", ")

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/plain; charset=UTF-8
            From: \(from.rawValue)
            To: \(recipientList)
            Subject: MIME Email to Authorized Recipients

            This MIME email is being sent to all authorized sandbox recipients.

            Recipients: \(recipientList)
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: authorizedRecipients,
            message: Data(mimeContent.utf8),
            testMode: true
        )

        let response = try await mailgun.client.messages.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    // Tests moved from Messages Comprehensive Tests and MIME Tests that require multiple recipients
    
    @Test("Send email to multiple recipients (moved from Comprehensive Tests)")
    func testSendEmailToMultipleRecipients() async throws {
        @Dependency(\.mailgun) var mailgun
        @Dependency(\.envVars.mailgunFrom) var from
        
        // Get all authorized recipients
        let authorizedRecipients = try await getAuthorizedRecipients()
        
        // Use at least 2 recipients if available, up to 4
        let recipientsToUse = Array(authorizedRecipients.prefix(4))
        
        guard recipientsToUse.count >= 2 else {
            throw TestError.insufficientRecipients(needed: 2, available: recipientsToUse.count)
        }

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: recipientsToUse,
            subject: "Email to Multiple Recipients",
            text: "This email is being sent to \(recipientsToUse.count) authorized recipients",
            testMode: true
        )

        let response = try await mailgun.client.messages.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with recipient variables for batch sending (moved from Comprehensive Tests)")
    func testSendBatchEmailWithRecipientVariables() async throws {
        @Dependency(\.mailgun) var mailgun
        @Dependency(\.envVars.mailgunFrom) var from
        
        // Get authorized recipients
        let authorizedRecipients = try await getAuthorizedRecipients()
        
        // Use at least 2 recipients
        let recipientsToUse = Array(authorizedRecipients.prefix(3))
        
        guard recipientsToUse.count >= 2 else {
            throw TestError.insufficientRecipients(needed: 2, available: recipientsToUse.count)
        }
        
        // Create recipient variables
        var recipientVarsDict: [String: [String: Any]] = [:]
        for (index, recipient) in recipientsToUse.enumerated() {
            recipientVarsDict[recipient.rawValue] = [
                "name": "Test User \(index + 1)",
                "id": index + 1
            ]
        }
        
        let recipientVariables = try String(
            data: JSONSerialization.data(withJSONObject: recipientVarsDict),
            encoding: .utf8
        )!

        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: recipientsToUse,
            subject: "Personalized Email for %recipient.name%",
            text: "Hello %recipient.name%! Your user ID is %recipient.id%.",
            testMode: true,
            recipientVariables: recipientVariables
        )

        let response = try await mailgun.client.messages.send(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send MIME with recipient variables (moved from MIME Tests)")
    func testSendMimeWithRecipientVariables() async throws {
        @Dependency(\.mailgun) var mailgun
        @Dependency(\.envVars.mailgunFrom) var from
        
        // Get authorized recipients
        let authorizedRecipients = try await getAuthorizedRecipients()
        
        // Use at least 2 recipients
        let recipientsToUse = Array(authorizedRecipients.prefix(2))
        
        guard recipientsToUse.count >= 2 else {
            throw TestError.insufficientRecipients(needed: 2, available: recipientsToUse.count)
        }
        
        // Create recipient variables
        var recipientVarsDict: [String: [String: Any]] = [:]
        for (index, recipient) in recipientsToUse.enumerated() {
            recipientVarsDict[recipient.rawValue] = [
                "name": "User \(index + 1)",
                "code": "CODE\(100 + index)"
            ]
        }
        
        let recipientVariables = try String(
            data: JSONSerialization.data(withJSONObject: recipientVarsDict),
            encoding: .utf8
        )!
        
        let toAddresses = recipientsToUse.map { $0.rawValue }.joined(separator: ", ")

        let mimeContent = """
            MIME-Version: 1.0
            Content-Type: text/plain; charset=UTF-8
            From: \(from.rawValue)
            To: \(toAddresses)
            Subject: Personalized MIME: %recipient.name%

            Hello %recipient.name%,

            Your unique code is: %recipient.code%
            """

        let request = Mailgun.Messages.Send.Mime.Request(
            to: recipientsToUse,
            message: Data(mimeContent.utf8),
            testMode: true,
            recipientVariables: recipientVariables
        )

        let response = try await mailgun.client.messages.sendMime(request)

        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
}
