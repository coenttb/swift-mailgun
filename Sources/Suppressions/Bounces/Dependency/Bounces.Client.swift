import CoenttbWeb
import DependenciesMacros
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Bounces {
    @DependencyClient
    public struct Client: Sendable {
        /// Import CSV file containing a list of addresses to add to the bounce list
        @DependencyEndpoint
        public var importList: @Sendable (_ request: Data) async throws -> Bounces.Import.Response
        
        /// Fetch a single bounce record
        @DependencyEndpoint
        public var get: @Sendable (_ address: EmailAddress) async throws -> Bounces.Record
        
        /// Delete a specific bounce record
        @DependencyEndpoint
        public var delete: @Sendable (_ address: EmailAddress) async throws -> Bounces.Delete.Response
        
        /// Paginate over a list of bounces for a domain
        @DependencyEndpoint
        public var list: @Sendable (_ request: Bounces.List.Request) async throws -> Bounces.List.Response
        
        /// Create a new bounce record
        @DependencyEndpoint
        public var create: @Sendable (_ request: Bounces.Create.Request) async throws -> Bounces.Create.Response
        
        /// Delete all bounce records for the domain
        @DependencyEndpoint
        public var deleteAll: @Sendable () async throws -> Bounces.Delete.All.Response
    }
}

extension Bounces.Client: TestDependencyKey {
    public static var testValue: Self {
        return Self(
            importList: { _ in
                .init(message: "file uploaded successfully")
            },
            get: { _ in
                .init(
                    address: try .init("test@example.com"),
                    code: "550",
                    error: "No such mailbox",
                    createdAt: "Fri, 18 Oct 2024 18:28:14 UTC"
                )
            },
            delete: { address in
                .init(
                    message: "Bounce has been removed",
                    address: address
                )
            },
            list: { _ in
                .init(
                    items: [
                        .init(
                            address: try .init("test@example.com"),
                            code: "550",
                            error: "No such mailbox",
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
                .init(message: "Bounce event has been created")
            },
            deleteAll: {
                .init(message: "Bounced addresses for this domain have been removed")
            }
        )
    }
}
