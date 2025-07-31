//
//  File.swift
//  rule-law
//
//  Created by Coen ten Thije Boonkkamp on 05/01/2025.
//

import Foundation
import Coenttb_Authentication
import Coenttb_Web
import Dependencies
import EmailAddress

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension AuthenticatedClient {
    package static func test(
        router: APIRouter,
        buildClient: @escaping @Sendable (
            _ makeRequest: @escaping @Sendable (_ route: API) throws -> URLRequest
        ) -> ClientOutput
    ) throws -> Self where Auth == BasicAuth, AuthRouter == BasicAuth.Router {
        try withDependencies {
            $0.envVars = .liveTest
        } operation: {
            @Dependency(\.envVars) var envVars
            @Dependency(\.defaultSession) var session
            
            let baseUrl = envVars.mailgunBaseUrl
            let apiKey = envVars.mailgunPrivateApiKey!
            
            return try AuthenticatedClient(
                apiKey: apiKey,
                baseUrl: baseUrl,
                router: router,
                buildClient: { buildClient($0) }
            )
        }
    }
}

extension AuthenticatedClient where APIRouter: TestDependencyKey, APIRouter.Value == APIRouter {
    package static func test(
        _ buildClient: @escaping @Sendable (
            _ makeRequest: @escaping @Sendable (_ route: API) throws -> URLRequest
        ) -> ClientOutput
    ) throws -> Self where Auth == BasicAuth, AuthRouter == BasicAuth.Router {
        @Dependency(APIRouter.self) var router
        @Dependency(\.defaultSession) var session
        return try .test(
            router: router,
            buildClient: buildClient
        )
    }
}

extension AuthenticatedClient where APIRouter: TestDependencyKey, APIRouter.Value == APIRouter {
    package static func test(
        buildClient: @escaping @Sendable () -> ClientOutput
    ) throws -> Self where Auth == BasicAuth, AuthRouter == BasicAuth.Router {
        @Dependency(APIRouter.self) var router
        @Dependency(\.defaultSession) var session
        return try .test(
            router: router
        ) { _ in buildClient() }
    }
}
