//
//  SectionTitleModifier.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 21.05.23.
//

import SwiftUI

struct SectionTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textCase(.uppercase)
            .font(.system(size: 15, weight: .regular))
            .foregroundColor(.secondary)
            .padding(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top)
    }
}


extension View {
    func customSectionTitle() -> some View {
        modifier(SectionTitleModifier())
    }
}
