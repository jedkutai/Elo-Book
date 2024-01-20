//
//  NewUserWelcomeView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/8/24.
//

import SwiftUI

struct NewUserWelcomeView: View {
    @State private var phase = 0
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            Text("Gambling problem? Call 1-800-GAMBLER.")
                .font(.footnote)
                .foregroundStyle(Color(.systemGray))
                .multilineTextAlignment(.center)
            Spacer()
            if phase == 0 {
                ProgressView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            phase += 1
                        }
                    }
            } else if phase == 1 {
                phase1
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            phase += 1
                        }
                    }
            } else if phase == 2 {
                phase2
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            phase += 1
                        }
                    }
            } else if phase == 3 {
                phase3
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            dismiss()
                        }
                    }
            }
            
            Spacer()
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Text("Skip")
                        .foregroundStyle(Color(.systemGray))
                }
            }
            
        }
        .padding(.horizontal, 50)
        .multilineTextAlignment(.center)
    }
    
    var phase1: some View {
        Text("Children day trade.")
            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
    
    var phase2: some View {
        Text("Adults put the rent on an 8 leg parly.")
            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
    
    var phase3: some View {
        Text("We are the home of adults.")
            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
    
}

#Preview {
    NewUserWelcomeView()
}
