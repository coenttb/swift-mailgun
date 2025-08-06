////
////  DKIM Security Client Tests.swift
////  coenttb-mailgun
////
////  Created by Coen ten Thije Boonkkamp on 27/12/2024.
////
//
//import Testing
//import Dependencies
//import DependenciesTestSupport
//import Mailgun_Domains
//
//@Suite(
//    "DKIM Security Client Tests",
//    .dependency(\.context, .live),
//    .dependency(\.envVars, .development),
//    .serialized
//)
//struct DKIMSecurityClientTests {
//    @Dependency(Mailgun.Domains.DKIM_Security.Client.self) var client
//    @Dependency(\.envVars.mailgunDomain) var domain
////    
////    CREATE TESTS FOR:
////    Operations
////
////    PUT
////    /v1/dkim_management/domains/{name}/rotation
////
////    POST
////    /v1/dkim_management/domains/{name}/rotate
//}
