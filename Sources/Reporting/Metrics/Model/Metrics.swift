//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 24/12/2024.
//

import Foundation

public enum Metrics {}

// MARK: - GetAccountMetrics
extension Metrics {
    public enum GetAccountMetrics {}
}

extension Metrics.GetAccountMetrics {
    public struct Request: Sendable, Codable, Equatable {
        public let start: String
        public let end: String
        public let resolution: String
        public let duration: String
        public let dimensions: [String]
        public let metrics: [String]
        public let filter: Metrics.Filter
        public let includeSubaccounts: Bool
        public let includeAggregates: Bool
        
        public init(
            start: String,
            end: String,
            resolution: String,
            duration: String,
            dimensions: [String],
            metrics: [String],
            filter: Metrics.Filter,
            includeSubaccounts: Bool,
            includeAggregates: Bool
        ) {
            self.start = start
            self.end = end
            self.resolution = resolution
            self.duration = duration
            self.dimensions = dimensions
            self.metrics = metrics
            self.filter = filter
            self.includeSubaccounts = includeSubaccounts
            self.includeAggregates = includeAggregates
        }
        
        private enum CodingKeys: String, CodingKey {
            case start
            case end
            case resolution
            case duration
            case dimensions
            case metrics
            case filter
            case includeSubaccounts = "include_subaccounts"
            case includeAggregates = "include_aggregates"
        }
    }
    
    public struct Response: Sendable, Codable, Equatable {
        public let items: [Metrics.MetricsItem]
        public let resolution: String
        public let start: String
        public let end: String
        public let duration: String
        
        public init(
            items: [Metrics.MetricsItem],
            resolution: String,
            start: String,
            end: String,
            duration: String
        ) {
            self.items = items
            self.resolution = resolution
            self.start = start
            self.end = end
            self.duration = duration
        }
    }
}

// MARK: - GetAccountUsageMetrics
extension Metrics {
    public enum GetAccountUsageMetrics {}
}

extension Metrics.GetAccountUsageMetrics {
    public struct Request: Sendable, Codable, Equatable {
        public let start: String
        public let end: String
        public let resolution: String
        public let duration: String
        public let dimensions: [String]
        public let metrics: [String]
        public let filter: Metrics.Filter
        public let includeSubaccounts: Bool
        public let includeAggregates: Bool
        
        public init(
            start: String,
            end: String,
            resolution: String,
            duration: String,
            dimensions: [String],
            metrics: [String],
            filter: Metrics.Filter,
            includeSubaccounts: Bool,
            includeAggregates: Bool
        ) {
            self.start = start
            self.end = end
            self.resolution = resolution
            self.duration = duration
            self.dimensions = dimensions
            self.metrics = metrics
            self.filter = filter
            self.includeSubaccounts = includeSubaccounts
            self.includeAggregates = includeAggregates
        }
        
        private enum CodingKeys: String, CodingKey {
            case start
            case end
            case resolution
            case duration
            case dimensions
            case metrics
            case filter
            case includeSubaccounts = "include_subaccounts"
            case includeAggregates = "include_aggregates"
        }
    }
    
    public struct Response: Sendable, Codable, Equatable {
        public let items: [Metrics.UsageMetricsItem]
        public let resolution: String
        public let start: String
        public let end: String
        public let duration: String
        
        public init(
            items: [Metrics.UsageMetricsItem],
            resolution: String,
            start: String,
            end: String,
            duration: String
        ) {
            self.items = items
            self.resolution = resolution
            self.start = start
            self.end = end
            self.duration = duration
        }
    }
}

// MARK: - Shared Models
extension Metrics {
    public struct Filter: Sendable, Codable, Equatable {
        public let and: [FilterCondition]
        
        public init(and: [FilterCondition]) {
            self.and = and
        }
        
        private enum CodingKeys: String, CodingKey {
            case and = "AND"
        }
    }
    
    public struct FilterCondition: Sendable, Codable, Equatable {
        public let attribute: String
        public let comparator: String
        public let values: [FilterValue]
        
        public init(
            attribute: String,
            comparator: String,
            values: [FilterValue]
        ) {
            self.attribute = attribute
            self.comparator = comparator
            self.values = values
        }
    }
    
    public struct FilterValue: Sendable, Codable, Equatable {
        public let label: String
        public let value: String
        
