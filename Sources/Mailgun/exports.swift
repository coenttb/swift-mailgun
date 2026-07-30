// `Domain` and `EmailAddress` appear as bare parameter types across the domain-scoped and
// address-scoped clients (Credentials, Domains, Domain Keys, Domain Tracking, DKIM Security,
// Messages, Lists, Suppressions, AccountManagement, Users). Re-exporting keeps consumers of
// `Mailgun` from having to import these L1/L2 packages separately, mirroring `GitHub`'s
// re-export of `GitHub Standard`.
@_exported public import Domain_Standard
@_exported public import EmailAddress_Standard
@_exported public import Mailgun_Standard
