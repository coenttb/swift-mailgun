//
//  File.swift
//  coenttb-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 10/08/2025.
//

import Foundation
import HTML
import Mailgun_Messages_Types

extension Mailgun.Messages.Send.Request {
    public init(
        from: EmailAddress,
        to: [EmailAddress],
        subject: String,
        text: String? = nil,
        cc: [EmailAddress]? = nil,
        bcc: [EmailAddress]? = nil,
        template: String? = nil,
        templateVersion: String? = nil,
        templateText: Bool? = nil,
        templateVariables: String? = nil,
        attachments: [Mailgun.Messages.Attachment.Data]? = nil,
        inline: [Mailgun.Messages.Attachment.Data]? = nil,
        tags: [String]? = nil,
        dkim: Bool? = nil,
        secondaryDkim: String? = nil,
        secondaryDkimPublic: String? = nil,
        deliveryTime: Date? = nil,
        deliveryTimeOptimizePeriod: String? = nil,
        timeZoneLocalize: String? = nil,
        testMode: Bool? = nil,
        tracking: Mailgun.Messages.Tracking.Option? = nil,
        trackingClicks: Mailgun.Messages.Tracking.Option? = nil,
        trackingOpens: Bool? = nil,
        requireTls: Bool? = nil,
        skipVerification: Bool? = nil,
        sendingIp: String? = nil,
        sendingIpPool: String? = nil,
        trackingPixelLocationTop: Bool? = nil,
        headers: [String: String]? = nil,
        variables: [String: String]? = nil,
        recipientVariables: String? = nil,
        @HTMLBuilder html: () -> String? =  { nil },
        @HTMLBuilder ampHtml: () -> String? = { nil }
    ) {
        self = .init(
            from: from,
            to: to,
            subject: subject,
            html: html(),
            text: text,
            cc: cc,
            bcc: bcc,
            ampHtml: ampHtml(),
            template: template,
            templateVersion: templateVersion,
            templateText: templateText,
            templateVariables: templateVariables,
            attachments: attachments,
            inline: inline,
            tags: tags,
            dkim: dkim,
            secondaryDkim: secondaryDkim,
            secondaryDkimPublic: secondaryDkimPublic,
            deliveryTime: deliveryTime,
            deliveryTimeOptimizePeriod: deliveryTimeOptimizePeriod,
            timeZoneLocalize: timeZoneLocalize,
            testMode: testMode,
            tracking: tracking,
            trackingClicks: trackingClicks,
            trackingOpens: trackingOpens,
            requireTls: requireTls,
            skipVerification: skipVerification,
            sendingIp: sendingIp,
            sendingIpPool: sendingIpPool,
            trackingPixelLocationTop: trackingPixelLocationTop,
            headers: headers,
            variables: variables,
            recipientVariables: recipientVariables,
        )
    }
}


