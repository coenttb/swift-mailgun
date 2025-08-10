//
//  Domain Tracking Client Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 27/12/2024.
//
import Dependencies
import DependenciesTestSupport
import Mailgun_Domains
import Mailgun_Shared
import Testing

@Suite(
    "Domain Tracking Client Tests",
    .dependency(\.context, .live),
    .dependency(\.envVars, .development),
    .serialized
)
struct DomainTrackingClientTests {
    @Dependency(Mailgun.Domains.Domains.Tracking.self) var domainTracking
    

    }