        public init(label: String, value: String) {
            self.label = label
            self.value = value
        }
    }
    
    public struct Dimension: Sendable, Codable, Equatable {
        public let dimension: String
        public let value: String
        public let displayValue: String
        
        public init(
            dimension: String,
            value: String,
            displayValue: String
        ) {
            self.dimension = dimension
            self.value = value
            self.displayValue = displayValue
        }
        
        private enum CodingKeys: String, CodingKey {
            case dimension
            case value
            case displayValue = "display_value"
        }
    }
    
    public struct MetricsItem: Sendable, Codable, Equatable {
        public let dimensions: [Dimension]
        public let metrics: AccountMetrics
        
        public init(
            dimensions: [Dimension],
            metrics: AccountMetrics
        ) {
            self.dimensions = dimensions
            self.metrics = metrics
        }
    }
    
    public struct UsageMetricsItem: Sendable, Codable, Equatable {
        public let dimensions: [Dimension]
        public let metrics: UsageMetrics
        
        public init(
            dimensions: [Dimension],
            metrics: UsageMetrics
        ) {
            self.dimensions = dimensions
            self.metrics = metrics
        }
    }
    
    public struct AccountMetrics: Sendable, Codable, Equatable {
        public let acceptedCount: Int64
        public let acceptedIncomingCount: Int64
        public let acceptedOutgoingCount: Int64
        public let deliveredSmtpCount: Int64
        public let deliveredCount: Int64
        public let deliveredOptimizedCount: Int64
        public let deliveredHttpCount: Int64
        public let storedCount: Int64
        public let processedCount: Int64
        public let clickedCount: Int64
        public let uniqueOpenedCount: Int64
        public let openedCount: Int64
        public let sentCount: Int64
        public let uniqueClickedCount: Int64
        public let unsubscribedCount: Int64
        public let complainedCount: Int64
        public let temporaryFailedCount: Int64
        public let permanentFailedCount: Int64
        public let espBlockCount: Int64
        public let webhookCount: Int64
        public let failedCount: Int64
        public let rateLimitCount: Int64
        public let permanentFailedOptimizedCount: Int64
        public let bouncedCount: Int64
        public let hardBouncesCount: Int64
        public let permanentFailedOldCount: Int64
        public let suppressedUnsubscribedCount: Int64
        public let suppressedBouncesCount: Int64
        public let softBouncesCount: Int64
        public let delayedFirstAttemptCount: Int64
        public let deliveredFirstAttemptCount: Int64
        public let deliveredSubsequentCount: Int64
        public let uniqueOpenedRate: String
        public let unsubscribedRate: String
        public let complainedRate: String
        public let delayedBounceCount: String
        public let uniqueClickedRate: String
        public let bounceRate: String
        public let deliveredTwoPlusAttemptsCount: Int64
        public let failRate: String
        public let temporaryFailRate: String
        public let suppressedComplaintsCount: Int64
        public let permanentFailRate: String
        public let delayedRate: String
        public let deliveredRate: String
        public let clickedRate: String
        public let openedRate: String
        
