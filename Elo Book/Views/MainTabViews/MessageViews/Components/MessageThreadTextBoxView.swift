//
//  MessageThreadTextBoxView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/11/24.
//

import SwiftUI

struct MessageThreadTextBoxView: View {
    @Binding var photoPickerPresented: Bool
    @Binding var sendingMessage: Bool
    @Binding var message: String
    @Binding var user: User
    @State var users: [User]
    @Binding var refresh: Bool
    @ObservedObject var viewModel: UploadMessage
    
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
                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                }
                
                TextField("Message", text: $message, axis: .vertical)
                    .font(.footnote)
                    
                
                Spacer()
                if sendingMessage {
                    ProgressView()
                }
                
                Group {
                    if (Checks.isValidCaption(message) || (message.isEmpty && !viewModel.messageImages.isEmpty)) && !users.isEmpty {
                        Button {
                            sendingMessage.toggle()
                            Task {
                                try await viewModel.uploadMessage(user: user, recievingUsers: users, caption: message)
                                message = ""
                                viewModel.messageImages = []
                                viewModel.uiImages = []
                                sendingMessage.toggle()
                                refresh.toggle()
                                }
                            
                            
                            
                            
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
