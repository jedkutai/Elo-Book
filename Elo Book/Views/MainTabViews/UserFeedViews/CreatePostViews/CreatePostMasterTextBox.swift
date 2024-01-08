//
//  CreatePostMasterTextBox.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/6/24.
//

import SwiftUI

struct CreatePostMasterTextBox: View {
    @Binding var showEvents: Bool
    @Binding var searchText: String
    @Binding var caption: String
    @Binding var posting: Bool
    var body: some View {
        if showEvents {
            HStack {
                
                TextField("Find Events", text: $searchText, axis: .vertical)
                    .font(.subheadline)
                    
                
                Spacer()
                
            
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
        } else {
            HStack {
                
                TextField("Caption", text: $caption, axis: .vertical)
                    .font(.subheadline)
                    
                
                Spacer()
                
                if posting {
                    ProgressView()
                } else {
                    ProgressWheel(characterCount: caption.count, maxCharacterCount: 1000)
                        .padding(.trailing)
                }
                
            
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, 10)
            .padding(.bottom, 5)
        }
    }
}
