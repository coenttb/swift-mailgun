//
//  File.swift
//  rule-law
//
//  Created by Coen ten Thije Boonkkamp on 05/01/2025.
//

import Authenticating
import Dependencies
import Foundation
import URLRouting

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias Authenticated<
    API: Equatable & Sendable,
    APIRouter: ParserPrinter & Sendable,
    Client: Sendable
> = Authenticating<
    BasicAuth,
    BasicAuth.Router,
    API,
    APIRouter,
    Client
> where APIRouter.Output == API, APIRouter.Input == URLRequestData

extension Authenticated {
    public init(
        router: APIRouter,
        buildClient: @escaping @Sendable (@escaping @Sendable (API) throws -> URLRequest) -> ClientOutput
    ) throws where Auth == BasicAuth, AuthRouter == BasicAuth.Router {
        @Dependency(\.envVars.mailgun.baseUrl) var baseUrl
        @Dependency(\.envVars.mailgun.apiKey) var apiKey
        
        self = .init(
            baseURL: baseUrl,
            auth: try .init(username: "api", password: apiKey.rawValue),
            apiRouter: router,
            authRouter: BasicAuth.Router(),
            buildClient: buildClient
        )
    }
}

extension Authenticated {
    package static func fromEnvironmentVariables(
        router: APIRouter,
        buildClient: @escaping @Sendable (
            _ makeRequest: @escaping @Sendable (_ route: API) throws -> URLRequest
        ) -> ClientOutput
    ) throws -> Self where Auth == BasicAuth, AuthRouter == BasicAuth.Router {
        return try Authenticated(
            router: router,
            buildClient: { buildClient($0) }
        )
    }
}

extension Authenticated where APIRouter: TestDependencyKey, APIRouter.Value == APIRouter {
    package init (
        buildClient: @escaping @Sendable () -> ClientOutput
    ) throws where Auth == BasicAuth, AuthRouter == BasicAuth.Router {
        @Dependency(APIRouter.self) var router
        self = try .fromEnvironmentVariables(
            router: router
        ) { _ in buildClient() }
    }
}

extension Authenticated where APIRouter: TestDependencyKey, APIRouter.Value == APIRouter {
    package init(
        _ buildClient: @escaping @Sendable (
            _ makeRequest: @escaping @Sendable (_ route: API) throws -> URLRequest
        ) -> ClientOutput
    ) throws where Auth == BasicAuth, AuthRouter == BasicAuth.Router {
        @Dependency(APIRouter.self) var router
        self = try .fromEnvironmentVariables(
            router: router,
            buildClient: buildClient
        )
    }
}
