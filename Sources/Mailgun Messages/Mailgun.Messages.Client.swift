import Mailgun_Standard

extension Mailgun.Messages {
    public struct Client<Failure: Swift.Error>: Sendable {
        public var send:
            @Sendable (_ request: Mailgun.Messages.Send.Request) async throws(Failure) ->
                Mailgun.Messages.Send.Response
        public var sendMime:
            @Sendable (_ request: Mailgun.Messages.Send.Mime.Request) async throws(Failure) ->
                Mailgun.Messages.Send.Response
        public var retrieve:
            @Sendable (_ storageKey: String) async throws(Failure) -> Mailgun.Messages.StoredMessage
        public var queueStatus: @Sendable () async throws(Failure) -> Mailgun.Messages.Queue.Status
        public var deleteAll: @Sendable () async throws(Failure) -> Mailgun.Messages.Delete.Response

        public init(
            send:
                @escaping @Sendable (_ request: Mailgun.Messages.Send.Request) async throws(Failure)
                -> Mailgun.Messages.Send.Response,
            sendMime:
                @escaping @Sendable (_ request: Mailgun.Messages.Send.Mime.Request)
                async throws(Failure) -> Mailgun.Messages.Send.Response,
            retrieve:
                @escaping @Sendable (_ storageKey: String) async throws(Failure) ->
                Mailgun.Messages.StoredMessage,
            queueStatus:
                @escaping @Sendable () async throws(Failure) -> Mailgun.Messages.Queue.Status,
            deleteAll:
                @escaping @Sendable () async throws(Failure) -> Mailgun.Messages.Delete.Response
        ) {
            self.send = send
            self.sendMime = sendMime
            self.retrieve = retrieve
            self.queueStatus = queueStatus
            self.deleteAll = deleteAll
        }
    }
}
