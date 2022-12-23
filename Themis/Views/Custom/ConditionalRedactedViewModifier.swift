//
//  ConditionalRedactedViewModifier.swift
//  Themis
//
//  Created by Andreas Cselovszky on 23.12.22.
//

import SwiftUI

struct ConditionalRedacted: ViewModifier {
    let disabled: Bool
    let reason: RedactionReasons

    func body(content: Content) -> some View {
        if disabled {
            content
        } else {
            content
                .redacted(reason: reason)
        }
    }
}

extension View {
    func redacted(_ disabled: Bool, reason: RedactionReasons) -> some View {
        modifier(ConditionalRedacted(disabled: disabled, reason: reason))
    }
}
