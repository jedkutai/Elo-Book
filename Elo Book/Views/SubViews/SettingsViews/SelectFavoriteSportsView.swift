//
//  SelectFavoriteSportsView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/28/23.
//

import SwiftUI

struct SelectFavoriteSportsView: View {
    @State var user: User
    @Binding var refresh: Bool
    
    @State private var favoriteSportsSettings: UserFavoriteSports?
    
    @State private var baseball: Bool = true
    @State private var basketball: Bool = true
    @State private var football: Bool = true
    @State private var hockey: Bool = true
    @State private var soccer: Bool = true
    
    
    @State private var swipeStarted = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                        Task {
                            try await UserService.updateUserFavoriteSportsSettings(user: user, baseball: baseball, basketball: basketball, football: football, hockey: hockey, soccer: soccer)
                            refresh.toggle()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                    
                    Spacer()
                    
                    Text("Favorite Sports")
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.clear) // invisible
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                
                if favoriteSportsSettings != nil {
                    ScrollView {
                        HStack {
                            Button {
                                baseball.toggle()
                            } label: {
                                Text("Baseball")
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                
                                Spacer()
                                
                                if baseball {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                        }
                        
                        Divider()
                            .frame(height: 1)
                        
                        HStack {
                            Button {
                                basketball.toggle()
                            } label: {
                                Text("Basketball")
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                
                                Spacer()
                                
                                if basketball {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                        }
                        
                        Divider()
                            .frame(height: 1)
                        
                        HStack {
                            Button {
                                football.toggle()
                            } label: {
                                Text("Football")
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                
                                Spacer()
                                
                                if football {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                        }
                        
                        Divider()
                            .frame(height: 1)
                        
                        HStack {
                            Button {
                                hockey.toggle()
                            } label: {
                                Text("Hockey")
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                
                                Spacer()
                                
                                if hockey {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                        }
                        
                        Divider()
                            .frame(height: 1)
                        
                        
                        HStack {
                            Button {
                                soccer.toggle()
                            } label: {
                                Text("Soccer")
                                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                
                                Spacer()
                                
                                if soccer {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                                }
                            }
                        }
                        
                        Divider()
                            .frame(height: 1)
                        
                        Text("The sports you select will appear the most on your discover page.")
                            .font(.subheadline)
                            .foregroundStyle(Color(.systemGray))
                            .multilineTextAlignment(.center)
                            .padding()
                        
                    }
                    .padding(.horizontal)
                } else {
                    Spacer()
                    ProgressView()
                }
                
                Spacer()
            }
        }
        .onAppear {
            Task {
                do {
                    favoriteSportsSettings = try await FetchService.fetchFavoriteSportsSettings(user: user)
                } catch {
                    favoriteSportsSettings = nil
                }
                
                if favoriteSportsSettings == nil {
                    try await UserService.startUserFavoriteSportsSettings(user: user)
                    favoriteSportsSettings = try await FetchService.fetchFavoriteSportsSettings(user: user)
                }
                
                if let favoriteSportsSettings = favoriteSportsSettings {
                    if let baseball = favoriteSportsSettings.baseball {
                        self.baseball = baseball
                    }
                    
                    if let basketball = favoriteSportsSettings.basketball {
                        self.basketball = basketball
                    }
                    
                    if let football = favoriteSportsSettings.football {
                        self.football = football
                    }
                    
                    if let hockey = favoriteSportsSettings.hockey {
                        self.hockey = hockey
                    }
                    
                    if let soccer = favoriteSportsSettings.soccer {
                        self.soccer = soccer
                    }
                }
            }
            
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.startLocation.y < 40 {
                        self.swipeStarted = true
                    }
                }
                .onEnded { _ in
                    self.swipeStarted = false
                    dismiss()
                }
        )
    }
}
