# coenttb-mailgun

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-orange.svg" alt="Swift 6.0">
  <img src="https://img.shields.io/badge/Platforms-macOS%2014%2B%20|%20iOS%2017%2B-lightgray.svg" alt="Platforms">
  <img src="https://img.shields.io/badge/Tests-238%20Passing-brightgreen.svg" alt="Tests">
  <img src="https://img.shields.io/badge/Coverage-100%25%20APIs-brightgreen.svg" alt="API Coverage">
  <img src="https://img.shields.io/badge/License-AGPL--3.0%20|%20Commercial-blue.svg" alt="License">
  <img src="https://img.shields.io/badge/Status-Production%20Ready-green.svg" alt="Status">
  <img src="https://img.shields.io/badge/Version-0.0.1-brightgreen.svg" alt="Version">
</p>

<p align="center">
  <strong>Complete Swift SDK for Mailgun with Integrations</strong><br>
  User-friendly package with SwiftUI, HTML templates, and more
</p>

## Overview

**coenttb-mailgun** is the complete, user-friendly Swift SDK for Mailgun that combines the power of [swift-mailgun-live](https://github.com/coenttb/swift-mailgun-live) with additional integrations for SwiftUI, HTML email templates, and more. It's the recommended entry point for using Mailgun in your Swift applications.

This package is part of a modular three-package architecture:
- **coenttb-mailgun** (this package): User-facing SDK with integrations
- **[swift-mailgun-live](https://github.com/coenttb/swift-mailgun-live)**: Live implementations with URLSession networking
- **[swift-mailgun-types](https://github.com/coenttb/swift-mailgun-types)**: Type definitions and interfaces

```swift
// github.com/coenttb/coenttb-mailgun
import Mailgun  // Complete SDK with integrations

@Dependency(\.mailgun) var mailgun

// Send email with type-safe HTML using swift-html integration
let request = try Mailgun.Messages.Send.Request(
    from: .init("hello@yourdomain.com"),
    to: [try .init("user@example.com")],
    subject: "Welcome to Our Service!"
) {
    div {
        h1 { "Welcome!" }
            .color(.blue)
            .textAlign(.center)
        
        p { "We're excited to have you on board." }
            .fontSize(.rem(1.1))
            .lineHeight(1.6)
        
        a(href: "https://example.com/get-started") {
            "Get Started"
        }
        .display(.inlineBlock)
        .padding(.rem(0.75), .rem(1.5))
        .backgroundColor(.blue)
        .color(.white)
        .borderRadius(.px(5))
    }
    .padding(.rem(2))
}

let response = try await mailgun.client.messages.send(request)
print("Email sent: \(response.id) ✅")
```

## Features

### 🚀 Production Ready
- **URLSession-based networking** with robust error handling
- **Basic Authentication** via swift-authenticating
- **Environment configuration** via swift-environment-variables
- **Dependency injection** via swift-dependencies
- **Swift 6 language mode** with complete concurrency support

### 📋 Complete API Coverage

| Feature | Implementation | Tests | Status |
|---------|:--------------:|:-----:|:------:|
| **Messages** | ✅ | ✅ | Production |
| **Domains** | ✅ | ✅ | Production |
| ├─ DKIM Security | ✅ | ✅ | Ready |
| ├─ Connection Settings | ✅ | ✅ | Ready |
| ├─ Domain Keys | ✅ | ✅ | Ready |
| └─ Tracking Settings | ✅ | ✅ | Ready |
| **Suppressions** | ✅ | ✅ | Production |
| ├─ Bounces | ✅ | ✅ | Ready |
| ├─ Complaints | ✅ | ✅ | Ready |
| ├─ Unsubscribes | ✅ | ✅ | Ready |
| └─ Allowlist | ✅ | ✅ | Ready |
| **Reporting** | ✅ | ✅ | Production |
| ├─ Events | ✅ | ✅ | Ready |
| ├─ Stats | ✅ | ✅ | Ready |
| ├─ Metrics | ✅ | ✅ | Ready |
| ├─ Tags | ✅ | ✅ | Ready |
| └─ Logs | ✅ | ✅ | Ready |
| **Templates** | ✅ | ✅ | Production |
| **Webhooks** | ✅ | ✅ | Production |
| **Mailing Lists** | ✅ | ✅ | Production |
| **Routes** | ✅ | ✅ | Ready |
| **IP Management** | ✅ | ✅ | Ready |
| ├─ IPs | ✅ | ✅ | Ready |
| ├─ IP Pools | ✅ | ✅ | Ready |
| └─ IP Allowlist | ✅ | ✅ | Ready |
| **Account Management** | ✅ | ✅ | Ready |
| ├─ Subaccounts | ✅ | ✅ | Ready |
| ├─ Users | ✅ | ✅ | Ready |
| ├─ Credentials | ✅ | ✅ | Ready |
| ├─ Keys | ✅ | ✅ | Ready |
| └─ Message Limits | ✅ | ✅ | Ready |

**Legend**: Production = Used in production | Ready = Fully tested and ready for production use

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
    .package(url: "https://github.com/coenttb/coenttb-mailgun", from: "0.1.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "CoenttbMailgun", package: "coenttb-mailgun")
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

// Send email with type-safe HTML and CSS styling
func sendWelcomeEmail(to email: EmailAddress, name: String) async throws {
    let request = try Mailgun.Messages.Send.Request(
        from: .init("welcome@yourdomain.com"),
        to: [.init(email)],
        subject: "Welcome, \(name)!"
    ) {
        VStack(alignment: .center) {
            h1 { "Welcome, \(name)!" }
                .color(.black)
                .marginBottom(.rem(1))
            
            p { "Thanks for joining us. Here's what you can do next:" }
                .fontSize(.rem(1.1))
                .color(.gray)
                .marginBottom(.rem(2))
            
            VStack(alignment: .left) {
                div { "✓ Complete your profile" }
                div { "✓ Explore our features" }
                div { "✓ Join the community" }
            }
            .fontSize(.rem(1))
            .lineHeight(1.8)
            .marginBottom(.rem(2))
            
            a(href: "https://app.com/profile") {
                "Complete Profile"
            }
            .display(.inlineBlock)
            .padding(.rem(1), .rem(2))
            .backgroundColor(.blue)
            .color(.white)
            .textDecoration(.none)
            .borderRadius(.px(8))
            .fontWeight(.semibold)
        }
        .fontFamily(.systemUI)
        .padding(.rem(3))
        .maxWidth(.rem(30))
        .margin(.auto)
    }
    
    let response = try await mailgun.client.messages.send(request)
    print("Welcome email sent: \(response.id)")
}
```

### Advanced Features

#### Type-Safe HTML Email Building

Use swift-html DSL for compile-time safe HTML generation:

```swift
let request = try Mailgun.Messages.Send.Request(
    from: .init("newsletter@yourdomain.com"),
    to: [.init("subscriber@example.com")],
    subject: "Your Weekly Newsletter"
) {
    div {
        h1 { "This Week's Highlights" }
    }
    div {
        h2 { "Top Stories" }
        ul {
            li { "New Swift 6 features announced" }
            li { "SwiftUI improvements in iOS 18" }
            li { "Server-side Swift adoption growing" }
        }
        
        h2 { "Community Updates" }
        p {
            "Join us for the upcoming "
            a(href: "https://swift.org/conference") { "Swift Conference" }
            " next month!"
        }
    }
    div {
        p {
            "You're receiving this because you subscribed. "
            a(href: "{{unsubscribe}}") { "Unsubscribe" }
        }
    }
}
```

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
        
        @Dependency(\.mailgun) var mailgun
        
        let email = try Mailgun.Messages.Send.Request(
            from: .init("welcome@app.com"),
            to: [.init(user.email)],
            subject: "Welcome to our app!"
        ) {
            h1 { "Welcome, \(user.name)!" }
            p { "Thanks for signing up. We're excited to have you on board!" }
            div(style: "margin: 20px 0;") {
                a(
                    href: "https://app.com/activate/\(user.id)",
                    style: "background: #007AFF; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;"
                ) {
                    "Activate Your Account"
                }
            }
            p { "If you have any questions, just reply to this email." }
        }
        
        try await mailgun.client.messages.send(email)
        return .ok
    }
}
```

### With SwiftUI

```swift
import SwiftUI
import Mailgun

@MainActor
@Observable
class ContactViewModel {
    @ObservationIgnored
    @Dependency(\.mailgun) var mailgun
    
    var isLoading = false
    var message = ""
    var error: Error?
    
    func sendContactForm(name: String, email: EmailAddress, message: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let request = try Mailgun.Messages.Send.Request(
                from: .init(email),
                to: [.init("contact@company.com")],
                subject: "Contact Form: \(name)",
                replyTo: .init(email)
            ) {
                div {
                    h2 { "New Contact Form Submission" }
                        .marginBottom(.rem(1))
                    
                    table {
                        tr {
                            td { "Name:" }
                                .padding(.rem(0.625))
                                .borderBottom(.px(1), .solid, .lightGray)
                                .fontWeight(.semibold)
                            td { name }
                                .padding(.rem(0.625))
                                .borderBottom(.px(1), .solid, .lightGray)
                        }
                        tr {
                            td { "Email:" }
                                .padding(.rem(0.625))
                                .borderBottom(.px(1), .solid, .lightGray)
                                .fontWeight(.semibold)
                            td { 
                                a(href: "mailto:\(email)") { String(email) }
                                    .color(.blue)
                            }
                            .padding(.rem(0.625))
                            .borderBottom(.px(1), .solid, .lightGray)
                        }
                        tr {
                            td { "Message:" }
                                .padding(.rem(0.625))
                                .verticalAlign(.top)
                                .fontWeight(.semibold)
                            td {
                                p { message }
                                    .whiteSpace(.preWrap)
                            }
                            .padding(.rem(0.625))
                        }
                    }
                    .width(.percent(100))
                    .borderCollapse(.collapse)
                }
                .fontFamily(.systemUI)
                .padding(.rem(1.25))
            }
            
            let response = try await mailgun.client.messages.send(request)
            self.message = "Message sent successfully!"
        } catch {
            self.error = error
        }
    }
}
```

## Testing

The SDK includes comprehensive test coverage with **238 tests** - all passing! ✅

### Test Coverage

| Category | Tests | Status |
|----------|------:|:------:|
| **Messages** | 45 | ✅ |
| **Suppressions** | 28 | ✅ |
| **Domains** | 22 | ✅ |
| **Templates** | 15 | ✅ |
| **Webhooks** | 12 | ✅ |
| **Routes** | 10 | ✅ |
| **Lists** | 18 | ✅ |
| **IP Management** | 25 | ✅ |
| **Reporting** | 20 | ✅ |
| **Account Management** | 15 | ✅ |
| **Other Features** | 28 | ✅ |
| **Total** | **238** | **100% Passing** |

### Test Configuration

Tests use environment variables for configuration. Create a `.env.development` file:

```bash
MAILGUN_BASE_URL=https://api.mailgun.net
MAILGUN_PRIVATE_API_KEY=your-test-api-key
MAILGUN_DOMAIN=sandbox-domain.mailgun.org
MAILGUN_FROM_EMAIL=test@sandbox-domain.mailgun.org
MAILGUN_TO_EMAIL=authorized@sandbox-domain.mailgun.org
```

### Writing Tests

The SDK uses Swift Testing framework with dependency injection:

```swift
import Testing
import DependenciesTestSupport
import Mailgun

@Suite(
    "Email Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development)
)
struct EmailTests {
    @Test("Send test email")
    func testSendEmail() async throws {
        @Dependency(\.mailgun) var mailgun
        
        let request = Mailgun.Messages.Send.Request(
            from: .init("test@yourdomain.com"),
            to: [.init("authorized@yourdomain.com")],
            subject: "Test Email",
            text: "This is a test",
            testMode: true  // Won't actually send
        )
        
        let response = try await mailgun.client.messages.send(request)
        #expect(response.message.contains("Queued"))
    }
}
```

### Sandbox Testing

For sandbox domains, ensure you've added authorized recipients:

```swift
// Helper to get authorized sandbox recipients
func getAuthorizedRecipients() async throws -> [EmailAddress] {
    @Dependency(\.mailgun) var mailgun
    
    let response = try await mailgun.client.accountManagement.getSandboxAuthRecipients()
    return response.recipients
        .filter(\.activated)
        .map(\.email)
}
```

### Test Utilities

The package includes helpful test utilities:

- **Sandbox Reset Test**: Clean up test data while preserving authorized recipients
- **Integration Tests**: Real API tests with authorized recipients

## Architecture

**coenttb-mailgun** is the top-level package in a three-tier architecture:

```
┌─────────────────────────────────────────────────────────┐
│                   coenttb-mailgun                       │
│         (User-facing package with integrations)         │
│                                                         │
│  • SwiftUI components & views                           │
│  • HTML email templates (via swift-html)               │
│  • Re-exports swift-mailgun-live functionality         │
│  • High-level convenience APIs                          │
│  • Integration helpers for common frameworks            │
└─────────────────────────────────────────────────────────┘
                            │
                      imports/uses
                            ▼
┌─────────────────────────────────────────────────────────┐
│                  swift-mailgun-live                     │
│              (Live implementation layer)                │
│                                                         │
│  • URLSession-based networking                          │
│  • Authentication handling                              │
│  • Environment configuration                            │
│  • Dependency injection setup                           │
│  • Production-ready client implementations              │
└─────────────────────────────────────────────────────────┘
                            │
                       implements
                            ▼
┌─────────────────────────────────────────────────────────┐
│                  swift-mailgun-types                    │
│            (Type definitions & interfaces)              │
│                                                         │
│  • Domain models & data structures                      │
│  • Client protocol definitions                          │
│  • API route specifications                             │
│  • Error types & utilities                              │
│  • Test value implementations                           │
└─────────────────────────────────────────────────────────┘
```

### What This Package Provides

#### Core Mailgun Functionality
- Re-exports all features from swift-mailgun-live
- Complete API coverage for all Mailgun endpoints
- Production-ready with comprehensive testing

#### Additional Integrations
- **Type-Safe HTML Emails**: Build HTML emails using swift-html DSL instead of strings
- **SwiftUI Components**: Ready-to-use views for email composition and management
- **Vapor Integration**: Seamless integration with server-side Swift
- **Convenience APIs**: Higher-level abstractions for common tasks

#### Key Benefits
- **Single Import**: One package for all Mailgun needs
- **Type Safety**: Compile-time validation across all layers
- **Dependency Injection**: Built-in swift-dependencies support
- **Modular Architecture**: Use only what you need
- **Production Ready**: Battle-tested in real applications

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Migration Guide

### From swift-mailgun-live

If you're currently using swift-mailgun-live directly, migration is simple:

1. Update your Package.swift:
```swift
// Before
.package(url: "https://github.com/coenttb/swift-mailgun-live", from: "0.0.1")

// After
.package(url: "https://github.com/coenttb/coenttb-mailgun", from: "0.1.0")
```

2. Update your imports:
```swift
// Before
import Mailgun

// After
import Mailgun
```

3. All existing code continues to work - coenttb-mailgun is a superset of swift-mailgun-live.

### Additional Features Available

After migrating, you gain access to:
- **Type-safe HTML emails**: Build emails with swift-html DSL instead of error-prone strings
- **SwiftUI components**: Ready-to-use email UI components
- **Enhanced template builders**: Reusable email template functions
- **Additional helper functions**: High-level convenience APIs
- **Framework integrations**: Better Vapor, SwiftUI integration

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
