//
//  File.swift
//  rule-law
//
//  Created by Coen ten Thije Boonkkamp on 05/01/2025.
//

import Foundation
import URLRouting
import Coenttb_Authentication
import Coenttb_Web_Dependencies

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias AuthenticatedClient<
    API: Equatable & Sendable,
    APIRouter: ParserPrinter & Sendable,
    Client: Sendable
> = Coenttb_Authentication.Client<
    BasicAuth,
    BasicAuth.Router,
    API,
    APIRouter,
    Client
> where APIRouter.Output == API, APIRouter.Input == URLRequestData

extension AuthenticatedClient {
    public init(
        apiKey: ApiKey,
        baseUrl: URL,
        router: APIRouter,
        buildClient: @escaping @Sendable (@escaping @Sendable (API) throws -> URLRequest) -> ClientOutput
    ) throws where Auth == BasicAuth, AuthRouter == BasicAuth.Router {
        
        self = .init(
            baseURL: baseUrl,
            auth: try .init(username: "api", password: apiKey.rawValue),
            router: router,
            authRouter: BasicAuth.Router(),
            buildClient: buildClient
        )
    }
}

