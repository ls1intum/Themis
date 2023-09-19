//
//  ModelingSkeleton.swift
//  Themis
//
//  Created by Tarlan Ismayilsoy on 05.09.23.
//
// swiftlint:disable closure_body_length

import SwiftUI

struct ModelingSkeleton: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundColor(Color(UIColor.systemGray3))
                .frame(width: 230, height: 5)
                .offset(.init(width: 270, height: 100))
            
            Rectangle()
                .foregroundColor(Color(UIColor.systemGray3))
                .frame(width: 5, height: 200)
                .offset(.init(width: 50, height: 180))
            
            Rectangle()
                .foregroundColor(Color(UIColor.systemGray3))
                .frame(width: 5, height: 200)
                .offset(.init(width: 240, height: 180))
            
            Rectangle()
                .foregroundColor(Color(UIColor.systemGray3))
                .frame(width: 5, height: 200)
                .offset(.init(width: 480, height: 180))
            
            VStack(alignment: .leading, spacing: 50) {
                HStack(alignment: .top, spacing: 190) {
                    Rectangle()
                        .foregroundColor(Color(UIColor.systemGray3))
                        .frame(width: 280, height: 180)
                    
                    Rectangle()
                        .foregroundColor(Color(UIColor.systemGray3))
                        .frame(width: 150, height: 250)
                }
                
                HStack(alignment: .top, spacing: 100) {
                    Rectangle()
                        .foregroundColor(Color(UIColor.systemGray3))
                        .frame(width: 100, height: 100)

                    Rectangle()
                        .foregroundColor(Color(UIColor.systemGray3))
                        .frame(width: 100, height: 100)
                    
                    Rectangle()
                        .foregroundColor(Color(UIColor.systemGray3))
                        .frame(width: 100, height: 100)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(60)
    }
}

struct ModelingSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        ModelingSkeleton()
            .showsSkeleton(if: true)
    }
}

// swiftlint:enable closure_body_length
