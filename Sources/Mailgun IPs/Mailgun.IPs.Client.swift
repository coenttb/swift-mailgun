import Mailgun_Standard

extension Mailgun.IPs {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var list: @Sendable () async throws(Failure) -> Mailgun.IPs.List.Response
        public var get: @Sendable (_ ip: String) async throws(Failure) -> Mailgun.IPs.IP
        public var listDomains:
            @Sendable (_ ip: String) async throws(Failure) -> Mailgun.IPs.DomainList.Response
        public var assignDomain:
            @Sendable (_ ip: String, _ request: Mailgun.IPs.AssignDomain.Request)
                async throws(Failure) -> Mailgun.IPs.AssignDomain.Response
        public var unassignDomain:
            @Sendable (_ ip: String, _ domain: String) async throws(Failure) ->
                Mailgun.IPs.Delete.Response
        public var assignIPBand:
            @Sendable (_ ip: String, _ request: Mailgun.IPs.IPBand.Request) async throws(Failure) ->
                Mailgun.IPs.IPBand.Response
        public var requestNew:
            @Sendable (_ request: Mailgun.IPs.RequestNew.Request) async throws(Failure) ->
                Mailgun.IPs.RequestNew.Response
        public var getRequestedIPs:
            @Sendable () async throws(Failure) -> Mailgun.IPs.RequestNew.Response
        public var deleteDomainIP:
            @Sendable (_ domain: String, _ ip: String) async throws(Failure) ->
                Mailgun.IPs.Delete.Response
        public var deleteDomainPool:
            @Sendable (_ domain: String, _ ip: String) async throws(Failure) ->
                Mailgun.IPs.Delete.Response

        public init(
            list: @escaping @Sendable () async throws(Failure) -> Mailgun.IPs.List.Response,
            get: @escaping @Sendable (_ ip: String) async throws(Failure) -> Mailgun.IPs.IP,
            listDomains:
                @escaping @Sendable (_ ip: String) async throws(Failure) ->
                Mailgun.IPs.DomainList.Response,
            assignDomain:
                @escaping @Sendable (_ ip: String, _ request: Mailgun.IPs.AssignDomain.Request)
                async throws(Failure) -> Mailgun.IPs.AssignDomain.Response,
            unassignDomain:
                @escaping @Sendable (_ ip: String, _ domain: String) async throws(Failure) ->
                Mailgun.IPs.Delete.Response,
            assignIPBand:
                @escaping @Sendable (_ ip: String, _ request: Mailgun.IPs.IPBand.Request)
                async throws(Failure) -> Mailgun.IPs.IPBand.Response,
            requestNew:
                @escaping @Sendable (_ request: Mailgun.IPs.RequestNew.Request)
                async throws(Failure) -> Mailgun.IPs.RequestNew.Response,
            getRequestedIPs:
                @escaping @Sendable () async throws(Failure) -> Mailgun.IPs.RequestNew.Response,
            deleteDomainIP:
                @escaping @Sendable (_ domain: String, _ ip: String) async throws(Failure) ->
                Mailgun.IPs.Delete.Response,
            deleteDomainPool:
                @escaping @Sendable (_ domain: String, _ ip: String) async throws(Failure) ->
                Mailgun.IPs.Delete.Response
        ) {
            self.list = list
            self.get = get
            self.listDomains = listDomains
            self.assignDomain = assignDomain
            self.unassignDomain = unassignDomain
            self.assignIPBand = assignIPBand
            self.requestNew = requestNew
            self.getRequestedIPs = getRequestedIPs
            self.deleteDomainIP = deleteDomainIP
            self.deleteDomainPool = deleteDomainPool
        }
    }
}
