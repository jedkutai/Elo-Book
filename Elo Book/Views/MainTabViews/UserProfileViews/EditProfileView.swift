//
//  EditProfileView.swift
//  EloBookv1
//
//  Created by Jed Kutai on 12/24/23.
//

import SwiftUI

struct EditProfileView: View {
    @State var user: User
    @State var fullname: String
    @State var bio: String
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var uploadProfileImage = UploadProfileImage()
    
    @State private var isCropViewPresented = false
    @State private var updatingProfile = false
    @State private var imagePickerPresented = false
    @State private var showCrop = false
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        editProfile
    }
    
    var editProfile: some View {
        NavigationStack {
            VStack {
                if let image = uploadProfileImage.uiImage {
                    VStack {
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 10)) // Adjust the corner radius as needed
                            .overlay(
                                RoundedRectangle(cornerRadius: 10) // Same corner radius as above
                                    .stroke(Color.gray, lineWidth: 3) // Customize border color and width
                            )
                        
                    }
                } else {
                    SquareProfilePicture(user: user, size: .large)
                }
                
                Button {
                    imagePickerPresented.toggle()
                } label: {
                    Text("Change Photo")
                        .foregroundStyle(Color(.systemBlue))
                        .padding(.bottom)
                }
                
                HStack {
                    Text("Name: ")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    TextField("Name...", text: $fullname, axis: .vertical)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Bio: ")
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    
                    TextField("Bio...", text: $bio, axis: .vertical)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(.horizontal)
                
                Spacer()
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if updatingProfile {
                        ProgressView()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if fullname != user.fullname || bio != user.bio || uploadProfileImage.selectedImage != nil {
                        Button {
                            updatingProfile = true
                            Task {
                                if uploadProfileImage.selectedImage != nil {
                                    try await uploadProfileImage.uploadProfileImage(user: user)
                                }
                                
                                if fullname != user.fullname {
                                    try await UserService.changeFullname(uid: user.id, newFullname: fullname)
                                }
                                
                                if bio != user.bio {
                                    try await UserService.changeBio(uid: user.id, newBio: bio)
                                }
                            }
                            dismiss()
                        } label: {
                            Text("Update")
                                .foregroundStyle(Color(.systemBlue))
                        }
                    } else {
                        Text("Update")
                            .foregroundStyle(Color(.systemRed))
                    }
                }
            }
        }
        .photosPicker(isPresented: $imagePickerPresented, selection: $uploadProfileImage.selectedImage)
        .sheet(isPresented: $isCropViewPresented) {
            CropProfileImageViewController(image: $uploadProfileImage.uiImage)
        }
        .onChange(of: uploadProfileImage.selectedImage) {
           showCrop = true
        }
        .onChange(of: uploadProfileImage.uiImage) {
            if showCrop {
                isCropViewPresented = true
                showCrop = false
            }
        }
    }
    
}
