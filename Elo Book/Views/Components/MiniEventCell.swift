//
//  MiniEventCell.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/6/24.
//

import SwiftUI
import Kingfisher

struct MiniEventCell: View {
    @State var event: Event
    
    @State private var team1: Team?
    @State private var team2: Team?
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            HStack {
                Group {
                    if let team = team1 {
                        KFImage(URL(string: team.teamLogo))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                }
                
                Text("vs.")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .padding(.horizontal)
                
                Group {
                    if let team = team2 {
                        KFImage(URL(string: team.teamLogo))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                }
            }
            .onAppear {
                Task {
                    team1 = try await FetchService.fetchTeamById(docId: event.team1_ID)
                    team2 = try await FetchService.fetchTeamById(docId: event.team2_ID)
                }
            }
        }
    }
}
