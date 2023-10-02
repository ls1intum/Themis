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
        GeometryReader { geoReader in
            ZStack(alignment: .topLeading) {
                // Relationships
                Rectangle() // top vertical
                    .foregroundColor(Color(UIColor.systemGray3))
                    .frame(width: geoReader.minSide * 0.15,
                           height: geoReader.minSide * 0.003)
                    .offset(.init(width: geoReader.minSide * 0.25,
                                  height: geoReader.minSide * 0.07))
                
                Rectangle() // bottom first
                    .foregroundColor(Color(UIColor.systemGray3))
                    .frame(width: geoReader.minSide * 0.003,
                           height: geoReader.minSide * 0.08)
                    .offset(.init(width: geoReader.minSide * 0.05,
                                  height: geoReader.minSide * 0.25))
                
                Rectangle() // bottom second
                    .foregroundColor(Color(UIColor.systemGray3))
                    .frame(width: geoReader.minSide * 0.003,
                           height: geoReader.minSide * 0.08)
                    .offset(.init(width: geoReader.minSide * 0.23,
                                  height: geoReader.minSide * 0.25))
                
                Rectangle() // bottom third
                    .foregroundColor(Color(UIColor.systemGray3))
                    .frame(width: geoReader.minSide * 0.003,
                           height: geoReader.minSide * 0.08)
                    .offset(.init(width: geoReader.minSide * 0.42,
                                  height: geoReader.minSide * 0.25))

                // Classes
                VStack(alignment: .leading, spacing: geoReader.minSide * 0.07) {
                    HStack(alignment: .top, spacing: geoReader.minSide * 0.15) {
                        Rectangle()
                            .foregroundColor(Color(UIColor.systemGray3))
                            .frame(width: geoReader.minSide * 0.25,
                                   height: geoReader.minSide * 0.25)
                        
                        Rectangle()
                            .foregroundColor(Color(UIColor.systemGray3))
                            .frame(width: geoReader.minSide * 0.15,
                                   height: geoReader.minSide * 0.25)
                    }
                    
                    HStack(alignment: .top, spacing: geoReader.minSide * 0.08) {
                        Rectangle()
                            .foregroundColor(Color(UIColor.systemGray3))
                            .frame(width: geoReader.minSide * 0.1,
                                   height: geoReader.minSide * 0.1)

                        Rectangle()
                            .foregroundColor(Color(UIColor.systemGray3))
                            .frame(width: geoReader.minSide * 0.1,
                                   height: geoReader.minSide * 0.1)

                        Rectangle()
                            .foregroundColor(Color(UIColor.systemGray3))
                            .frame(width: geoReader.minSide * 0.1,
                                   height: geoReader.minSide * 0.1)
                    }
                }
            }
            .padding(.horizontal, geoReader.size.width * 0.1)
            .padding(.vertical, geoReader.size.height * 0.1)
            .showsSkeleton(if: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct ModelingSkeleton_Previews: PreviewProvider {
    static var previews: some View {
        ModelingSkeleton()
            .showsSkeleton(if: true)
    }
}

// swiftlint:enable closure_body_length
