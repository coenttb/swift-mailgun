//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Dependencies
import DependenciesMacros
import Shared

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension Metrics {
    @DependencyClient
    public struct Client: Sendable {
        @DependencyEndpoint
        public var getAccountMetrics: @Sendable (_ request: Metrics.GetAccountMetrics.Request) async throws -> Metrics.GetAccountMetrics.Response
        
        @DependencyEndpoint
        public var getAccountUsageMetrics: @Sendable (_ request: Metrics.GetAccountUsageMetrics.Request) async throws -> Metrics.GetAccountUsageMetrics.Response
    }
}

extension Metrics.Client: TestDependencyKey {
    public static var testValue: Self {
        return Self(
            getAccountMetrics: { _ in
                .init(
                    items: [
                        .init(
                            dimensions: [
                                .init(
                                    dimension: "time",
                                    value: "2024-01",
                                    displayValue: "January 2024"
                                )
                            ],
                            metrics: .init(
                                acceptedCount: 100,
                                acceptedIncomingCount: 50,
                                acceptedOutgoingCount: 50,
                                deliveredSmtpCount: 95,
                                deliveredCount: 95,
                                deliveredOptimizedCount: 0,
                                deliveredHttpCount: 0,
                                storedCount: 100,
                                processedCount: 100,
                                clickedCount: 30,
                                uniqueOpenedCount: 45,
                                openedCount: 60,
                                sentCount: 100,
                                uniqueClickedCount: 25,
                                unsubscribedCount: 2,
                                complainedCount: 1,
                                temporaryFailedCount: 3,
                                permanentFailedCount: 2,
                                espBlockCount: 0,
                                webhookCount: 100,
                                failedCount: 5,
                                rateLimitCount: 0,
                                permanentFailedOptimizedCount: 0,
                                bouncedCount: 2,
                                hardBouncesCount: 1,
                                permanentFailedOldCount: 2,
                                suppressedUnsubscribedCount: 2,
                                suppressedBouncesCount: 2,
                                softBouncesCount: 1,
                                delayedFirstAttemptCount: 3,
                                deliveredFirstAttemptCount: 92,
                                deliveredSubsequentCount: 3,
                                uniqueOpenedRate: "45.00",
                                unsubscribedRate: "2.00",
                                complainedRate: "1.00",
                                delayedBounceCount: "2.00",
                                uniqueClickedRate: "25.00",
                                bounceRate: "2.00",
                                deliveredTwoPlusAttemptsCount: 3,
                                failRate: "5.00",
                                temporaryFailRate: "3.00",
                                suppressedComplaintsCount: 1,
                                permanentFailRate: "2.00",
                                delayedRate: "3.00",
                                deliveredRate: "95.00",
                                clickedRate: "30.00",
                                openedRate: "60.00"
                            )
                        )
                    ],
                    resolution: "month",
                    start: "Mon, 1 Jan 2024 00:00:00 UTC",
                    end: "Wed, 31 Jan 2024 23:59:59 UTC",
                    duration: "1m"
                )
            },
            getAccountUsageMetrics: { _ in
                .init(
                    items: [
                        .init(
                            dimensions: [
                                .init(
                                    dimension: "time",
                                    value: "2024-01",
                                    displayValue: "January 2024"
                                )
                            ],
                            metrics: .init(
                                emailValidationSingleCount: 50,
                                emailValidationCount: 100,
                                emailValidationPublicCount: 20,
                                emailValidationValidCount: 95,
                                emailValidationListCount: 30,
                                processedCount: 100,
                                emailValidationBulkCount: 20,
                                emailValidationMailjetCount: 0,
                                emailPreviewCount: 10,
                                emailValidationMailgunCount: 80,
                                linkValidationCount: 40,
                                emailPreviewFailedCount: 1,
                                linkValidationFailedCount: 2,
                                seedTestCount: 5
                            )
                        )
                    ],
                    resolution: "month",
                    start: "Mon, 1 Jan 2024 00:00:00 UTC",
                    end: "Wed, 31 Jan 2024 23:59:59 UTC",
                    duration: "1m"
                )
            }
        )
    }
}
