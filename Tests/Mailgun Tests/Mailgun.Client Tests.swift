import Domain_Standard
import EmailAddress_Standard
import Testing

@testable import Mailgun

@Suite("Mailgun.Client.Unit")
struct MailgunClientTests {
    @Test("Every resource client in the L3 surface constructs and wires into the root aggregate")
    func wiring() async {
        let messages = Mailgun.Messages.Client<Mailgun.Fixture.Failure>(
            send: {
                (_: Mailgun.Messages.Send.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Messages.Send.Response in throw .expected
            },
            sendMime: {
                (_: Mailgun.Messages.Send.Mime.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Messages.Send.Response in throw .expected
            },
            retrieve: {
                (_: String) async throws(Mailgun.Fixture.Failure) -> Mailgun.Messages.StoredMessage
                in throw .expected
            },
            queueStatus: {
                () async throws(Mailgun.Fixture.Failure) -> Mailgun.Messages.Queue.Status in
                throw .expected
            },
            deleteAll: {
                () async throws(Mailgun.Fixture.Failure) -> Mailgun.Messages.Delete.Response in
                throw .expected
            }
        )

        let mailingLists = Mailgun.Lists.Client<Mailgun.Fixture.Failure>(
            create: {
                (_: Mailgun.Lists.List.Create.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Lists.List.Create.Response in throw .expected
            },
            list: {
                (_: Mailgun.Lists.List.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Lists.List.Response in throw .expected
            },
            members: {
                (_: EmailAddress, _: Mailgun.Lists.List.Members.Request) async throws(Mailgun
                    .Fixture.Failure) -> Mailgun.Lists.List.Members.Response in throw .expected
            },
            addMember: {
                (_: EmailAddress, _: Mailgun.Lists.Member.Add.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Lists.Member.Add.Response in throw .expected
            },
            bulkAdd: {
                (_: EmailAddress, _: [Mailgun.Lists.Member.Bulk], _: Bool?) async throws(Mailgun
                    .Fixture.Failure) -> Mailgun.Lists.Member.Bulk.Response in throw .expected
            },
            bulkAddCSV: {
                (_: EmailAddress, _: [UInt8], _: Bool?, _: Bool?) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Lists.Member.Bulk.Response in throw .expected
            },
            getMember: {
                (_: EmailAddress, _: EmailAddress) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Lists.Member in throw .expected
            },
            updateMember: {
                (_: EmailAddress, _: EmailAddress, _: Mailgun.Lists.Member.Update.Request)
                    async throws(Mailgun.Fixture.Failure) -> Mailgun.Lists.Member.Update.Response in
                throw .expected
            },
            deleteMember: {
                (_: EmailAddress, _: EmailAddress) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Lists.Member.Delete.Response in throw .expected
            },
            update: {
                (_: EmailAddress, _: Mailgun.Lists.List.Update.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Lists.List.Update.Response in throw .expected
            },
            delete: {
                (_: EmailAddress) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Lists.List.Delete.Response in throw .expected
            },
            get: {
                (_: EmailAddress) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Lists.List.Get.Response in throw .expected
            },
            pages: {
                (_: Int?) async throws(Mailgun.Fixture.Failure) -> Mailgun.Lists.List.Pages.Response
                in throw .expected
            },
            memberPages: {
                (_: EmailAddress, _: Mailgun.Lists.List.Members.Pages.Request) async throws(Mailgun
                    .Fixture.Failure) -> Mailgun.Lists.List.Members.Pages.Response in
                throw .expected
            }
        )

        let suppressionsBounces = Mailgun.Suppressions.Bounces.Client<Mailgun.Fixture.Failure>(
            importList: {
                (_: [UInt8]) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Bounces.Import.Response in throw .expected
            },
            get: {
                (_: EmailAddress) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Bounces.Record in throw .expected
            },
            delete: {
                (_: EmailAddress) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Bounces.Delete.Response in throw .expected
            },
            list: {
                (_: Mailgun.Suppressions.Bounces.List.Request?) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Suppressions.Bounces.List.Response in throw .expected
            },
            create: {
                (_: Mailgun.Suppressions.Bounces.Create.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Suppressions.Bounces.Create.Response in throw .expected
            },
            deleteAll: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Bounces.Delete.All.Response in throw .expected
            }
        )

        let suppressionsComplaints = Mailgun.Suppressions.Complaints.Client<
            Mailgun.Fixture.Failure
        >(
            importList: {
                (_: Mailgun.Suppressions.Complaints.Import.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Suppressions.Complaints.Import.Response in throw .expected
            },
            get: {
                (_: EmailAddress) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Complaints.Get.Response in throw .expected
            },
            delete: {
                (_: EmailAddress) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Complaints.Delete.Response in throw .expected
            },
            list: {
                (_: Mailgun.Suppressions.Complaints.List.Request?) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Suppressions.Complaints.List.Response in throw .expected
            },
            create: {
                (_: Mailgun.Suppressions.Complaints.Create.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Suppressions.Complaints.Create.Response in throw .expected
            },
            deleteAll: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Complaints.Delete.All.Response in throw .expected
            }
        )

        let suppressionsUnsubscribe = Mailgun.Suppressions.Unsubscribe.Client<
            Mailgun.Fixture.Failure
        >(
            importList: {
                (_: [UInt8]) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Unsubscribe.Import.Response in throw .expected
            },
            get: {
                (_: EmailAddress) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Unsubscribe.Get.Response in throw .expected
            },
            delete: {
                (_: EmailAddress) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Unsubscribe.Delete.Response in throw .expected
            },
            list: {
                (_: Mailgun.Suppressions.Unsubscribe.List.Request?) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Suppressions.Unsubscribe.List.Response in throw .expected
            },
            create: {
                (_: Mailgun.Suppressions.Unsubscribe.Create.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Suppressions.Unsubscribe.Create.Response in throw .expected
            },
            deleteAll: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Unsubscribe.DeleteAll.Response in throw .expected
            }
        )

        let suppressionsAllowlist = Mailgun.Suppressions.Allowlist.Client<Mailgun.Fixture.Failure>(
            get: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Allowlist.Record in throw .expected
            },
            delete: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Allowlist.Delete.Response in throw .expected
            },
            list: {
                (_: Mailgun.Suppressions.Allowlist.List.Request?) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Suppressions.Allowlist.List.Response in throw .expected
            },
            create: {
                (_: Mailgun.Suppressions.Allowlist.Create.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Suppressions.Allowlist.Create.Response in throw .expected
            },
            deleteAll: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Allowlist.Delete.All.Response in throw .expected
            },
            importList: {
                (_: [UInt8]) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Suppressions.Allowlist.Import.Response in throw .expected
            }
        )

        let domainsDomains = Mailgun.Domains.Domains.Client<Mailgun.Fixture.Failure>(
            list: {
                (_: Mailgun.Domains.Domains.List.Request?) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.Domains.List.Response in throw .expected
            },
            create: {
                (_: Mailgun.Domains.Domains.Create.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.Domains.Create.Response in throw .expected
            },
            get: {
                (_: Domain) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.Domains.Get.Response in throw .expected
            },
            update: {
                (_: Domain, _: Mailgun.Domains.Domains.Update.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Domains.Domains.Update.Response in throw .expected
            },
            delete: {
                (_: Domain) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.Domains.Delete.Response in throw .expected
            },
            verify: {
                (_: Domain) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.Domains.Verify.Response in throw .expected
            }
        )

        let domainKeys = Mailgun.Domains.DomainKeys.Client<Mailgun.Fixture.Failure>(
            list: {
                (_: Mailgun.Domains.DomainKeys.List.Request?) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.DomainKeys.List.Response in throw .expected
            },
            create: {
                (_: Mailgun.Domains.DomainKeys.Create.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.DomainKeys.Create.Response in throw .expected
            },
            delete: {
                (_: Mailgun.Domains.DomainKeys.Delete.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.DomainKeys.Delete.Response in throw .expected
            },
            activate: {
                (_: String, _: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.DomainKeys.Activate.Response in throw .expected
            },
            listDomainKeys: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.DomainKeys.DomainKeysList.Response in throw .expected
            },
            deactivate: {
                (_: String, _: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.DomainKeys.Deactivate.Response in throw .expected
            },
            setDkimAuthority: {
                (_: String, _: Mailgun.Domains.DomainKeys.SetDkimAuthority.Request)
                    async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.DomainKeys.SetDkimAuthority.Response in throw .expected
            },
            setDkimSelector: {
                (_: String, _: Mailgun.Domains.DomainKeys.SetDkimSelector.Request)
                    async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.DomainKeys.SetDkimSelector.Response in throw .expected
            }
        )

        let domainTracking = Mailgun.Domains.Domains.Tracking.Client<Mailgun.Fixture.Failure>(
            get: {
                (_: Domain) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.Domains.Tracking.Get.Response in throw .expected
            },
            updateClick: {
                (_: Domain, _: Mailgun.Domains.Domains.Tracking.UpdateClick.Request)
                    async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.Domains.Tracking.UpdateClick.Response in throw .expected
            },
            updateOpen: {
                (_: Domain, _: Mailgun.Domains.Domains.Tracking.UpdateOpen.Request)
                    async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.Domains.Tracking.UpdateOpen.Response in throw .expected
            },
            updateUnsubscribe: {
                (_: Domain, _: Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Request)
                    async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.Domains.Tracking.UpdateUnsubscribe.Response in
                throw .expected
            }
        )

        let dkimSecurity = Mailgun.Domains.DKIM_Security.Client<Mailgun.Fixture.Failure>(
            updateRotation: {
                (_: Domain, _: Mailgun.Domains.DKIM_Security.Rotation.Update.Request)
                    async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.DKIM_Security.Rotation.Update.Response in throw .expected
            },
            rotateManually: {
                (_: Domain) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Domains.DKIM_Security.Rotation.Manual.Response in throw .expected
            }
        )

        let webhooks = Mailgun.Webhooks.Client<Mailgun.Fixture.Failure>(
            list: { () async throws(Mailgun.Fixture.Failure) -> Mailgun.Webhooks.List.Response in
                throw .expected
            },
            get: {
                (_: Mailgun.Webhooks.WebhookType) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Webhooks.Get.Response in throw .expected
            },
            create: {
                (_: Mailgun.Webhooks.Create.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Webhooks.Create.Response in throw .expected
            },
            update: {
                (_: Mailgun.Webhooks.WebhookType, _: Mailgun.Webhooks.Update.Request)
                    async throws(Mailgun.Fixture.Failure) -> Mailgun.Webhooks.Update.Response in
                throw .expected
            },
            delete: {
                (_: Mailgun.Webhooks.WebhookType) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Webhooks.Delete.Response in throw .expected
            }
        )

        let routes = Mailgun.Routes.Client<Mailgun.Fixture.Failure>(
            create: {
                (_: Mailgun.Routes.Create.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Routes.Create.Response in throw .expected
            },
            list: {
                (_: Int?, _: Int?) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Routes.List.Response in throw .expected
            },
            get: {
                (_: String) async throws(Mailgun.Fixture.Failure) -> Mailgun.Routes.Get.Response in
                throw .expected
            },
            update: {
                (_: String, _: Mailgun.Routes.Update.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Routes.Update.Response in throw .expected
            },
            delete: {
                (_: String) async throws(Mailgun.Fixture.Failure) -> Mailgun.Routes.Delete.Response
                in throw .expected
            },
            match: {
                (_: String) async throws(Mailgun.Fixture.Failure) -> Mailgun.Routes.Match.Response
                in throw .expected
            }
        )

        let templates = Mailgun.Templates.Client<Mailgun.Fixture.Failure>(
            list: {
                (_: Mailgun.Templates.List.Request?) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Templates.List.Response in throw .expected
            },
            create: {
                (_: Mailgun.Templates.Create.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Templates.Create.Response in throw .expected
            },
            deleteAll: {
                () async throws(Mailgun.Fixture.Failure) -> Mailgun.Templates.DeleteAll.Response in
                throw .expected
            },
            versions: {
                (_: String, _: Mailgun.Templates.Versions.Request?) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Templates.Versions.Response in throw .expected
            },
            createVersion: {
                (_: String, _: Mailgun.Templates.Version.Create.Request) async throws(Mailgun
                    .Fixture.Failure) -> Mailgun.Templates.Version.Create.Response in
                throw .expected
            },
            get: {
                (_: String, _: Mailgun.Templates.Get.Request?) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Templates.Get.Response in throw .expected
            },
            update: {
                (_: String, _: Mailgun.Templates.Update.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Templates.Update.Response in throw .expected
            },
            delete: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Templates.Delete.Response in throw .expected
            },
            getVersion: {
                (_: String, _: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Templates.Version.Get.Response in throw .expected
            },
            updateVersion: {
                (_: String, _: String, _: Mailgun.Templates.Version.Update.Request)
                    async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Templates.Version.Update.Response in throw .expected
            },
            deleteVersion: {
                (_: String, _: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Templates.Version.Delete.Response in throw .expected
            },
            copyVersion: {
                (_: String, _: String, _: String, _: Mailgun.Templates.Version.Copy.Request?)
                    async throws(Mailgun.Fixture.Failure) -> Mailgun.Templates.Version.Copy.Response
                in throw .expected
            }
        )

        let reportingEvents = Mailgun.Reporting.Events.Client<Mailgun.Fixture.Failure>(
            list: {
                (_: Mailgun.Reporting.Events.List.Query?) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Reporting.Events.List.Response in throw .expected
            }
        )

        let reportingStats = Mailgun.Reporting.Stats.Client<Mailgun.Fixture.Failure>(
            total: {
                (_: Mailgun.Reporting.Stats.Total.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Reporting.Stats.StatsList in throw .expected
            },
            filter: {
                (_: Mailgun.Reporting.Stats.Filter.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Reporting.Stats.StatsList in throw .expected
            },
            aggregateProviders: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Reporting.Stats.AggregatesProviders in throw .expected
            },
            aggregateDevices: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Reporting.Stats.AggregatesDevices in throw .expected
            },
            aggregateCountries: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Reporting.Stats.AggregatesCountries in throw .expected
            }
        )

        let reportingMetrics = Mailgun.Reporting.Metrics.Client<Mailgun.Fixture.Failure>(
            getAccountMetrics: {
                (_: Mailgun.Reporting.Metrics.GetAccountMetrics.Request) async throws(Mailgun
                    .Fixture.Failure) -> Mailgun.Reporting.Metrics.GetAccountMetrics.Response in
                throw .expected
            },
            getAccountUsageMetrics: {
                (_: Mailgun.Reporting.Metrics.GetAccountUsageMetrics.Request) async throws(Mailgun
                    .Fixture.Failure) -> Mailgun.Reporting.Metrics.GetAccountUsageMetrics.Response
                in throw .expected
            }
        )

        let reportingTags = Mailgun.Reporting.Tags.Client<Mailgun.Fixture.Failure>(
            list: {
                (_: Mailgun.Reporting.Tags.List.Request?) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Reporting.Tags.List.Response in throw .expected
            },
            get: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Reporting.Tags.Get.Response in throw .expected
            },
            update: {
                (_: String, _: Mailgun.Reporting.Tags.Update.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Reporting.Tags.Update.Response in throw .expected
            },
            delete: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Reporting.Tags.Delete.Response in throw .expected
            },
            stats: {
                (_: String, _: Mailgun.Reporting.Tags.Stats.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Reporting.Tags.Stats.Response in throw .expected
            },
            aggregates: {
                (_: String, _: Mailgun.Reporting.Tags.Aggregates.Request) async throws(Mailgun
                    .Fixture.Failure) -> Mailgun.Reporting.Tags.Aggregates.Response in
                throw .expected
            },
            limits: {
                () async throws(Mailgun.Fixture.Failure) -> Mailgun.Reporting.Tags.Limits.Response
                in throw .expected
            }
        )

        let reportingLogs = Mailgun.Reporting.Logs.Client<Mailgun.Fixture.Failure>(
            analytics: {
                (_: Mailgun.Reporting.Logs.Analytics.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Reporting.Logs.Analytics.Response in throw .expected
            }
        )

        let ips = Mailgun.IPs.Client<Mailgun.Fixture.Failure>(
            list: { () async throws(Mailgun.Fixture.Failure) -> Mailgun.IPs.List.Response in
                throw .expected
            },
            get: { (_: String) async throws(Mailgun.Fixture.Failure) -> Mailgun.IPs.IP in
                throw .expected
            },
            listDomains: {
                (_: String) async throws(Mailgun.Fixture.Failure) -> Mailgun.IPs.DomainList.Response
                in throw .expected
            },
            assignDomain: {
                (_: String, _: Mailgun.IPs.AssignDomain.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.IPs.AssignDomain.Response in throw .expected
            },
            unassignDomain: {
                (_: String, _: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPs.Delete.Response in throw .expected
            },
            assignIPBand: {
                (_: String, _: Mailgun.IPs.IPBand.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPs.IPBand.Response in throw .expected
            },
            requestNew: {
                (_: Mailgun.IPs.RequestNew.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPs.RequestNew.Response in throw .expected
            },
            getRequestedIPs: {
                () async throws(Mailgun.Fixture.Failure) -> Mailgun.IPs.RequestNew.Response in
                throw .expected
            },
            deleteDomainIP: {
                (_: String, _: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPs.Delete.Response in throw .expected
            },
            deleteDomainPool: {
                (_: String, _: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPs.Delete.Response in throw .expected
            }
        )

        let ipAddressWarmup = Mailgun.IPAddressWarmup.Client<Mailgun.Fixture.Failure>(
            list: {
                () async throws(Mailgun.Fixture.Failure) -> Mailgun.IPAddressWarmup.List.Response in
                throw .expected
            },
            get: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPAddressWarmup.IPWarmup in throw .expected
            },
            create: {
                (_: String, _: Mailgun.IPAddressWarmup.Create.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.IPAddressWarmup.Create.Response in throw .expected
            },
            delete: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPAddressWarmup.Delete.Response in throw .expected
            }
        )

        let ipPools = Mailgun.IPPools.Client<Mailgun.Fixture.Failure>(
            list: { () async throws(Mailgun.Fixture.Failure) -> Mailgun.IPPools.List.Response in
                throw .expected
            },
            create: {
                (_: Mailgun.IPPools.Create.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPPools.Create.Response in throw .expected
            },
            get: { (_: String) async throws(Mailgun.Fixture.Failure) -> Mailgun.IPPools.IPPool in
                throw .expected
            },
            update: {
                (_: String, _: Mailgun.IPPools.Update.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPPools.Update.Response in throw .expected
            },
            delete: {
                (_: String, _: Mailgun.IPPools.Delete.Request?) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.IPPools.Delete.Response in throw .expected
            },
            listDomains: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPPools.DomainsList.Response in throw .expected
            }
        )

        let dynamicIPPools = Mailgun.DynamicIPPools.Client<Mailgun.Fixture.Failure>(
            listHistory: {
                (_: Mailgun.DynamicIPPools.HistoryList.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.DynamicIPPools.HistoryList.Response in throw .expected
            },
            removeOverride: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.DynamicIPPools.RemoveOverride.Response in throw .expected
            }
        )

        let ipAllowlist = Mailgun.IPAllowlist.Client<Mailgun.Fixture.Failure>(
            list: { () async throws(Mailgun.Fixture.Failure) -> Mailgun.IPAllowlist.ListResponse in
                throw .expected
            },
            update: {
                (_: Mailgun.IPAllowlist.UpdateRequest) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPAllowlist.SuccessResponse in throw .expected
            },
            add: {
                (_: Mailgun.IPAllowlist.AddRequest) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPAllowlist.SuccessResponse in throw .expected
            },
            delete: {
                (_: Mailgun.IPAllowlist.DeleteRequest) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.IPAllowlist.SuccessResponse in throw .expected
            }
        )

        let keys = Mailgun.Keys.Client<Mailgun.Fixture.Failure>(
            list: { () async throws(Mailgun.Fixture.Failure) -> Mailgun.Keys.List.Response in
                throw .expected
            },
            create: {
                (_: Mailgun.Keys.Create.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Keys.Create.Response in throw .expected
            },
            delete: {
                (_: String) async throws(Mailgun.Fixture.Failure) -> Mailgun.Keys.Delete.Response in
                throw .expected
            },
            addPublicKey: {
                (_: Mailgun.Keys.PublicKey.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Keys.PublicKey.Response in throw .expected
            }
        )

        let credentials = Mailgun.Credentials.Client<Mailgun.Fixture.Failure>(
            list: {
                (_: Domain, _: Mailgun.Credentials.List.Request?) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Credentials.List.Response in throw .expected
            },
            create: {
                (_: Domain, _: Mailgun.Credentials.Create.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Credentials.Create.Response in throw .expected
            },
            deleteAll: {
                (_: Domain) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Credentials.Delete.Response in throw .expected
            },
            update: {
                (_: Domain, _: String, _: Mailgun.Credentials.Update.Request) async throws(Mailgun
                    .Fixture.Failure) -> Mailgun.Credentials.Update.Response in throw .expected
            },
            delete: {
                (_: Domain, _: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Credentials.Delete.Response in throw .expected
            },
            updateMailbox: {
                (_: Domain, _: String, _: Mailgun.Credentials.Mailbox.Update.Request)
                    async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Credentials.Mailbox.Update.Response in throw .expected
            }
        )

        let subaccounts = Mailgun.Subaccounts.Client<Mailgun.Fixture.Failure>(
            get: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Subaccounts.Get.Response in throw .expected
            },
            list: {
                (_: Mailgun.Subaccounts.List.Request?) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Subaccounts.List.Response in throw .expected
            },
            create: {
                (_: Mailgun.Subaccounts.Create.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Subaccounts.Create.Response in throw .expected
            },
            delete: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Subaccounts.Delete.Response in throw .expected
            },
            disable: {
                (_: String, _: Mailgun.Subaccounts.Disable.Request?) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.Subaccounts.Disable.Response in throw .expected
            },
            enable: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Subaccounts.Enable.Response in throw .expected
            },
            getCustomLimit: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Subaccounts.CustomLimit.Get.Response in throw .expected
            },
            updateCustomLimit: {
                (_: String, _: Double) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Subaccounts.CustomLimit.Update.Response in throw .expected
            },
            deleteCustomLimit: {
                (_: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Subaccounts.CustomLimit.Delete.Response in throw .expected
            },
            updateFeatures: {
                (_: String, _: Mailgun.Subaccounts.Features.Update.Request) async throws(Mailgun
                    .Fixture.Failure) -> Mailgun.Subaccounts.Features.Update.Response in
                throw .expected
            }
        )

        let users = Mailgun.Users.Client<Mailgun.Fixture.Failure>(
            list: {
                (_: Mailgun.Users.List.Request?) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Users.List.Response in throw .expected
            },
            get: {
                (_: String) async throws(Mailgun.Fixture.Failure) -> Mailgun.Users.Get.Response in
                throw .expected
            },
            me: { () async throws(Mailgun.Fixture.Failure) -> Mailgun.Users.Me.Response in
                throw .expected
            },
            addToOrganization: {
                (_: String, _: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Users.Organization.Add.Response in throw .expected
            },
            removeFromOrganization: {
                (_: String, _: String) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.Users.Organization.Remove.Response in throw .expected
            }
        )

        let customMessageLimit = Mailgun.CustomMessageLimit.Client<Mailgun.Fixture.Failure>(
            getMonthlyLimit: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.CustomMessageLimit.Monthly.Get.Response in throw .expected
            },
            setMonthlyLimit: {
                (_: Mailgun.CustomMessageLimit.Monthly.Set.Request) async throws(Mailgun.Fixture
                    .Failure) -> Mailgun.CustomMessageLimit.Monthly.Set.Response in throw .expected
            },
            deleteMonthlyLimit: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.CustomMessageLimit.Monthly.Delete.Response in throw .expected
            },
            enableAccount: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.CustomMessageLimit.EnableAccount.Response in throw .expected
            }
        )

        let accountManagement = Mailgun.AccountManagement.Client<Mailgun.Fixture.Failure>(
            updateAccount: {
                (_: Mailgun.AccountManagement.Update.Request) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.AccountManagement.Update.Response in throw .expected
            },
            getHttpSigningKey: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.AccountManagement.HttpSigningKey.Get.Response in throw .expected
            },
            regenerateHttpSigningKey: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.AccountManagement.HttpSigningKey.Regenerate.Response in
                throw .expected
            },
            getSandboxAuthRecipients: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.AccountManagement.Sandbox.Auth.Recipients.List.Response in
                throw .expected
            },
            addSandboxAuthRecipient: {
                (_: Mailgun.AccountManagement.Sandbox.Auth.Recipients.Add.Request)
                    async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.AccountManagement.Sandbox.Auth.Recipients.Add.Response in
                throw .expected
            },
            deleteSandboxAuthRecipient: {
                (_: EmailAddress) async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.AccountManagement.Sandbox.Auth.Recipients.Delete.Response in
                throw .expected
            },
            resendActivationEmail: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.AccountManagement.ResendActivationEmail.Response in throw .expected
            },
            getSAMLOrganization: {
                () async throws(Mailgun.Fixture.Failure)
                    -> Mailgun.AccountManagement.SAML.Organization.Get.Response in throw .expected
            },
            addSAMLOrganization: {
                (_: Mailgun.AccountManagement.SAML.Organization.Add.Request) async throws(Mailgun
                    .Fixture.Failure) -> Mailgun.AccountManagement.SAML.Organization.Add.Response in
                throw .expected
            }
        )

        let suppressions = Mailgun.Suppressions.Client<Mailgun.Fixture.Failure>(
            bounces: suppressionsBounces,
            complaints: suppressionsComplaints,
            unsubscribe: suppressionsUnsubscribe,
            allowlist: suppressionsAllowlist
        )

        let domains = Mailgun.Domains.Client<Mailgun.Fixture.Failure>(
            domains: domainsDomains,
            dkimSecurity: dkimSecurity,
            domainKeys: domainKeys,
            domainTracking: domainTracking
        )

        let reporting = Mailgun.Reporting.Client<Mailgun.Fixture.Failure>(
            metrics: reportingMetrics,
            stats: reportingStats,
            events: reportingEvents,
            tags: reportingTags,
            logs: reportingLogs
        )

        let client = Mailgun.Client<Mailgun.Fixture.Failure>(
            messages: messages,
            mailingLists: mailingLists,
            events: reportingEvents,
            suppressions: suppressions,
            webhooks: webhooks,
            domains: domains,
            templates: templates,
            routes: routes,
            ips: ips,
            ipPools: ipPools,
            ipAllowlist: ipAllowlist,
            keys: keys,
            users: users,
            subaccounts: subaccounts,
            credentials: credentials,
            customMessageLimit: customMessageLimit,
            accountManagement: accountManagement,
            reporting: reporting
        )

        // The two standalone clients the archived root aggregate never wired in
        // (IPAddressWarmup, DynamicIPPools) still construct on their own.
        _ = ipAddressWarmup
        _ = dynamicIPPools

        // `@dynamicMemberLookup` forwards `Domains.Client` member access to the
        // nested `domains` sub-client without an explicit `.domains` hop: calling
        // `client.domains.list` below only compiles and only reaches `domainsDomains`'
        // closure because the forwarding subscript resolves it.
        await #expect(throws: Mailgun.Fixture.Failure.expected) {
            try await client.messages.queueStatus()
        }
        await #expect(throws: Mailgun.Fixture.Failure.expected) {
            try await client.domains.list(nil)
        }
        await #expect(throws: Mailgun.Fixture.Failure.expected) {
            try await client.suppressions.bounces.deleteAll()
        }
        await #expect(throws: Mailgun.Fixture.Failure.expected) {
            try await client.reporting.tags.limits()
        }
    }
}
