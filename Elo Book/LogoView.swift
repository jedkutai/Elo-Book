//
//  LogoView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct LogoView: View {
    private let logoWidth = UIScreen.main.bounds.width * 0.5
    @State private var showProgressView = false
    @Namespace var namespace
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                Image(colorScheme == .dark ? Theme.blackLogoString : Theme.whiteLogoString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoWidth)
                
                
                
                if showProgressView {
                    ProgressView("Degenerating...")
                        .matchedGeometryEffect(id: "Degenerating", in: namespace)
                        .scaledToFit()
                        .frame(height: 50)
                } else {
                    Text("")
                        .frame(height: 50)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showProgressView = true
                }
            }
        }
        
    }
}


#Preview {
    LogoView()
}
