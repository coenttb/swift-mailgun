# coenttb-mailgun

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/Platforms-macOS%2014%2B%20|%20iOS%2017%2B-lightgray.svg" alt="Platforms">
  <img src="https://img.shields.io/badge/License-AGPL--3.0%20|%20Commercial-blue.svg" alt="License">
  <img src="https://img.shields.io/badge/Status-Active%20Development-green.svg" alt="Status">
</p>

<p align="center">
  <strong>Modern, type-safe Swift SDK for Mailgun</strong><br>
  Production-ready implementation with comprehensive API coverage
</p>

## Overview

**coenttb-mailgun** is a modern, type-safe Swift SDK for Mailgun that brings the full power of Swift 6's concurrency model to email automation. Built on top of [swift-mailgun-types](https://github.com/coenttb/swift-mailgun-types), it provides production-ready implementations with comprehensive API coverage.

```swift
import Dependencies
import Mailgun

@Dependency(\.mailgun) var mailgun

// Send a simple email
let request = Mailgun.Messages.Send.Request(
    from: .init("hello@yourdomain.com"),
    to: [.init("user@example.com")],
    subject: "Welcome to coenttb-mailgun!",
    html: "<h1>Modern email delivery</h1><p>Built with Swift 6</p>"
)

let response = try await mailgun.client.messages.send(request)
print("Email sent: \(response.id)")
```

## Features

### 🚀 Production Ready
- **URLSession-based networking** with robust error handling
- **Basic Authentication** via swift-authenticating
- **Environment configuration** via swift-environment-variables
- **Dependency injection** via swift-dependencies
- **Swift 6 language mode** with complete concurrency support

### 📋 Comprehensive API Coverage

| Feature | Implementation | Tests |
|---------|:--------------:|:-----:|
| **Messages** | ✅ | ✅ |
| **Domains** | ✅ | ✅ |
| ├─ DKIM Security | ✅ | ✅ |
| ├─ Connection Settings | ✅ | ✅ |
| ├─ Domain Keys | ✅ | ✅ |
| └─ Tracking Settings | ✅ | ✅ |
| **Suppressions** | ✅ | ✅ |
| ├─ Bounces | ✅ | ✅ |
| ├─ Complaints | ✅ | ✅ |
| ├─ Unsubscribes | ✅ | ✅ |
| └─ Allowlist | ✅ | ✅ |
| **Reporting** | ✅ | ✅ |
| ├─ Events | ✅ | ✅ |
| ├─ Stats | ✅ | ✅ |
| ├─ Metrics | ✅ | ✅ |
| ├─ Tags | ✅ | ✅ |
| └─ Logs | ✅ | ✅ |
| **Templates** | ✅ | ✅ |
| **Webhooks** | ✅ | ✅ |
| **Mailing Lists** | ✅ | ✅ |
| **Routes** | ✅ | ✅ |
| **IP Management** | ✅ | ✅ |
| ├─ IPs | ✅ | ✅ |
| ├─ IP Pools | ✅ | ✅ |
| └─ IP Allowlist | ✅ | ✅ |
| **Account Management** | ✅ | ✅ |
| ├─ Subaccounts | ✅ | ✅ |
| ├─ Users | ✅ | ✅ |
| ├─ Credentials | ✅ | ✅ |
| ├─ Keys | ✅ | ✅ |
| └─ Message Limits | ✅ | ✅ |

### 🛡️ Type Safety & Modern Swift
- **Type-safe API** with compile-time validation
- **Swift concurrency** with async/await throughout
- **@Sendable closures** for thread-safe operations
- **Structured concurrency** support
- **Swift Testing framework** for comprehensive test coverage

## Installation

Add coenttb-mailgun to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/coenttb-mailgun", branch: "main")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "Mailgun", package: "coenttb-mailgun")
        ]
    )
]
```

## Quick Start

### Environment Configuration

Set up your environment variables:

```bash
# Required
MAILGUN_BASE_URL=https://api.mailgun.net
MAILGUN_PRIVATE_API_KEY=your-api-key
MAILGUN_DOMAIN=mg.yourdomain.com