        private enum CodingKeys: String, CodingKey {
            case acceptedCount = "accepted_count"
            case acceptedIncomingCount = "accepted_incoming_count"
            case acceptedOutgoingCount = "accepted_outgoing_count"
            case deliveredSmtpCount = "delivered_smtp_count"
            case deliveredCount = "delivered_count"
            case deliveredOptimizedCount = "delivered_optimized_count"
            case deliveredHttpCount = "delivered_http_count"
            case storedCount = "stored_count"
            case processedCount = "processed_count"
            case clickedCount = "clicked_count"
            case uniqueOpenedCount = "unique_opened_count"
            case openedCount = "opened_count"
            case sentCount = "sent_count"
            case uniqueClickedCount = "unique_clicked_count"
            case unsubscribedCount = "unsubscribed_count"
            case complainedCount = "complained_count"
            case temporaryFailedCount = "temporary_failed_count"
            case permanentFailedCount = "permanent_failed_count"
            case espBlockCount = "esp_block_count"
            case webhookCount = "webhook_count"
            case failedCount = "failed_count"
            case rateLimitCount = "rate_limit_count"
            case permanentFailedOptimizedCount = "permanent_failed_optimized_count"
            case bouncedCount = "bounced_count"
            case hardBouncesCount = "hard_bounces_count"
            case permanentFailedOldCount = "permanent_failed_old_count"
            case suppressedUnsubscribedCount = "suppressed_unsubscribed_count"
            case suppressedBouncesCount = "suppressed_bounces_count"
            case softBouncesCount = "soft_bounces_count"
            case delayedFirstAttemptCount = "delayed_first_attempt_count"
            case deliveredFirstAttemptCount = "delivered_first_attempt_count"
            case deliveredSubsequentCount = "delivered_subsequent_count"
            case uniqueOpenedRate = "unique_opened_rate"
            case unsubscribedRate = "unsubscribed_rate"
            case complainedRate = "complained_rate"
            case delayedBounceCount = "delayed_bounce_count"
            case uniqueClickedRate = "unique_clicked_rate"
            case bounceRate = "bounce_rate"
            case deliveredTwoPlusAttemptsCount = "delivered_two_plus_attempts_count"
            case failRate = "fail_rate"
            case temporaryFailRate = "temporary_fail_rate"
            case suppressedComplaintsCount = "suppressed_complaints_count"
            case permanentFailRate = "permanent_fail_rate"
            case delayedRate = "delayed_rate"
            case deliveredRate = "delivered_rate"
            case clickedRate = "clicked_rate"
            case openedRate = "opened_rate"
        }
        
        public init(
            acceptedCount: Int64,
            acceptedIncomingCount: Int64,
            acceptedOutgoingCount: Int64,
            deliveredSmtpCount: Int64,
            deliveredCount: Int64,
            deliveredOptimizedCount: Int64,
            deliveredHttpCount: Int64,
            storedCount: Int64,
            processedCount: Int64,
            clickedCount: Int64,
            uniqueOpenedCount: Int64,
            openedCount: Int64,
            sentCount: Int64,
            uniqueClickedCount: Int64,
            unsubscribedCount: Int64,
            complainedCount: Int64,
            temporaryFailedCount: Int64,
            permanentFailedCount: Int64,
            espBlockCount: Int64,
            webhookCount: Int64,
            failedCount: Int64,
            rateLimitCount: Int64,
            permanentFailedOptimizedCount: Int64,
            bouncedCount: Int64,
            hardBouncesCount: Int64,
            permanentFailedOldCount: Int64,
            suppressedUnsubscribedCount: Int64,
            suppressedBouncesCount: Int64,
            softBouncesCount: Int64,
            delayedFirstAttemptCount: Int64,
            deliveredFirstAttemptCount: Int64,
            deliveredSubsequentCount: Int64,
            uniqueOpenedRate: String,
            unsubscribedRate: String,
            complainedRate: String,
            delayedBounceCount: String,
            uniqueClickedRate: String,
            bounceRate: String,
            deliveredTwoPlusAttemptsCount: Int64,
            failRate: String,
            temporaryFailRate: String,
            suppressedComplaintsCount: Int64,
            permanentFailRate: String,
            delayedRate: String,
            deliveredRate: String,
            clickedRate: String,
            openedRate: String
        ) {
            self.acceptedCount = acceptedCount
            self.acceptedIncomingCount = acceptedIncomingCount
            self.acceptedOutgoingCount = acceptedOutgoingCount
            self.deliveredSmtpCount = deliveredSmtpCount
            self.deliveredCount = deliveredCount
            self.deliveredOptimizedCount = deliveredOptimizedCount
            self.deliveredHttpCount = deliveredHttpCount
            self.storedCount = storedCount
            self.processedCount = processedCount
            self.clickedCount = clickedCount
            self.uniqueOpenedCount = uniqueOpenedCount
            self.openedCount = openedCount
            self.sentCount = sentCount
            self.uniqueClickedCount = uniqueClickedCount
            self.unsubscribedCount = unsubscribedCount
            self.complainedCount = complainedCount
            self.temporaryFailedCount = temporaryFailedCount
            self.permanentFailedCount = permanentFailedCount
            self.espBlockCount = espBlockCount
            self.webhookCount = webhookCount
            self.failedCount = failedCount
            self.rateLimitCount = rateLimitCount
            self.permanentFailedOptimizedCount = permanentFailedOptimizedCount
            self.bouncedCount = bouncedCount
            self.hardBouncesCount = hardBouncesCount
            self.permanentFailedOldCount = permanentFailedOldCount
            self.suppressedUnsubscribedCount = suppressedUnsubscribedCount
            self.suppressedBouncesCount = suppressedBouncesCount
            self.softBouncesCount = softBouncesCount
            self.delayedFirstAttemptCount = delayedFirstAttemptCount
            self.deliveredFirstAttemptCount = deliveredFirstAttemptCount
            self.deliveredSubsequentCount = deliveredSubsequentCount
            self.uniqueOpenedRate = uniqueOpenedRate
            self.unsubscribedRate = unsubscribedRate
            self.complainedRate = complainedRate
            self.delayedBounceCount = delayedBounceCount
            self.uniqueClickedRate = uniqueClickedRate
            self.bounceRate = bounceRate
            self.deliveredTwoPlusAttemptsCount = deliveredTwoPlusAttemptsCount
            self.failRate = failRate
            self.temporaryFailRate = temporaryFailRate
            self.suppressedComplaintsCount = suppressedComplaintsCount
            self.permanentFailRate = permanentFailRate
            self.delayedRate = delayedRate
            self.deliveredRate = deliveredRate
            self.clickedRate = clickedRate
            self.openedRate = openedRate
        }
    }
}

