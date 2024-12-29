//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import CoenttbWeb
import BasicAuth
import Shared
import Dependencies
import DependenciesMacros

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct API<OtherAPI: Equatable & Sendable> {
    let basicAuth: BasicAuth
    let api: OtherAPI
    
    public init(basicAuth: BasicAuth, api: OtherAPI) {
        self.basicAuth = basicAuth
        self.api = api
    }
    
    public init(apiKey: String, api: OtherAPI) {
        self.basicAuth = .init(username: "api", password: apiKey)
        self.api = api
    }
}

extension Authenticated.API {
    public struct Router<
        OtherAPIRouter: ParserPrinter & Sendable
    >: ParserPrinter, Sendable where OtherAPIRouter.Input == URLRequestData, OtherAPIRouter.Output == OtherAPI {
        
        let baseURL: URL
        let router: OtherAPIRouter
        
        public init(
            baseURL: URL,
            router: OtherAPIRouter
        ) {
            self.baseURL = baseURL
            self.router = router
        }
        
        public var body: some URLRouting.Router<Authenticated.API<OtherAPI>> {
            Parse(.memberwise(Authenticated.API<OtherAPI>.init)) {
                BasicAuth.Router()
                
                router
            }
            .baseURL(self.baseURL.absoluteString)
        }
    }
}

@dynamicMemberLookup
public struct Client<
    API: Equatable & Sendable,
    APIRouter: ParserPrinter & Sendable,
    ClientOutput: Sendable
>: Sendable where APIRouter.Input == URLRequestData, APIRouter.Output == API {

    private let apiKey: ApiKey
    private let baseUrl: URL
    private let session: @Sendable (URLRequest) async throws -> (Data, URLResponse)
    private let router: APIRouter
    private let buildClient: @Sendable (@escaping @Sendable (API) throws -> URLRequest) -> ClientOutput
    private let authenticatedRouter: Authenticated.API<API>.Router<APIRouter>

    public init(
        apiKey: ApiKey,
        baseUrl: URL,
        session: @escaping @Sendable (URLRequest) async throws -> (Data, URLResponse) = { request in try await URLSession.shared.data(for: request) },
        router: APIRouter,
        buildClient: @escaping @Sendable (@escaping @Sendable (API) throws -> URLRequest) -> ClientOutput
    ) {
        self.apiKey = apiKey
        self.baseUrl = baseUrl
        self.session = session
        self.router = router
        self.buildClient = buildClient
        self.authenticatedRouter = Authenticated.API.Router(
            baseURL: baseUrl,
            router: router
        )
    }
    

    public subscript<T>(dynamicMember keyPath: KeyPath<ClientOutput, T>) -> T {
        @Sendable
        func makeRequest(for api: API) throws -> URLRequest {
            do {
                let data = try authenticatedRouter.print(.init(apiKey: apiKey.rawValue, api: api))
                
                guard let request = URLRequest(data: data) else {
                    throw Error.requestError
                }
                
                return request
            } catch {
                throw Error.printError
            }
        }
        
        return buildClient(makeRequest)[keyPath: keyPath]
    }
}



public enum Error: Swift.Error {
    case printError
    case requestError
}


