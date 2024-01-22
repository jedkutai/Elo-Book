//
//  FirstOpenView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/23/23.
//

import SwiftUI

struct FirstOpenView: View {
    private let logoWidth = UIScreen.main.bounds.width * 0.5
    @EnvironmentObject var x: X
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                Image(colorScheme == .dark ? Theme.blackLogoString : Theme.whiteLogoString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoWidth)
                
                HStack {
                    Text("First time?")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    NavigationLink {
                        CreateAccountControllerView().navigationBarBackButtonHidden()
                    } label: {
                        Text("Create Account")
                            .foregroundStyle(Color(.systemBlue))
                            
                    }
                }
                .font(.title3)
                
                HStack {
                    Text("Repeat offender?")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    NavigationLink {
                        LoginControllerView().navigationBarBackButtonHidden()
                    } label: {
                        Text("Login")
                            .foregroundStyle(Color(.systemBlue))
                    }
                }
                .font(.title3)
                
                Spacer()
            }
            .onAppear {
                x.clearAll()
                
            }
        }
    }
}

#Preview {
    FirstOpenView()
}
