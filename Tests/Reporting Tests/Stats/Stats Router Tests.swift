//
//  Stats Router Tests.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 29/12/2024.
//

import Testing
import Dependencies
import DependenciesTestSupport
import Foundation
import URLRouting
import TestShared
import Reporting
import Domain

@Suite(
    "Stats Router Tests"
)
struct StatsRouterTests {

    @Test("Creates correct URL for retrieving total stats")
    func testGetTotalStatsURL() throws {
        @Dependency(Stats.API.Router.self) var router
        
        let request = Stats.Total.Request(
            event: "delivered",
            start: "2024-01-01",
            end: "2024-01-31",
            resolution: "day",
            duration: "1M"
        )
        
        let url = router.url(for: .total(request: request))
        #expect(url.path == "/v3/stats/total")
    }

    @Test("Creates correct URL for retrieving filtered stats")
    func testGetFilteredStatsURL() throws {
        @Dependency(Stats.API.Router.self) var router

        let request = Stats.Filter.Request(
            event: "clicked",
            start: "2024-01-01",
            end: "2024-01-31",
            resolution: "hour",
            duration: "1W",
            filter: "region",
            group: "country"
        )

        let url = router.url(for: .filter(request: request))
    
        #expect(url.path == "/v3/stats/filter")
    }

    @Test("Creates correct URL for retrieving provider aggregates")
    func testGetAggregateProvidersURL() throws {
        @Dependency(Stats.API.Router.self) var router

        let domain = try Domain("test.domain.com")
        let url = router.url(for: .aggregateProviders(domain: domain))
        
        #expect(url.path == "/v3/test.domain.com/aggregates/providers")
    }

    @Test("Creates correct URL for retrieving device aggregates")
    func testGetAggregateDevicesURL() throws {
        @Dependency(Stats.API.Router.self) var router

        let domain = try Domain("test.domain.com")
        let url = router.url(for: .aggregateDevices(domain: domain))
        
        #expect(url.path == "/v3/test.domain.com/aggregates/devices")
    }

    @Test("Creates correct URL for retrieving country aggregates")
    func testGetAggregateCountriesURL() throws {
        @Dependency(Stats.API.Router.self) var router

        let domain = try Domain("test.domain.com")
        let url = router.url(for: .aggregateCountries(domain: domain))
        
        #expect(url.path == "/v3/test.domain.com/aggregates/countries")
    }
}
