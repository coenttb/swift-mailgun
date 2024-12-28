# coenttb-mailgun

`coenttb-mailgun` is an unofficial SDK for Mailgun for Swift.

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

This package is currently in active development and is subject to frequent changes. Features and APIs may change without prior notice until a stable release is available.

## Features

### API Coverage

* **Complete Messages API Support**
  * Send emails with HTML and plain text content
  * Support for CC, BCC, and custom headers
  * Template handling with variables
  * Attachment support with MIME types
  * Message scheduling and delivery time optimization
  * Tracking options for opens and clicks

* **Comprehensive Mailing Lists API**
  * Create and manage mailing lists
  * Add/remove list members individually or in bulk
  * Support for member variables and metadata
  * Pagination support for large lists
  * Member subscription management
  * CSV import capabilities

### Technical Features

* **Type Safety & Swift Integration**
  * Fully type-safe API with detailed models
  * Swift concurrency with async/await
  * Swift 6.0 optimized

* **Authentication & Security**
  * Built-in Basic Auth handling
  * Secure credential management

* **Developer Experience**
  * Comprehensive test coverage
  * Dependency injection support via `swift-dependencies`
  * Mock implementations for testing

## Installation

Add the dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/coenttb-mailgun", branch: "main")
]
```

## Usage

### Configuration

```swift
import Mailgun

// Initialize the client
let client = Mailgun.Client.live(
    apiKey: .init(rawValue: "your-api-key"),
    baseUrl: .mailgun_eu_baseUrl, // or .mailgun_usa_baseUrl
    domain: "your-domain.com",
    session: URLSession.shared.data
)
```

### Sending Emails

```swift
// Create a basic email request
let request = Mailgun.Messages.Send.Request(
    from: "sender@yourdomain.com",
    to: ["recipient@example.com"],
    subject: "Hello from Mailgun Swift SDK",
    html: "<h1>Hello!</h1><p>This is a test email.</p>",
    text: "Hello! This is a test email."
)

// Send the email
let response = try await client.messages.send(request)
print("Message sent with ID: \(response.id)")
```

### Managing Mailing Lists

```swift
// Create a mailing list
let createListRequest = Lists.List.Create.Request(
    address: "developers@yourdomain.com",
    name: "Developers",
    description: "Development team mailing list",
    accessLevel: .readonly,
    replyPreference: .list
)

let list = try await client.mailingLists.create(createListRequest)

// Add a member to the list
let addMemberRequest = Lists.Member.Add.Request(
    address: "developer@example.com",
    name: "New Developer",
    vars: ["team": "backend"],
    subscribed: true
)

let member = try await client.mailingLists.addMember(
    "developers@yourdomain.com", 
    addMemberRequest
)
```

## Advanced Features

### Bulk Operations

```swift
// Bulk add members to a list
let members = [
    Lists.Member.Bulk(
        address: "member1@example.com",
        name: "Member 1",
        vars: ["role": "developer"]
    ),
    Lists.Member.Bulk(
        address: "member2@example.com",
        name: "Member 2",
        vars: ["role": "designer"]
    )
]

let bulkResponse = try await client.mailingLists.bulkAdd(
    "developers@yourdomain.com",
    members,
    upsert: true
)
```

### Advanced Email Features

```swift
// Send an email with advanced options
let advancedRequest = Mailgun.Messages.Send.Request(
    from: "sender@yourdomain.com",
    to: ["recipient@example.com"],
    subject: "Advanced Email",
    html: "<h1>Hello!</h1>",
    text: "Hello!",
    cc: ["cc@example.com"],
    bcc: ["bcc@example.com"],
    tags: ["welcome", "onboarding"],
    trackingOpens: true,
    trackingClicks: .htmlOnly,
    deliveryTime: Date().addingTimeInterval(3600), // Schedule for 1 hour later
    variables: ["user_name": "John"]
)
```

### Testing Support

The package includes comprehensive test support with mock implementations:

```swift
// Use test client in your test cases
let testClient = withDependencies {
    $0.mailgunClient = .testValue
} operation: {
    // Your test code here
}
```

## Error Handling

The SDK provides typed error handling:

```swift
do {
    let response = try await client.messages.send(request)
} catch let error as MailgunError {
    switch error {
    case .invalidResponse:
        print("Invalid response received")
    case .httpError(let statusCode, let message):
        print("HTTP error \(statusCode): \(message)")
    }
} catch {
    print("Unexpected error: \(error)")
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.




## Project Structure

The project is organized into multiple modules for clarity and modularity:


## Installation

You can add `coenttb-mailgun` to an Xcode project by including it as a package dependency:

Repository URL: https://github.com/coenttb/coenttb-mailgun

For a Swift Package Manager project, add the dependency in your Package.swift file:
```
dependencies: [
  .package(url: "https://github.com/coenttb/coenttb-mailgun", branch: "main")
]
```

## Example

Refer to [coenttb/coenttb-com-server](https://www.github.com/coenttb/coenttb-com-server) for an example of how to use coenttb-mailgun.

## Related Projects

* [coenttb/pointfree-html](https://www.github.com/coenttb/swift-css): A Swift DSL for type-safe HTML forked from [pointfreeco/swift-html](https://www.github.com/pointfreeco/swift-html) and updated to the version on [pointfreeco/pointfreeco](https://github.com/pointfreeco/pointfreeco).
* [coenttb/swift-css](https://www.github.com/coenttb/swift-css): A Swift DSL for type-safe CSS.
* [coenttb/swift-html](https://www.github.com/coenttb/swift-html): A Swift DSL for type-safe HTML & CSS, integrating [swift-css](https://www.github.com/coenttb/swift-css) and [coenttb/pointfree-html](https://www.github.com/coenttb/pointfree-html).
* [coenttb-html](https://www.github.com/coenttb/coenttb-html): Extends [coenttb/swift-html](https://www.github.com/coenttb/swift-html) with additional functionality and integrations for HTML, Markdown, Email, and printing HTML to PDF.
* [coenttb/swift-web](https://www.github.com/coenttb/swift-web): Modular tools to simplify web development in Swift forked from  [pointfreeco/swift-web](https://www.github.com/pointfreeco/swift-web), and updated for use in [coenttb/coenttb-web](https://www.github.com/coenttb/coenttb-web).
* [coenttb/coenttb-com-server](https://www.github.com/coenttb/coenttb-com-server): The backend server for coenttb.com, uses `coenttb-mailgun`, written entirely in Swift, and powered by [Vapor](https://www.github.com/vapor/vapor) and [coenttb-web](https://www.github.com/coenttb/coenttb-web).
* [coenttb/swift-languages](https://www.github.com/coenttb/swift-languages): A cross-platform translation library written in Swift.

## Feedback is much appreciated!

If you’re working on your own Swift project, feel free to learn, fork, and contribute.

Got thoughts? Found something you love? Something you hate? Let me know! Your feedback helps make this project better for everyone. Open an issue or start a discussion—I’m all ears.

> [Subscribe to my newsletter](http://coenttb.com/en/newsletter/subscribe)
>
> [Follow me on X](http://x.com/coenttb)
> 
> [Link on Linkedin](https://www.linkedin.com/in/tenthijeboonkkamp)

## License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.  
You are free to use, modify, and distribute this project under the terms of the AGPL-3.0.  
For full details, please refer to the [LICENSE](LICENSE) file.

### Commercial Licensing

A **Commercial License** is available for organizations or individuals who wish to use this project without adhering to the terms of the AGPL-3.0 (e.g., to use it in proprietary software or SaaS products).  

For inquiries about commercial licensing, please contact **info@coenttb.com**.
