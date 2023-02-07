//
//  LightbulbButton.swift
//  
//
//  Created by Andreas Cselovszky on 31.01.23.
//

import UIKit
import SwiftUI

final class LightbulbButton: UIButton {
    
    let setSelectedFeedbackSuggestionId: () -> Void
    let toggleShowAddFeedback: () -> Void
    
    init(frame: CGRect, setSelectedFeedbackSuggestionId: @escaping () -> Void, toggleShowAddFeedback: @escaping () -> Void) {
        self.setSelectedFeedbackSuggestionId = setSelectedFeedbackSuggestionId
        self.toggleShowAddFeedback = toggleShowAddFeedback
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    
    private func setup() {
        let image = UIImage(systemName: "lightbulb.fill")
        setImage(image, for: .normal)
        imageView?.contentMode = .scaleAspectFit
        imageView?.tintColor = .yellow
        addTarget(self, action: #selector(self.onLightBulbTap), for: .touchUpInside)
    }
    
    @objc private func onLightBulbTap() {
        setSelectedFeedbackSuggestionId()
        toggleShowAddFeedback()
    }
}
