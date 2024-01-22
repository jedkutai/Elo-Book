//
//  TermsOfServiceView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/22/24.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Binding var user: User
    
    @State private var acceptTerms = false
    @State private var submitting = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                Text("In order to continue, you must accept the updated terms of service.")
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    
                Link("View", destination: URL(string: "https://www.elobook.org/app-terms-of-service")!)
                    .foregroundStyle(Color(.systemBlue))
                
                Spacer()
                
                Button {
                    acceptTerms.toggle()
                } label: {
                    Label("Accept Terms of Service", systemImage: acceptTerms ? "checkmark.square.fill" : "square")
                        .font(.footnote)
                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                }
                
            }
            .navigationTitle("Terms of Service")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        FirstOpenView().navigationBarBackButtonHidden()
                    } label: {
                        Text("Logout")
                            .foregroundStyle(Color(.systemRed))
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if acceptTerms {
                        Button {
                            Task {
                                submitting = true
                                try await UserService.acceptTermsOfService(user: user)
                                user = try await FetchService.fetchUserById(withUid: user.id)
                                dismiss()
                            }
                        } label: {
                            Text("Continue")
                                .foregroundStyle(Color(.systemBlue))
                        }
                    } else if submitting {
                        ProgressView()
                    } else {
                        Text("Continue")
                            .foregroundStyle(Color(.systemGray))
                    }
                }
            }
        }
    }
}
