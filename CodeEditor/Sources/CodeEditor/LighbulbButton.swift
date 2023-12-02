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
        self.backgroundColor = UIColor(netHex: 0xB54EFE)
        self.layer.cornerRadius = 6
        
        let image = UIImage(named: "SuggestedFeedbackSymbol")?.withRenderingMode(.alwaysTemplate)
        let customImgView = UIImageView()
        customImgView.image = image
        customImgView.tintColor = .white
        customImgView.contentMode = .scaleAspectFit
        self.addSubview(customImgView)
        
        customImgView.translatesAutoresizingMaskIntoConstraints = false
        customImgView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        customImgView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        customImgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5) .isActive = true
        customImgView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6) .isActive = true
        
        addTarget(self, action: #selector(self.onLightBulbTap), for: .touchUpInside)
    }
    
    @objc private func onLightBulbTap() {
        setSelectedFeedbackSuggestionId()
        toggleShowAddFeedback()
    }
}

#Preview {
    LightbulbButton(frame: .init(x: 0, y: 0, width: 350, height: 350),
                    setSelectedFeedbackSuggestionId: {},
                    toggleShowAddFeedback: {})
}
