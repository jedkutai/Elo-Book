//
//  EventCell.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI
import Kingfisher

struct EventCell: View {
    @State var event: Event
    @State private var elementsLoaded: Bool = false
    @State private var team1: Team?
    @State private var team2: Team?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            if elementsLoaded {
                HStack {
                    Group {
                        if let team = team1 {
                            KFImage(URL(string: team.teamLogo))
                                .placeholder {
                                    Image("elo_book_app_icon5")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 25, height: 25)
                                }
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        }
                    }
                    .padding(.leading, 15)
                    
                    Spacer()
                    
                    VStack {
                        Text(event.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        
                        Text("\(DateFormatter.longDate(timestamp: event.timestamp))")
                            .font(.subheadline)
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    }
                    
                    Spacer()
                    
                    Group {
                        if let team = team2 {
                            
                            KFImage(URL(string: team.teamLogo))
                                .placeholder {
                                    Image("elo_book_app_icon5")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 25, height: 25)
                                }
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                        }
                    }
                    .padding(.trailing, 15)
                }
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(Color(.clear))
            }
            
        }
        .onAppear {
            Task {
                team1 = try await FetchService.fetchTeamById(docId: event.team1_ID)
                team2 = try await FetchService.fetchTeamById(docId: event.team2_ID)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.elementsLoaded = true // Set to true when elements are loaded
                }
            }
        }
    }
}
