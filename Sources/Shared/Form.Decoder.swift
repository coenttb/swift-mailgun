//
//  File.swift
//  swift-mailgun
//
//  Created by Coen ten Thije Boonkkamp on 02/08/2025.
//

import Foundation
import ServerFoundation

extension Form.Decoder {
    public static var mailgun: Form.Decoder { Form.Decoder(parsingStrategy: .bracketsWithIndices) }
}
