//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import ServerFoundation
import Shared

public enum API: Equatable, Sendable {
    case create(request: Templates.Template.Create.Request)
    case list(domainId: Domain, page: Page, limit: Int, p: String)
    case get(domainId: Domain, templateId: String, active: String?)
    case update(domainId: Domain, templateId: String, request: Templates.Template.Update.Request)
    case delete(domainId: Domain, templateId: String)
    case versions(domainId: Domain, templateId: String, page: Page, limit: Int)
    case createVersion(domainId: Domain, templateId: String, request: Templates.Version.Create.Request)
    case getVersion(domainId: Domain, templateId: String, versionId: String)
    case updateVersion(domainId: Domain, templateId: String, versionId: String, request: Templates.Version.Update.Request)
    case deleteVersion(domainId: Domain, templateId: String, versionId: String)
    case copyVersion(domainId: Domain, templateId: String, versionId: String, tag: String, comment: String?)
}

extension API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<API> {
            OneOf {
                // GET /v3/{domainId}/templates
                Route(.case(API.list)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Query {
                        Field("page") { Parse(.string.representing(Page.self)) }
                    }
                    Query {
                        Field("limit") { Digits() }
                    }
                    Query {
                        Field("P") { Parse(.string) }
                    }
                }
                
                // POST /v3/{domainId}/templates
                Route(.case(API.create)) {
                    let multipartFormCoding = URLMultipartFormCodingURLRouting.Multipart.Conversion(
                        Templates.Template.Create.Request.self,
                        decoder: .mailgun
                    )
                    Headers {
                        Field.contentType { multipartFormCoding.contentType }
                    }
                    Method.post
                    Path.v3
                    Path.templates
                    Body(multipartFormCoding)
                }
                
                // GET /v3/{domainId}/templates/{templateId}
                Route(.case(API.get)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Query {
                        Optionally {
                            Field("active") { Parse(.string) }
                        }
                    }
                }
                
                // PUT /v3/{domainId}/templates/{templateId}
                Route(.case(API.update)) {
                    let multipartFormCoding = URLMultipartFormCodingURLRouting.Multipart.Conversion(
                        Templates.Template.Update.Request.self,
                        decoder: .mailgun
                    )
                    Headers {
                        Field.contentType { multipartFormCoding.contentType }
                    }
                    Method.put
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Body(multipartFormCoding)
                }
                
                // DELETE /v3/{domainId}/templates/{templateId}
                Route(.case(API.delete)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                }
                
                // GET /v3/{domainId}/templates/{templateId}/versions
                Route(.case(API.versions)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Query {
                        Field("page") { Parse(.string.representing(Page.self)) }
                    }
                    Query {
                        Field("limit") { Digits() }
                    }
                }
                
                // POST /v3/{domainId}/templates/{templateId}/versions
                Route(.case(API.createVersion)) {
                    let multipartFormCoding = URLMultipartFormCodingURLRouting.Multipart.Conversion(
                        Templates.Version.Create.Request.self,
                        decoder: .mailgun
                    )
                    Headers {
                        Field.contentType { multipartFormCoding.contentType }
                    }
                    Method.post
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Body(multipartFormCoding)
                }
                
                // GET /v3/{domainId}/templates/{templateId}/versions/{versionId}
                Route(.case(API.getVersion)) {
                    Method.get
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Path { Parse(.string) }
                }
                
                // PUT /v3/{domainId}/templates/{templateId}/versions/{versionId}
                Route(.case(API.updateVersion)) {
                    let multipartFormCoding = URLMultipartFormCodingURLRouting.Multipart.Conversion(
                        Templates.Version.Update.Request.self,
                        decoder: .mailgun
                    )
                    Headers {
                        Field.contentType { multipartFormCoding.contentType }
                    }
                    Method.put
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Path { Parse(.string) }
                    Body(multipartFormCoding)
                }
                
                // DELETE /v3/{domainId}/templates/{templateId}/versions/{versionId}
                Route(.case(API.deleteVersion)) {
                    Method.delete
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Path { Parse(.string) }
                }
                
                // PUT /v3/{domainId}/templates/{templateId}/versions/{versionId}/copy/{versionIdTo}
                Route(.case(API.copyVersion)) {
                    Method.put
                    Path.v3
                    Path { Parse(.string.representing(Domain.self)) }
                    Path.templates
                    Path { Parse(.string) }
                    Path.versions
                    Path { Parse(.string) }
                    Path { "copy" }
                    Path { Parse(.string) }
                    Query {
                        Optionally {
                            Field("comment") { Parse(.string) }
                        }
                    }
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    nonisolated(unsafe) static let templates = Path { "templates" }
    nonisolated(unsafe) static let versions = Path { "versions" }
}

extension Templates.API.Router: TestDependencyKey {
    public static let testValue: Self = .init()
}
