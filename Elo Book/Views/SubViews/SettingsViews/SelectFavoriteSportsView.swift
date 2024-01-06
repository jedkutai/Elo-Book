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
    
    @State var userFavorites: [String] = []
    @State var selectedFavorites: [String] = []
    @State private var allSports: [String] = ["Baseball", "Basketball", "Football", "Hockey", "Soccer"]
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                    
                    Spacer()
                    
                    Text("Favorite Sports")
                        .font(.headline)
                    
                    Spacer()
                    
                    if userFavorites != selectedFavorites && !selectedFavorites.isEmpty {
                        Button {
                            dismiss()
                            Task {
                                try await UserService.updateUserFavorites(user: user, favorites: selectedFavorites)
                            }
                            refresh.toggle()
                        } label: {
                            Text("Update")
                                .foregroundStyle(Color(.systemBlue))
                        }
                    } else {
                        Text("Update")
                            .foregroundStyle(Color(.systemRed))
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                
                ScrollView {
                    ForEach(allSports, id: \.self) { sport in
                        if let indexToRemove = selectedFavorites.firstIndex(of: sport) {
                            Button {
                                selectedFavorites.remove(at: indexToRemove)
                            } label: {
                                HStack {
                                    Text(sport)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(.green))
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            Button {
                                selectedFavorites.append(sport)
                                selectedFavorites.sort()
                            } label: {
                                HStack {
                                    
                                    Text(sport)
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                        }
                        Divider()
                            .frame(height: 1)
                    }
                    
                    HStack {
                        Spacer()
                        Text("The sports you select will appear the most on your discover page.")
                            .font(.subheadline)
                            .foregroundStyle(Color(.systemGray))
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            if let favorites = user.favorites {
                userFavorites = favorites
                selectedFavorites = favorites
            }
        }
    }
}