public struct UsageMetrics: Sendable, Codable, Equatable {
    public let emailValidationSingleCount: Int64
    public let emailValidationCount: Int64
    public let emailValidationPublicCount: Int64
    public let emailValidationValidCount: Int64
    public let emailValidationListCount: Int64
    public let processedCount: Int64
    public let emailValidationBulkCount: Int64
    public let emailValidationMailjetCount: Int64
    public let emailPreviewCount: Int64
    public let emailValidationMailgunCount: Int64
    public let linkValidationCount: Int64
    public let emailPreviewFailedCount: Int64
    public let linkValidationFailedCount: Int64
    public let seedTestCount: Int64
    
    private enum CodingKeys: String, CodingKey {
        case emailValidationSingleCount = "email_validation_single_count"
        case emailValidationCount = "email_validation_count"
        case emailValidationPublicCount = "email_validation_public_count"
        case emailValidationValidCount = "email_validation_valid_count"
        case emailValidationListCount = "email_validation_list_count"
        case processedCount = "processed_count"
        case emailValidationBulkCount = "email_validation_bulk_count"
        case emailValidationMailjetCount = "email_validation_mailjet_count"
        case emailPreviewCount = "email_preview_count"
        case emailValidationMailgunCount = "email_validation_mailgun_count"
        case linkValidationCount = "link_validation_count"
        case emailPreviewFailedCount = "email_preview_failed_count"
        case linkValidationFailedCount = "link_validation_failed_count"
        case seedTestCount = "seed_test_count"
    }
    
    public init(
        emailValidationSingleCount: Int64,
        emailValidationCount: Int64,
        emailValidationPublicCount: Int64,
        emailValidationValidCount: Int64,
        emailValidationListCount: Int64,
        processedCount: Int64,
        emailValidationBulkCount: Int64,
        emailValidationMailjetCount: Int64,
        emailPreviewCount: Int64,
        emailValidationMailgunCount: Int64,
        linkValidationCount: Int64,
        emailPreviewFailedCount: Int64,
        linkValidationFailedCount: Int64,
        seedTestCount: Int64
    ) {
        self.emailValidationSingleCount = emailValidationSingleCount
        self.emailValidationCount = emailValidationCount
        self.emailValidationPublicCount = emailValidationPublicCount
        self.emailValidationValidCount = emailValidationValidCount
        self.emailValidationListCount = emailValidationListCount
        self.processedCount = processedCount
        self.emailValidationBulkCount = emailValidationBulkCount
        self.emailValidationMailjetCount = emailValidationMailjetCount
        self.emailPreviewCount = emailPreviewCount
        self.emailValidationMailgunCount = emailValidationMailgunCount
        self.linkValidationCount = linkValidationCount
        self.emailPreviewFailedCount = emailPreviewFailedCount
        self.linkValidationFailedCount = linkValidationFailedCount
        self.seedTestCount = seedTestCount
    }
}

