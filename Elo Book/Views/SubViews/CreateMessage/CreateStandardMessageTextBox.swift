//
//  CreateStandardMessageTextBox.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/10/24.
//

import SwiftUI

struct CreateStandardMessageTextBox: View {
    @Binding var message: String
    @Binding var photoPickerPresented: Bool
    @Binding var sendingMessage: Bool
    @ObservedObject var viewModel: UploadMessage
    @Binding var user: User
    @Binding var recievingUsers: [User]
    
    var dismiss: DismissAction
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack {
            HStack {
                if !viewModel.uiImages.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(Array(viewModel.uiImages.enumerated()), id: \.0) { index, image in
                                Button {
                                    viewModel.uiImages.remove(at: index)
                                    viewModel.messageImages.remove(at: index)
                                } label: {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 70)
                                        .padding(.leading, 1)
                                }
                            }
                        }
                    }
                    .frame(height: 70)
                    .padding(.horizontal)
                    
                    Divider()
                        .frame(height: 1)
                }
            }
            
            HStack {
                Button {
                    photoPickerPresented.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                }
                
                TextField("Message", text: $message, axis: .vertical)
                    .autocapitalization(.none)
                    .font(.footnote)
                    
                
                Spacer()
                if sendingMessage {
                    ProgressView()
                }
                
                Group {
                    if (Checks.isValidCaption(message) || (message.isEmpty && !viewModel.messageImages.isEmpty)) && !recievingUsers.isEmpty {
                        Button {
                            sendingMessage.toggle()
                            Task {
                                try await viewModel.uploadMessage(user: user, recievingUsers: recievingUsers, caption: message)
                                }
                                dismiss()
                            
                        } label: {
                            Text("Send")
                                .font(.footnote)
                                .foregroundStyle(Color(.systemBlue))
                        }
                    } else {
                        Text("Send")
                            .font(.footnote)
                            .foregroundStyle(Color(.systemGray))
                    }
                }
                .padding(.horizontal, 5)
            }
        
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal, 10)
    }
}
