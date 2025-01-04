# coenttb-mailgun

`coenttb-mailgun` is an unofficial Swift SDK for Mailgun that is modern, safe, and a joy to write in.

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

This package is currently in active development and is subject to frequent changes. Features and APIs may change without prior notice until a stable release is available.

## Features

### API Coverage

| Name | Implementation Status | Test Status |
|------|---------------------|-------------|
| Messages | ✅ | ✅ |
| Domains - DKIM Security | | |
| Domains - Domain Connection | | |
| Domains - Domain Keys | | |
| Domains - Domain Tracking | | |
| Webhooks | ✅ | |🚧| Events | ✅ | |
| Tags | ✅ | 🚧 |
| Reporting - Metrics | ✅ | ✅ |
| Reporting - Stats | ✅ | ✅ |
| Suppressions - Bounces | ✅ | ✅ |
| Suppressions - Complaints | ✅ | ✅ |
| Suppressions - Unsubscribe | ✅ | ✅ |
| Suppressions - Whitelist | ✅ | ✅ |
| Routes | | |
| Mailing Lists | ✅ | ✅ |
| Templates | ✅ | 🚧 |
| IP Pools | | |
| IPs | | |
| Subaccounts | | |
| Custom Message Limit | | |
| Keys | | |
| Credentials | | |
| IP Allowlist | | |
| Users | | |
  
### Technical Features

* **Type Safety & Swift Integration**
  * Fully type-safe API & Client
  * Swift concurrency with async/await
  * Swift 6.0 optimized

* **Authentication & Security**
  * Secure credential management via `swift-environment-variables`
  * Built-in Basic Auth handling

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

#### [recommended] Configuration via Dependencies
```swift
import Mailgun

extension Mailgun.Client: @retroactive DependencyKey {
    public static var liveValue: Mailgun.AuthenticatedClient? {
        @Dependency(\.envVars) var envVars
        
        guard
            let baseURL = envVars.mailgun?.baseURL,
            let apiKey = envVars.mailgun?.apiKey,
            let domain = envVars.mailgun?.domain
        else {
            return nil
        }
        
        return Mailgun.Client.live(
            apiKey: apiKey,
            baseUrl: baseURL,
            domain: domain,
            session: { try await URLSession.shared.data(for: $0) }
        )
    }
}
```

Access the client via `Dependency(\.mailgunClient) var mailgunClient`.

### Sending Emails

```swift
Dependency(\.mailgunClient) var mailgunClient

// Create a basic email request
let request = try Mailgun.Messages.Send.Request(
    from: .init("sender@yourdomain.com"),
    to: [.init("recipient@example.com")],
    subject: "Hello from Mailgun Swift SDK",
    html: "<h1>Hello!</h1><p>This is a test email.</p>",
    text: "Hello! This is a test email."
)

// Send the email
let response = try await mailgunClient.messages.send(request)
print("Message sent with ID: \(response.id)")
```

### Testing Support

The package includes a comprehensive test suite.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Example

Refer to [coenttb/coenttb-com-server](https://www.github.com/coenttb/coenttb-com-server) for an example of how to use coenttb-mailgun.

## Related projects

### The coenttb stack

* [swift-css](https://www.github.com/coenttb/swift-css): A Swift DSL for type-safe CSS.
* [swift-html](https://www.github.com/coenttb/swift-html): A Swift DSL for type-safe HTML & CSS, integrating [swift-css](https://www.github.com/coenttb/swift-css) and [pointfree-html](https://www.github.com/coenttb/pointfree-html).
* [swift-web](https://www.github.com/coenttb/swift-web): Foundational tools for web development in Swift.
* [coenttb-html](https://www.github.com/coenttb/coenttb-html): Builds on [swift-html](https://www.github.com/coenttb/swift-html), and adds functionality for HTML, Markdown, Email, and printing HTML to PDF.
* [coenttb-web](https://www.github.com/coenttb/coenttb-web): Builds on [swift-web](https://www.github.com/coenttb/swift-web), and adds functionality for web development.
* [coenttb-server](https://www.github.com/coenttb/coenttb-server): Build fast, modern, and safe servers that are a joy to write. `coenttb-server` builds on [coenttb-web](https://www.github.com/coenttb/coenttb-web), and adds functionality for server development.
* [coenttb-vapor](https://www.github.com/coenttb/coenttb-server-vapor): `coenttb-server-vapor` builds on [coenttb-server](https://www.github.com/coenttb/coenttb-server), and adds functionality and integrations with Vapor and Fluent.
* [coenttb-com-server](https://www.github.com/coenttb/coenttb-com-server): The backend server for coenttb.com, written entirely in Swift and powered by [coenttb-server-vapor](https://www.github.com/coenttb-server-vapor).

### PointFree foundations
* [coenttb/pointfree-html](https://www.github.com/coenttb/pointfree-html): A Swift DSL for type-safe HTML, forked from [pointfreeco/swift-html](https://www.github.com/pointfreeco/swift-html) and updated to the version on [pointfreeco/pointfreeco](https://github.com/pointfreeco/pointfreeco).
* [coenttb/pointfree-web](https://www.github.com/coenttb/pointfree-html): Foundational tools for web development in Swift, forked from  [pointfreeco/swift-web](https://www.github.com/pointfreeco/swift-web).
* [coenttb/pointfree-server](https://www.github.com/coenttb/pointfree-html): Foundational tools for server development in Swift, forked from  [pointfreeco/swift-web](https://www.github.com/pointfreeco/swift-web).

### Other
* [swift-languages](https://www.github.com/coenttb/swift-languages): A cross-platform translation library written in Swift.

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
