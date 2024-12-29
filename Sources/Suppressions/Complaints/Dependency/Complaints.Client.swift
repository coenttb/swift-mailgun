// Complaints.Client.swift
import CoenttbWeb
import DependenciesMacros
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Complaints {
    @DependencyClient
    public struct Client: Sendable {
        @DependencyEndpoint
        public var importList: @Sendable (_ request: Data) async throws -> Complaints.Import.Response
        
        @DependencyEndpoint
        public var get: @Sendable (_ address: EmailAddress) async throws -> Complaints.Record
        
        @DependencyEndpoint
        public var delete: @Sendable (_ address: EmailAddress) async throws -> Complaints.Delete.Response
        
        @DependencyEndpoint
        public var list: @Sendable (_ request: Complaints.List.Request) async throws -> Complaints.List.Response
        
        @DependencyEndpoint
        public var create: @Sendable (_ request: Complaints.Create.Request) async throws -> Complaints.Create.Response
        
        @DependencyEndpoint
        public var deleteAll: @Sendable () async throws -> Complaints.Delete.All.Response
    }
}

extension Complaints.Client: TestDependencyKey {
    public static var testValue: Self {
        return Self(
            importList: { _ in
                .init(message: "file uploaded successfully")
            },
            get: { _ in
                .init(
                    address: try .init("test@example.com"),
                    createdAt: "Fri, 18 Oct 2024 18:28:14 UTC"
                )
            },
            delete: { _ in
                .init(
                    message: "Complaint has been removed",
                    address: try .init("test@example.com")
                )
            },
            list: { _ in
                .init(
                    items: [
                        .init(
                            address: try .init("test@example.com"),
                            createdAt: "Fri, 18 Oct 2024 18:28:14 UTC"
                        )
                    ],
                    paging: .init(
                        previous: "<previous page url>",
                        first: "<first page url>",
                        next: "<next page url>",
                        last: "<last page url>"
                    )
                )
            },
            create: { _ in
                .init(message: "Complaint event has been created")
            },
            deleteAll: {
                .init(message: "Complaint addresses for this domain have been removed")
            }
        )
    }
}
