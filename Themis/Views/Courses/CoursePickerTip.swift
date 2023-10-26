//
//  CoursePickerTip.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 17.10.23.
//

import TipKit

struct CoursePickerTip: Tip {
    var title: Text {
        Text("Change the Course")
    }
    
    var message: Text? {
        Text("Choose the course where you want to perform assessments")
    }
    
    var image: Image? {
        Image(systemName: "rectangle.2.swap")
    }
    
    var options: [TipOption] {
        Tips.MaxDisplayCount(1)
    }
}