# Optional (for testing)
MAILGUN_FROM_EMAIL=noreply@yourdomain.com
MAILGUN_TO_EMAIL=test@example.com
MAILGUN_TEST_MAILINGLIST=newsletter@mg.yourdomain.com
MAILGUN_TEST_RECIPIENT=subscriber@example.com
```

### Basic Usage

```swift
import Dependencies
import Mailgun

// Access the client via dependency injection
@Dependency(\.mailgun) var mailgun

// Send a simple email
func sendWelcomeEmail(to email: String) async throws {
    let request = Mailgun.Messages.Send.Request(
        from: .init("welcome@yourdomain.com"),
        to: [.init(email)],
        subject: "Welcome!",
        html: """
            <h1>Welcome to our service!</h1>
            <p>We're excited to have you on board.</p>
        """,
        text: "Welcome to our service! We're excited to have you on board."
    )
    
    let response = try await mailgun.client.messages.send(request)
    print("Welcome email sent: \(response.id)")
}
```

### Advanced Features

#### Templates with Variables

```swift
let request = Mailgun.Messages.Send.Request(
    from: .init("noreply@yourdomain.com"),
    to: [.init("user@example.com")],
    subject: "Your Order #{{order_id}}",
    template: "order-confirmation",
    templateVariables: [
        "customer_name": "John Doe",
        "order_id": "12345",
        "total": "$99.99",
        "items": ["Swift Book", "Mailgun Guide"]
    ],
    templateVersion: "v2"
)

let response = try await mailgun.client.messages.send(request)
```

#### Batch Sending with Recipient Variables

```swift
let request = Mailgun.Messages.Send.Request(
    from: .init("newsletter@yourdomain.com"),
    to: [
        .init("alice@example.com"),
        .init("bob@example.com"),
        .init("charlie@example.com")
    ],
    subject: "Hello %recipient.name%!",
    html: "<p>Special offer just for %recipient.name%: Use code %recipient.code%</p>",
    recipientVariables: [
        "alice@example.com": ["name": "Alice", "code": "ALICE20"],
        "bob@example.com": ["name": "Bob", "code": "BOB15"],
        "charlie@example.com": ["name": "Charlie", "code": "CHARLIE25"]
    ]
)
```

#### Scheduled Delivery

```swift
let deliveryTime = Date().addingTimeInterval(3600) // 1 hour from now

let request = Mailgun.Messages.Send.Request(
    from: .init("reminder@yourdomain.com"),
    to: [.init("user@example.com")],
    subject: "Reminder: Meeting in 1 hour",
    text: "Don't forget about your meeting!",
    deliveryTime: deliveryTime
)
```

#### Attachments

```swift
let attachment = Mailgun.Messages.Attachment(
    filename: "report.pdf",
    data: reportData,
    contentType: "application/pdf"
)

let request = Mailgun.Messages.Send.Request(
    from: .init("reports@yourdomain.com"),
    to: [.init("manager@example.com")],
    subject: "Monthly Report",
    html: "<p>Please find the monthly report attached.</p>",
    attachment: [attachment]
)
```

### Suppression Management

```swift
// Check if an email is bounced
let bounces = try await mailgun.client.suppressions.bounces.list()
let isBounced = bounces.items.contains { $0.address == "user@example.com" }

// Add to unsubscribe list
try await mailgun.client.suppressions.unsubscribes.create(
    address: "user@example.com",
    tag: "newsletter"
)

// Allowlist an important address
try await mailgun.client.suppressions.Allowlist.create(
    address: "vip@partner.com",
    reason: "Important business partner"
)
```

### Analytics & Reporting

```swift
// Get delivery statistics
let stats = try await mailgun.client.stats.total(
    event: .delivered,
    start: Date().addingTimeInterval(-7 * 24 * 3600), // Last 7 days
    resolution: .day
)

// Search events
let events = try await mailgun.client.events.search(
    recipient: "user@example.com",
    limit: 50
)

// Get metrics
let metrics = try await mailgun.client.metrics.query(
    metrics: [.deliverability.deliveredRate],
    start: Date().addingTimeInterval(-30 * 24 * 3600),
    resolution: .day
)
```

## Integration Examples

### With Vapor

```swift
import Vapor
import Mailgun
import Dependencies

