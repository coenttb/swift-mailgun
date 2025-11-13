# swift-mailgun

[![CI](https://github.com/coenttb/swift-mailgun/workflows/CI/badge.svg)](https://github.com/coenttb/swift-mailgun/actions/workflows/ci.yml)
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

A Swift SDK for Mailgun that combines [swift-mailgun-live](https://github.com/coenttb/swift-mailgun-live) with [swift-email](https://github.com/coenttb/swift-email) for provider-agnostic email composition.

## Overview

**swift-mailgun** provides Swift interfaces to the Mailgun API with seamless integration for the provider-agnostic `Email` type. This package is part of a three-tier architecture:

- **swift-mailgun** (this package): SDK with Email type integration
- **[swift-mailgun-live](https://github.com/coenttb/swift-mailgun-live)**: Live implementations with URLSession networking
- **[swift-mailgun-types](https://github.com/coenttb/swift-mailgun-types)**: Type definitions and interfaces

```swift
import Mailgun
import Dependencies

@Dependency(\.mailgun) var mailgun

// Send HTML email using the provider-agnostic Email type
let email = try Email(
    to: [.init("user@example.com")],
    from: .init("hello@yourdomain.com"),
    subject: "Welcome!"
) {
    div {
        h1 { "Welcome!" }
            .color(.blue)
            .textAlign(.center)

        p { "We're excited to have you on board." }
            .fontSize(.rem(1.1))
    }
    .padding(.rem(2))
}

let response = try await mailgun.client.messages.send(email: email)
```

## Features

- URLSession-based networking with async/await
- Provider-agnostic `Email` type for portable email composition
- Type-safe HTML email generation via [swift-html](https://github.com/coenttb/swift-html) DSL
- Seamless Mailgun-specific options (tags, tracking, scheduling)
- Dependency injection via swift-dependencies
- Swift 6 language mode with complete concurrency support
- Complete API coverage for Mailgun endpoints

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-mailgun", from: "0.1.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "Mailgun", package: "swift-mailgun")
        ]
    )
]
```

## Quick Start

### Environment Configuration

Set up environment variables:

```bash
MAILGUN_BASE_URL=https://api.mailgun.net
MAILGUN_PRIVATE_API_KEY=your-api-key
MAILGUN_DOMAIN=mg.yourdomain.com
```

### Basic Usage

```swift
import Dependencies
import Mailgun

@Dependency(\.mailgun) var mailgun

// Simple text email
func sendEmail(to recipient: EmailAddress) async throws {
    let email = try Email(
        to: [recipient],
        from: .init("noreply@yourdomain.com"),
        subject: "Hello",
        body: .text("Hello from Mailgun!")
    )

    let response = try await mailgun.client.messages.send(email: email)
    print("Email sent: \(response.id)")
}
```

### HTML Email Templates

Build type-safe HTML emails with swift-html via the `Email` type:

```swift
let email = try Email(
    to: [.init("subscriber@example.com")],
    from: .init("newsletter@yourdomain.com"),
    subject: "Weekly Newsletter"
) {
    div {
        h1 { "This Week's Highlights" }
            .marginBottom(.rem(1))

        ul {
            li { "New Swift 6 features" }
            li { "SwiftUI improvements" }
            li { "Server-side Swift updates" }
        }

        a(href: "{{unsubscribe}}") { "Unsubscribe" }
            .fontSize(.px(12))
            .color(.gray)
    }
    .fontFamily(.systemUI)
    .padding(.rem(2))
}

let response = try await mailgun.client.messages.send(email: email)
```

### Multipart Emails (Text + HTML)

Send emails with both plain text and HTML versions:

```swift
let email = try Email(
    to: [.init("user@example.com")],
    from: .init("newsletter@yourdomain.com"),
    subject: "Newsletter",
    text: "This is the plain text version."
) {
    div {
        h1 { "HTML Version" }
        p { "This is the HTML version with formatting." }
    }
}

let response = try await mailgun.client.messages.send(email: email)
```

### Mailgun-Specific Options

Add Mailgun features like tracking, tags, and scheduling:

```swift
let email = try Email(
    to: [.init("user@example.com")],
    from: .init("newsletter@yourdomain.com"),
    subject: "Weekly Update"
) {
    div { h1 { "Your Weekly Update" } }
}

let response = try await mailgun.client.messages.send(
    email: email,
    tags: ["newsletter", "weekly"],
    tracking: .yes,
    trackingClicks: .yes,
    testMode: false
)
```

### Scheduled Delivery

Schedule emails for future delivery:

```swift
let email = try Email(
    to: [.init("user@example.com")],
    from: .init("reminder@yourdomain.com"),
    subject: "Meeting Reminder",
    body: .text("Meeting in 1 hour")
)

let deliveryTime = Date().addingTimeInterval(3600) // 1 hour from now

let response = try await mailgun.client.messages.send(
    email: email,
    deliveryTime: deliveryTime
)
```

### Attachments

Send emails with file attachments:

```swift
let attachment = Mailgun.Messages.Attachment.Data(
    data: pdfData,
    filename: "report.pdf",
    contentType: "application/pdf"
)

let email = try Email(
    to: [.init("manager@example.com")],
    from: .init("reports@yourdomain.com"),
    subject: "Monthly Report",
    body: .text("See attached report")
)

// Note: Attachments require using Mailgun.Messages.Send.Request directly
let request = Mailgun.Messages.Send.Request(
    from: .init("reports@yourdomain.com"),
    to: [.init("manager@example.com")],
    subject: "Monthly Report",
    text: "See attached report",
    attachments: [attachment]
)

let response = try await mailgun.client.messages.send(request: request)
```

### Suppressions

```swift
// List bounces
let bounces = try await mailgun.client.suppressions.bounces.list()

// Add to unsubscribe list
try await mailgun.client.suppressions.unsubscribes.create(
    address: "user@example.com",
    tag: "newsletter"
)
```

### Analytics

```swift
// Get delivery statistics
let stats = try await mailgun.client.stats.total(
    event: .delivered,
    start: Date().addingTimeInterval(-7 * 24 * 3600),
    resolution: .day
)

// Search events
let events = try await mailgun.client.events.search(
    recipient: "user@example.com",
    limit: 50
)
```

## API Coverage

The SDK provides access to all Mailgun API endpoints:

| Category | Endpoints |
|----------|-----------|
| **Messages** | Send, retrieve, delete |
| **Domains** | Manage domains, DKIM, tracking settings |
| **Suppressions** | Bounces, complaints, unsubscribes, allowlist |
| **Reporting** | Events, stats, metrics, tags |
| **Templates** | Create, update, delete templates |
| **Webhooks** | Configure webhook endpoints |
| **Mailing Lists** | Manage mailing lists and members |
| **Routes** | Email routing rules |
| **IP Management** | IPs, IP pools, allowlist |
| **Account** | Subaccounts, users, credentials, keys |

## Testing

The package uses Swift Testing framework. Configure tests with environment variables:

```bash
MAILGUN_BASE_URL=https://api.mailgun.net
MAILGUN_PRIVATE_API_KEY=your-test-api-key
MAILGUN_DOMAIN=sandbox-domain.mailgun.org
```

Run tests:

```bash
swift test
```

## Related Packages

### Dependencies

- [swift-email](https://github.com/coenttb/swift-email): Provider-agnostic email composition with HTML builder support
- [swift-html](https://github.com/coenttb/swift-html): Type-safe HTML & CSS generation
- [swift-mailgun-live](https://github.com/coenttb/swift-mailgun-live): Live implementations for Mailgun API
- [swift-mailgun-types](https://github.com/coenttb/swift-mailgun-types): Foundational types for Mailgun

### Used By

- [coenttb-com-server](https://github.com/coenttb/coenttb-com-server): Production server for coenttb.com built with Boiler.
- [coenttb-newsletter](https://github.com/coenttb/coenttb-newsletter): A Swift package for newsletter subscription and email management.
- [swift-identities-mailgun](https://github.com/coenttb/swift-identities-mailgun): A Swift package integrating Mailgun with swift-identities.

### Third-Party Dependencies

- [pointfreeco/swift-dependencies](https://github.com/pointfreeco/swift-dependencies): A dependency management library for controlling dependencies in Swift.
- [pointfreeco/xctest-dynamic-overlay](https://github.com/pointfreeco/xctest-dynamic-overlay): Define XCTest assertion helpers directly in production code.

## License

This project is dual-licensed under:

- **GNU Affero General Public License v3.0 (AGPL-3.0)** for open source projects
  See [LICENSE](LICENSE) for details

- **Commercial License** for proprietary/commercial use
  Contact **info@coenttb.com** for licensing options

## Contributing

Contributions are welcome. Please submit a Pull Request.
