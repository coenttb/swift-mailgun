import Testing
import Dependencies
import DependenciesTestSupport
import Mailgun_Messages
import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

@Suite(
    "Messages Attachments Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct MessagesAttachmentsTests {
    
    @Test("Send email with text attachment")
    func testSendEmailWithTextAttachment() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let attachmentContent = "This is the content of the text attachment.\nLine 2\nLine 3"
        let attachment = Mailgun.Messages.Attachment.Data(
            data: Data(attachmentContent.utf8),
            filename: "test-document.txt",
            contentType: "text/plain"
        )
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Text Attachment",
            text: "Please find the attached text file.",
            attachments: [attachment],
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with multiple attachments")
    func testSendEmailWithMultipleAttachments() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let textAttachment = Mailgun.Messages.Attachment.Data(
            data: Data("Text file content".utf8),
            filename: "document.txt",
            contentType: "text/plain"
        )
        
        let jsonAttachment = Mailgun.Messages.Attachment.Data(
            data: Data("""
                {
                    "test": "data",
                    "number": 123,
                    "array": [1, 2, 3]
                }
                """.utf8),
            filename: "data.json",
            contentType: "application/json"
        )
        
        let csvAttachment = Mailgun.Messages.Attachment.Data(
            data: Data("""
                Name,Email,Score
                John Doe,john@example.com,95
                Jane Smith,jane@example.com,98
                Bob Johnson,bob@example.com,87
                """.utf8),
            filename: "report.csv",
            contentType: "text/csv"
        )
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Multiple Attachments",
            html: """
                <h2>Multiple Attachments</h2>
                <p>This email contains:</p>
                <ul>
                    <li>A text document</li>
                    <li>A JSON file</li>
                    <li>A CSV report</li>
                </ul>
                """,
            text: "This email contains multiple attachments: a text document, a JSON file, and a CSV report.",
            attachments: [textAttachment, jsonAttachment, csvAttachment],
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with inline image")
    func testSendEmailWithInlineImage() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        // Create a simple 1x1 pixel PNG image
        let pngData = Data([
            0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,  // PNG signature
            0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,  // IHDR chunk
            0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
            0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53,
            0xDE, 0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41,  // IDAT chunk
            0x54, 0x08, 0x99, 0x63, 0xF8, 0x0F, 0x00, 0x00,
            0x01, 0x01, 0x01, 0x00, 0x1B, 0xB6, 0xEE, 0x56,
            0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44,  // IEND chunk
            0xAE, 0x42, 0x60, 0x82
        ])
        
        let inlineImage = Mailgun.Messages.Attachment.Data(
            data: pngData,
            filename: "logo.png",
            contentType: "image/png"
        )
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Inline Image",
            html: """
                <html>
                <body>
                    <h2>Inline Image Example</h2>
                    <p>Below is an inline image:</p>
                    <img src="cid:logo.png" alt="Logo" />
                    <p>The image should appear above this text.</p>
                </body>
                </html>
                """,
            text: "This email contains an inline image (HTML version only).",
            inline: [inlineImage],
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with both attachments and inline images")
    func testSendEmailWithAttachmentsAndInline() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        // Regular attachment
        let pdfAttachment = Mailgun.Messages.Attachment.Data(
            data: Data("%PDF-1.4\n%âãÏÓ\n1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n2 0 obj\n<< /Type /Pages /Kids [] /Count 0 >>\nendobj\ntrailer\n<< /Size 3 /Root 1 0 R >>\n%%EOF".utf8),
            filename: "document.pdf",
            contentType: "application/pdf"
        )
        
        // Inline image
        let inlineImage = Mailgun.Messages.Attachment.Data(
            data: Data([0x89, 0x50, 0x4E, 0x47]), // Simplified PNG header
            filename: "embedded.png",
            contentType: "image/png"
        )
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Mixed Attachments",
            html: """
                <html>
                <body>
                    <h2>Mixed Content Email</h2>
                    <p>This email has both inline images and attachments.</p>
                    <img src="cid:embedded.png" alt="Embedded Image" />
                    <p>Please also check the attached PDF document.</p>
                </body>
                </html>
                """,
            text: "This email contains both inline images and attachments. Please view in HTML.",
            attachments: [pdfAttachment],
            inline: [inlineImage],
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with large attachment")
    func testSendEmailWithLargeAttachment() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        // Create a 1MB attachment
        let largeContent = String(repeating: "A", count: 1024 * 1024)
        let largeAttachment = Mailgun.Messages.Attachment.Data(
            data: Data(largeContent.utf8),
            filename: "large-file.txt",
            contentType: "text/plain"
        )
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Large Attachment",
            text: "This email contains a large (1MB) attachment for testing.",
            attachments: [largeAttachment],
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with various file types")
    func testSendEmailWithVariousFileTypes() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let xmlAttachment = Mailgun.Messages.Attachment.Data(
            data: Data("""
                <?xml version="1.0" encoding="UTF-8"?>
                <root>
                    <item id="1">Test Item</item>
                </root>
                """.utf8),
            filename: "data.xml",
            contentType: "application/xml"
        )
        
        let htmlAttachment = Mailgun.Messages.Attachment.Data(
            data: Data("""
                <!DOCTYPE html>
                <html>
                <head><title>Test</title></head>
                <body><h1>Test HTML File</h1></body>
                </html>
                """.utf8),
            filename: "page.html",
            contentType: "text/html"
        )
        
        let markdownAttachment = Mailgun.Messages.Attachment.Data(
            data: Data("""
                # Markdown Document
                
                This is a **markdown** file with:
                - Lists
                - *Formatting*
                - [Links](https://example.com)
                """.utf8),
            filename: "README.md",
            contentType: "text/markdown"
        )
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Various File Types",
            html: """
                <h2>Various File Types</h2>
                <p>This email includes attachments of different types:</p>
                <ul>
                    <li>XML document</li>
                    <li>HTML file</li>
                    <li>Markdown file</li>
                </ul>
                """,
            attachments: [xmlAttachment, htmlAttachment, markdownAttachment],
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with binary attachment")
    func testSendEmailWithBinaryAttachment() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        // Create some binary data
        var binaryData = Data()
        for i in 0..<256 {
            binaryData.append(UInt8(i))
        }
        
        let binaryAttachment = Mailgun.Messages.Attachment.Data(
            data: binaryData,
            filename: "binary.dat",
            contentType: "application/octet-stream"
        )
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Binary Attachment",
            text: "This email contains a binary data file.",
            attachments: [binaryAttachment],
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
    
    @Test("Send email with special characters in filename")
    func testSendEmailWithSpecialFilename() async throws {
        @Dependency(Mailgun.Messages.Client.self) var client
        @Dependency(\.envVars.mailgunFrom) var from
        @Dependency(\.envVars.mailgunTo) var to
        
        let attachment = Mailgun.Messages.Attachment.Data(
            data: Data("File content with special filename".utf8),
            filename: "test file (2024) - copy [1].txt",
            contentType: "text/plain"
        )
        
        let request = Mailgun.Messages.Send.Request(
            from: from,
            to: [to],
            subject: "Email with Special Filename",
            text: "This email has an attachment with special characters in the filename.",
            attachments: [attachment],
            testMode: true
        )
        
        let response = try await client.send(request)
        
        #expect(!response.id.isEmpty)
        #expect(response.message.contains("Queued"))
    }
}