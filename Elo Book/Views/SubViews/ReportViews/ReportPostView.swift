//
//  ReportPostView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/18/24.
//

import SwiftUI

struct ReportPostView: View {
    @State var user: User
    @State var postUser: User
    @State var post: Post
    
    
    @State private var harassment: Bool = false
    @State private var violence: Bool = false
    @State private var nudity: Bool = false
    @State private var scam: Bool = false
    @State private var impersonation: Bool = false
    @State private var slurs: Bool = false
    @State private var other: Bool = false
    @State private var additionalComments = ""
    
    
    @State private var submitting: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    Text("Select all that apply.")
                        .foregroundStyle(Color(.systemGray))
                    
                    ReportCategory(toggle: $harassment, submitting: $submitting, toggleName: "Harassment")
                    ReportCategory(toggle: $violence, submitting: $submitting, toggleName: "Violence")
                    ReportCategory(toggle: $nudity, submitting: $submitting, toggleName: "Nudity")
                    ReportCategory(toggle: $scam, submitting: $submitting, toggleName: "Scam")
                    ReportCategory(toggle: $impersonation, submitting: $submitting, toggleName: "Impersonation")
                    ReportCategory(toggle: $slurs, submitting: $submitting, toggleName: "Impersonation")
                    ReportCategory(toggle: $other, submitting: $submitting, toggleName: "Other")
                    
                }
                .scrollDismissesKeyboard(.immediately)
                
                
                TextField("Message", text: $additionalComments, axis: .vertical)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
                    )
                    .padding(.bottom, 10)
                    .padding(.horizontal, 10)
               
                
            }
            .navigationTitle("Report Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if self.canSubmitReport() {
                    ToolbarItem(placement: .topBarTrailing) {
                        if submitting {
                            ProgressView("Submitting...")
                        } else {
                            Button {
                                submitting = true
                                Task {
                                    try await ReportService.reportPost(user: user, postUser: postUser, post: post, harassment: harassment, violence: violence, nudity: nudity, scam: scam, impersonation: impersonation, slurs: slurs, other: other, additionalComments: additionalComments)
                                    
                                    
                                    dismiss()
                                }
                            } label: {
                                Text("Submit")
                                    .foregroundStyle(Color(.systemBlue))
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    private func canSubmitReport() -> Bool {
        return self.harassment || self.violence || self.nudity || self.scam || self.impersonation || self.slurs || self.other
    }
    
}
