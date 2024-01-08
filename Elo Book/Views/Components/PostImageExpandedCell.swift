//
//  PostImageExpandedCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/7/24.
//

import SwiftUI
import Kingfisher

struct PostImageExpandedCell: View {
    let imageUrl: String
    
    @GestureState private var zoom = 1.0
//    @State private var currentZoom = 0.0
//    @State private var totalZoom = 1.0
    
    var body: some View {
        VStack {
            Spacer()
            
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFit()
//                .frame(width: UIScreen.main.bounds.width)
                .scaleEffect(zoom)
                .gesture(
                    MagnifyGesture()
                        .updating($zoom) { value, gestureState, transaction in
                            gestureState = value.magnification
                        }
                )

            
            Spacer()
        }
    }
}
