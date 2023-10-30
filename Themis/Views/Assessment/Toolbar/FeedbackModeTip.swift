//
//  FeedbackModeTip.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 17.10.23.
//

import TipKit

struct FeedbackModeTip: Tip {
    var title: Text {
        Text("Toggle Referenced Feedback Mode")
    }
    
    var message: Text? {
        Text("You can refer to individual parts of the submission to provide more detailed feedback")
    }
    
    var image: Image? {
        Image(systemName: "hand.tap")
    }
    
    var options: [TipOption] {
        Tips.MaxDisplayCount(1)
    }
}
