//
//  Metrics Router Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 29/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Foundation
import URLRouting
import Reporting

@Suite(
    "Metrics Router Tests"
)
struct MetricsRouterTests {

    @Test("Creates correct URL and JSON body for retrieving account metrics")
    func testGetAccountMetricsRequest() throws {
        @Dependency(Metrics.API.Router.self) var router
        
        let request = Metrics.GetAccountMetrics.Request(
            start: "2024-01-01",
            end: "2024-01-31",
            resolution: "day",
            duration: "1M",
            dimensions: ["campaign"],
            metrics: ["delivered_count"],
            filter: Metrics.Filter(and: [
                Metrics.FilterCondition(
                    attribute: "status",
                    comparator: "eq",
                    values: [Metrics.FilterValue(label: "Delivered", value: "delivered")]
                )
            ]),
            includeSubaccounts: true,
            includeAggregates: true
        )
        
        let url = router.url(for: .getAccountMetrics(request: request))
        #expect(url.path == "/v1/analytics/metrics")
    }

    @Test("Creates correct URL for retrieving usage metrics")
    func testGetUsageMetricsURL() throws {
        @Dependency(Metrics.API.Router.self) var router

        let request = Metrics.GetAccountUsageMetrics.Request(
            start: "2024-01-01",
            end: "2024-01-31",
            resolution: "hour",
            duration: "1M",
            dimensions: ["user"],
            metrics: ["processed_count"],
            filter: Metrics.Filter(and: [
                Metrics.FilterCondition(
                    attribute: "user_role",
                    comparator: "neq",
                    values: [Metrics.FilterValue(label: "Admin", value: "admin")]
                )
            ]),
            includeSubaccounts: false,
            includeAggregates: false
        )

        let url = router.url(for: .getAccountUsageMetrics(request: request))
    
        #expect(url.path == "/v1/analytics/usage/metrics")
    }
}
