// `Domain` and `EmailAddress` appear as bare parameter types across the domain-scoped and
// address-scoped clients (Credentials, Domains, Domain Keys, Domain Tracking, DKIM Security,
// Messages, Lists, Suppressions, AccountManagement, Users). Re-exporting keeps consumers of
// `Mailgun` from having to import these L1/L2 packages separately, mirroring `GitHub`'s
// re-export of `GitHub Standard`.
@_exported public import Domain_Standard
@_exported public import EmailAddress_Standard
@_exported public import Mailgun_Standard

// The umbrella `Mailgun` target composes one client per resource (see `Mailgun.Client.swift`).
// Re-exporting each resource target keeps `import Mailgun` sufficient for consumers, mirroring
// the pre-existing `Mailgun Standard` re-export above.
@_exported public import Mailgun_AccountManagement
@_exported public import Mailgun_Credentials
@_exported public import Mailgun_CustomMessageLimit
@_exported public import Mailgun_Domains
@_exported public import Mailgun_DynamicIPPools
@_exported public import Mailgun_IPAddressWarmup
@_exported public import Mailgun_IPAllowlist
@_exported public import Mailgun_IPPools
@_exported public import Mailgun_IPs
@_exported public import Mailgun_Keys
@_exported public import Mailgun_Lists
@_exported public import Mailgun_Messages
@_exported public import Mailgun_Reporting
@_exported public import Mailgun_Routes
@_exported public import Mailgun_Subaccounts
@_exported public import Mailgun_Suppressions
@_exported public import Mailgun_Templates
@_exported public import Mailgun_Users
@_exported public import Mailgun_Webhooks
