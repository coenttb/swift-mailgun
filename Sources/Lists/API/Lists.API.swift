//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 20/12/2024.
//

import ServerFoundation
import Shared

public enum API: Equatable, Sendable {
    case create(request: Lists.List.Create.Request)
    case list(request: Lists.List.Request)
    case members(listAddress: EmailAddress, request: Lists.List.Members.Request)
    case addMember(listAddress: EmailAddress, request: Lists.Member.Add.Request)
    case bulkAdd(listAddress: EmailAddress, members: [Lists.Member.Bulk], upsert: Bool?)
    case bulkAddCSV(listAddress: EmailAddress, request: Foundation.Data, subscribed: Bool?, upsert: Bool?)
    case getMember(listAddress: EmailAddress, memberAddress: EmailAddress)
    case updateMember(listAddress: EmailAddress, memberAddress: EmailAddress, request: Lists.Member.Update.Request)
    case deleteMember(listAddress: EmailAddress, memberAddress: EmailAddress)
    case update(listAddress: EmailAddress, request: Lists.List.Update.Request)
    case delete(listAddress: EmailAddress)
    case get(listAddress: EmailAddress)
    case pages(limit: Int?)
    case memberPages(listAddress: EmailAddress, request: Lists.List.Members.Pages.Request)
}

extension API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}
        
        public var body: some URLRouting.Router<API> {
            OneOf {
                URLRouting.Route(.case(Lists.API.create)) {
                    Method.post
                    Path.v3
                    Path.lists
                    Body(.form(Lists.List.Create.Request.self, decoder: .mailgun))
                }
                
                URLRouting.Route(.case(Lists.API.list)) {
                    Method.get
                    Path.v3
                    Path.lists
                    Parse(.memberwise(Lists.List.Request.init)) {
                        URLRouting.Query {
                            Optionally {
                                Field("limit") { Digits() }
                            }
                            Optionally {
                                Field("skip") { Digits() }
                            }
                            Optionally {
                                Field("address") { Parse(.string.representing(EmailAddress.self)) }
                            }
                        }
                    }
                }
                
                URLRouting.Route(.case(Lists.API.members)) {
                    Method.get
                    Path.v3
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Parse(.memberwise(Lists.List.Members.Request.init)) {
                        URLRouting.Query {
                            Optionally {
                                Field("address") { Parse(.string.representing(EmailAddress.self)) }
                            }
                            Optionally {
                                Field("subscribed") { Bool.parser() }
                            }
                            Optionally {
                                Field("limit") { Digits() }
                            }
                            Optionally {
                                Field("skip") { Digits() }
                            }
                        }
                    }
                }
                
                URLRouting.Route(.case(Lists.API.addMember)) {
                    Method.post
                    Path.v3
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Body(.form(Lists.Member.Add.Request.self, decoder: .mailgun))
                }
                
                URLRouting.Route(.case(Lists.API.bulkAdd)) {
                    Method.post
                    Path.v3
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path { "members.json" }
                    Body(.form([Lists.Member.Bulk].self, decoder: .mailgun))
                    URLRouting.Query {
                        Optionally {
                            Field("upsert") { Bool.parser() }
                        }
                    }
                }
                
                URLRouting.Route(.case(Lists.API.bulkAddCSV)) {
                    Method.post
                    Path.v3
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path { "members.csv" }
                    Path { Parse(.data) }
                    URLRouting.Query {
                        Optionally {
                            Field("subscribed") { Bool.parser() }
                        }
                    }
                    URLRouting.Query {
                        Optionally {
                            Field("upsert") { Bool.parser() }
                        }
                    }
                }
                
                URLRouting.Route(.case(Lists.API.getMember)) {
                    Method.get
                    Path.v3
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
                URLRouting.Route(.case(Lists.API.updateMember)) {
                    
                    let multipartFormCoding = URLMultipartFormCodingURLRouting.Multipart.Conversion(
                        Lists.Member.Update.Request.self,
                        decoder: .mailgun
                    )
                    Headers {
                        Field.contentType { multipartFormCoding.contentType }
                    }
                    Method.put
                    Path.v3
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Body(multipartFormCoding)
                }
                
                URLRouting.Route(.case(Lists.API.deleteMember)) {
                    Method.delete
                    Path.v3
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
                URLRouting.Route(.case(Lists.API.update)) {
                    
                    let multipartFormCoding = URLMultipartFormCodingURLRouting.Multipart.Conversion(Lists.List.Update.Request.self, decoder: .mailgun)
                    
                    Headers {
                        Field.contentType { multipartFormCoding.contentType }
                    }
                    Method.put
                    Path.v3
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Body(multipartFormCoding)
                }
                
                URLRouting.Route(.case(Lists.API.delete)) {
                    Method.delete
                    Path.v3
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
                URLRouting.Route(.case(Lists.API.get)) {
                    Method.get
                    Path.v3
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                }
                
                URLRouting.Route(.case(Lists.API.pages)) {
                    Method.get
                    Path.v3
                    Path.lists
                    Path.pages
                    URLRouting.Query {
                        Optionally {
                            Field("limit") { Digits() }
                        }
                    }
                }
                
                URLRouting.Route(.case(Lists.API.memberPages)) {
                    Method.get
                    Path.v3
                    Path.lists
                    Path { Parse(.string.representing(EmailAddress.self)) }
                    Path.members
                    Path.pages
                    Parse(.memberwise(Lists.List.Members.Pages.Request.init)) {
                        URLRouting.Query {
                            Optionally {
                                Field("subscribed") { Bool.parser() }
                            }
                            Optionally {
                                Field("limit") { Digits() }
                            }
                            Optionally {
                                Field("address") { Parse(.string.representing(EmailAddress.self)) }
                            }
                            Optionally {
                                Field("page") { Parse(.string).map(.representing(Lists.PageDirection.self)) }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension Path<PathBuilder.Component<String>> {
    
    nonisolated(unsafe) public static let lists = Path {
        "lists"
    }
    
    nonisolated(unsafe) public static let members = Path {
        "members"
    }
}

extension Lists.API.Router: TestDependencyKey {
    public static let testValue: Self = .init()
}