extension Request {
    var mailgun: Mailgun.Client.Authenticated {
        @Dependency(\.mailgun) var mailgun
        return mailgun
    }
}

func routes(_ app: Application) throws {
    app.post("send-welcome") { req async throws -> HTTPStatus in
        let user = try req.content.decode(User.self)
        
        let email = Mailgun.Messages.Send.Request(
            from: .init("welcome@app.com"),
            to: [.init(user.email)],
            subject: "Welcome to our app!",
            template: "welcome",
            templateVariables: [
                "name": user.name,
                "activation_link": "https://app.com/activate/\(user.id)"
            ]
        )
        
        try await req.mailgun.client.messages.send(email)
        return .ok
    }
}
```

### With SwiftUI

```swift
import SwiftUI
import Dependencies
import Mailgun

@MainActor
@Observable
class ContactViewModel {
    @ObservationIgnored
    @Dependency(\.mailgun) var mailgun
    
    var isLoading = false
    var message = ""
    var error: Error?
    
    func sendContactForm(name: String, email: String, message: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = Mailgun.Messages.Send.Request(
                from: .init(email),
                to: [.init("contact@company.com")],
                subject: "Contact Form: \(name)",
                text: message,
                replyTo: .init(email)
            )
            
            let response = try await mailgun.client.messages.send(request)
            self.message = "Message sent successfully!"
        } catch {
            self.error = error
        }
    }
}
```

## Testing

The SDK includes comprehensive test coverage using Swift Testing:

```swift
import Testing
import Dependencies
import Mailgun

@Suite(
    "Email Tests",
    .dependency(\.envVars, .development)
)
struct EmailTests {
    @Test("Send test email")
    func testSendEmail() async throws {
        @Dependency(\.mailgun) var mailgun
        
        let request = Mailgun.Messages.Send.Request(
            from: .init("test@yourdomain.com"),
            to: [.init("test@example.com")],
            subject: "Test Email",
            text: "This is a test",
            testMode: true  // Won't actually send
        )
        
        let response = try await mailgun.client.messages.send(request)
        #expect(response.message.contains("Queued"))
    }
}
```

## Architecture

coenttb-mailgun implements the types and interfaces defined in [swift-mailgun-types](https://github.com/coenttb/swift-mailgun-types):

```
swift-mailgun-types              coenttb-mailgun
       │                               │
       ├─ Types & Models ─────────────►├─ Live Implementations
       ├─ Client Interfaces ──────────►├─ URLSession Networking
       ├─ API Routes ─────────────────►├─ Authentication
       └─ Test Support ───────────────►└─ Production Features
```

### Key Components

- **Modular Features**: Each API feature (Messages, Domains, etc.) is a separate module
- **Dependency Injection**: Deep integration with swift-dependencies
- **Type Safety**: All API interactions validated at compile time
- **Error Handling**: Comprehensive error types with detailed messages
- **Testing**: Real API integration tests with test mode support

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Example Projects

See coenttb-mailgun in action:

- [coenttb.com](https://github.com/coenttb/coenttb-com-server) - Production website using coenttb-mailgun
- [coenttb-newsletter](https://github.com/coenttb/coenttb-newsletter) - Newsletter system built with coenttb-mailgun

## Support

- 🐛 [Issues](https://github.com/coenttb/coenttb-mailgun/issues) - Report bugs or request features
- 💬 [Discussions](https://github.com/coenttb/coenttb-mailgun/discussions) - Ask questions
- 📧 [Newsletter](http://coenttb.com/en/newsletter/subscribe) - Get updates
- 🐦 [X (Twitter)](http://x.com/coenttb) - Follow for news
- 💼 [LinkedIn](https://www.linkedin.com/in/tenthijeboonkkamp) - Connect

## License

This project is available under **dual licensing**:

### Open Source License
**GNU Affero General Public License v3.0 (AGPL-3.0)**  
Free for open source projects. See [LICENSE](LICENSE) for details.

### Commercial License
For proprietary/commercial use without AGPL restrictions.  
Contact **info@coenttb.com** for licensing options.

---

<p align="center">
  Made with ❤️ by <a href="https://coenttb.com">coenttb</a>
</p>
