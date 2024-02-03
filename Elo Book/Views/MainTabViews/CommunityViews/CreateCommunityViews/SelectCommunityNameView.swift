//
//  SelectCommunityNameView.swift
//  Elo Book
//
//  Created by Jed Kutai on 2/2/24.
//

import SwiftUI

struct SelectCommunityNameView: View {
    @Binding var user: User
    @Binding var refreshCommunitiesView: Bool
    
    @State private var communityName: String = ""
    @State private var creatingCommunity: Bool = false
    @State private var failed: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                
                Image(systemName: "rectangle.3.group")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .foregroundStyle(Color(.systemGray))
                
                Text(failed ? "Failed to create community, please try again." : "")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(.systemRed))
                    .font(.footnote)
                
                TextField("Name", text: $communityName)
                    .modifier(IGTextFieldModifier())
                
                
                if Checks.isValidCommunityName(communityName) && !creatingCommunity { // if validcommunity name
                    Button {
                        hideKeyboard()
                        creatingCommunity = true
                        Task {
                            do {
                                let communityNameSubmission = communityName
                                communityName = ""
                                
                                try await CommunityService.createCommunity(user: user, communityName: communityNameSubmission)
                                dismiss()
                                refreshCommunitiesView.toggle()
                            } catch {
                                failed = true
                                creatingCommunity = false
                            }
                        }
                        
                    } label: {
                        Text("Continue")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(.systemBlue))
                            .padding(24)
                    }
                } else if creatingCommunity {
                    ProgressView()
                        .padding(24)
                } else {
                    Text("Continue")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(.systemGray))
                        .padding(24)
                }
                
                
            }
            .navigationTitle("Name Your Community")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal)
            .onSubmit {
                hideKeyboard()
            }
            .onChange(of: communityName) {
                if failed {
                    failed = false
                }
            }
        }
    }
}

//#Preview {
//    SelectCommunityName()
//}
