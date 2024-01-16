//
//  SelectBadgesView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/9/24.
//

import SwiftUI

struct SelectBadgesView: View {
    @State var user: User
    @Binding var refresh: Bool
    
    @State private var userBadges: UserBadgeSettings?
    
    @State private var selectedBadge = ""
    
    
    @State private var alphaTester: Bool = false
    @State private var degenerate: Bool = false
    @State private var publicFigure: Bool = false
    
    @State private var noBadges = true
    
    @State private var showEarnedBadges = true
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
                            
                            try await UserService.updateDisplayedBadge(user: user, displayedBadge: selectedBadge)
                            refresh.toggle()
                        }
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                        
                    }
                    
                    Spacer()
                    
                    Text("Badges")
                        .font(.headline)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    
                    Spacer()
                    
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color.clear)
                    
                }
                .padding(.horizontal)
                
                
                HStack {
                    Spacer()
                    
                    if showEarnedBadges {
                        Text("Earned")
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            .fontWeight(.bold)
                        
                    } else {
                        Button {
                            showEarnedBadges.toggle()
                        } label: {
                            Text("Earned")
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                
                        }
                    }
                    
                    Spacer()
                    Spacer()
                    
                    if !showEarnedBadges {
                        
                        Text("All")
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                            .fontWeight(.bold)
                    } else {
                        Button {
                            showEarnedBadges.toggle()
                        } label: {
                            Text("All")
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Divider()
                    .frame(height: 1)
                
                ScrollView(.vertical, showsIndicators: false) {
                    if showEarnedBadges {
                        if alphaTester {
                            HStack {
                                Button {
                                    selectedBadge = "alphaTester"
                                } label: {
                                    Text("Alpha Tester")
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                        .fontWeight(.semibold)
                                    
                                    AlphaTesterBadge()
                                }
                                
                                if selectedBadge == "alphaTester" {
                                    Text("(Active)")
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                }
                                
                                Spacer()
                            }
                            
                            HStack {
                                Text("Been here since the start of the app.")
                                    .foregroundStyle(Color(.systemGray))
                                    .multilineTextAlignment(.leading)
                                    
                                Spacer()
                            }
                            .padding(.bottom)
                        }
                        
                        if degenerate {
                            HStack {
                                Button {
                                    selectedBadge = "degenerate"
                                } label: {
                                    Text("Degenerate")
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                        .fontWeight(.semibold)
                                    
                                    
                                    DegenerateBadge()
                                }
                                
                                if selectedBadge == "degenerate" {
                                    Text("(Active)")
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                }
                                Spacer()
                            }
                            
                            HStack {
                                Text("Self-explanatory.")
                                    .foregroundStyle(Color(.systemGray))
                                    .multilineTextAlignment(.leading)
                                    
                                Spacer()
                            }
                            .padding(.bottom)
                        }
                        
                        if publicFigure {
                            HStack {
                                Button {
                                    selectedBadge = "publicFigure"
                                } label: {
                                    Text("Public Figure")
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                        .fontWeight(.semibold)
                                    
                                    PublicFigureBadge()
                                }
                                
                                if selectedBadge == "publicFigure" {
                                    Text("(Active)")
                                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                }
                                Spacer()
                            }
                            
                            HStack {
                                Text("Cool guy alert, wee woo wee woo.")
                                    .foregroundStyle(Color(.systemGray))
                                    .multilineTextAlignment(.leading)
                                    
                                Spacer()
                            }
                            .padding(.bottom)
                        }
                        
                        if noBadges {
                            Text("No Badges???")
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                .font(.largeTitle)
                                .padding()
                        }
                        
                    } else {
                        HStack {
                            Text("Alpha Tester")
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                .fontWeight(.semibold)
                            
                            AlphaTesterBadge()
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text("Been here since the start of the app.")
                                .foregroundStyle(Color(.systemGray))
                                .multilineTextAlignment(.leading)
                                
                            Spacer()
                        }
                        .padding(.bottom)
                        
                        HStack {
                            Text("Degenerate")
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                .fontWeight(.semibold)
                            
                            
                            DegenerateBadge()
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text("Self-explanatory.")
                                .foregroundStyle(Color(.systemGray))
                                .multilineTextAlignment(.leading)
                                
                            Spacer()
                        }
                        .padding(.bottom)
                        
                        HStack {
                            Text("Public Figure")
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                                .fontWeight(.semibold)
                            
                            PublicFigureBadge()
                            
                            Spacer()
                        }
                        
                        HStack {
                            Text("Cool guy alert, wee woo wee woo.")
                                .foregroundStyle(Color(.systemGray))
                                .multilineTextAlignment(.leading)
                                
                            Spacer()
                        }
                        .padding(.bottom)
                        
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            if let displayedBadge = user.displayedBadge {
                self.selectedBadge = displayedBadge
            }
            
            Task {
                do {
                    userBadges = try await FetchService.fetchUserBadges(user: user)
                } catch {
                    userBadges = nil
                }
                
                if userBadges == nil {
                    try await UserService.startUserBadges(user: user)
                    userBadges = try await FetchService.fetchUserBadges(user: user)
                }
                
                if let userBadges = userBadges {
                    if let publicFigure = userBadges.publicFigure {
                        self.publicFigure = publicFigure
                        if publicFigure {
                            noBadges = false
                        }
                    }
                    
                    if let alphaTester = userBadges.alphaTester {
                        self.alphaTester = alphaTester
                        if alphaTester {
                            noBadges = false
                        }
                    }
                    
                    if let degenerate = userBadges.degenerate {
                        self.degenerate = degenerate
                        if degenerate {
                            noBadges = false
                        }
                    }
                    
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.startLocation.y < 20 {
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

