//
//  AddContactsView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/14/24.
//

import SwiftUI
import Contacts
import Combine
import UIKit

// causes app to crash, needs fix

struct AddContactsView: View {
    @Binding var user: User
    
    @State private var contacts: [CNContact] = []
    
    
    @State private var loadingContacts = true
    @State private var allowedAccess = false
    @State private var canContinue = true
    @State private var phoneNumber = ""
    @State private var searchText = ""
    @State private var navigationTitle = ""
    
    var filteredContacts: [CNContact] {
        guard !searchText.isEmpty else { return contacts }
        return contacts.filter { contact in
            return contact.givenName.localizedCaseInsensitiveContains(searchText) || contact.familyName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private let textBoxWidth = UIScreen.main.bounds.width * 0.5
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        NavigationStack {
            Group {
                if loadingContacts {
                    loadingPage
                } else {
                    if allowedAccess {
                        if user.phoneNumber == nil {
                            addPhoneNumber
                        } else {
                            displayContacts
                        }
                    } else {
                        beggingPage
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            fetchContacts()
        }
        
    }
    
    var loadingPage: some View {
        VStack {
            ProgressView()
            
        }
        .padding(.horizontal)
        .onAppear {
            navigationTitle = "Find Contacts"
            fetchContacts()
        }
    }
    
    var addPhoneNumber: some View {
        VStack {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack {
                    Spacer()
                    
                    TextField("Enter your phone number:", text: $phoneNumber)
                        .disableAutocorrection(true)
                        .modifier(IGTextFieldModifier())
                        .keyboardType(.numberPad) // This restricts input to numeric keypad
                        .onReceive(Just(phoneNumber)) { newPhoneNumber in
                            let filtered = newPhoneNumber.filter { "0123456789".contains($0) }
                            if filtered != newPhoneNumber {
                                self.phoneNumber = String(filtered.suffix(10))
                            }
                        }
                        .padding(.top, 50)
                    
                    if Checks.isValidPhoneNumber(phoneNumber) && canContinue {
                        Button {
                            
                            Task {
                                continueCooldown()
                                let submission = phoneNumber
                                phoneNumber = ""
                                try await UserService.updatePhoneNumber(uid: user.id, newPhoneNumber: submission)
                                user = try await FetchService.fetchUserById(withUid: user.id)
                            }
                            
                        } label: {
                            Text("Continue")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: textBoxWidth, height: 44)
                                .background(Color(.systemBlue))
                                .cornerRadius(8)
                                .padding(.top, 20)
                        }
                    } else {
                        Text("Continue")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: textBoxWidth, height: 44)
                            .background(Color(.systemGray))
                            .cornerRadius(8)
                            .padding(.top, 20)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            navigationTitle = "Add Phone Number"
        }
    }
    
    var displayContacts: some View {
        NavigationStack  {
            VStack {
                
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search", text: $searchText)
                            .autocapitalization(.none)
                            .onSubmit {
                                hideKeyboard()
                            }
                        
                        Spacer()
                        
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "x.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    
                    }
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(.gray).opacity(0.3), lineWidth: 1)
                    )
                    
                }
                
                
                
                ScrollView(.vertical) {
                    ForEach(filteredContacts, id: \.identifier) { contact in
                        
                        if !contact.givenName.isEmpty {
                            ContactAccountsDisplayer(contact: contact, user: $user)
                            
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            .onAppear {
                navigationTitle = "Found Friends"
            }
        }
    }
    
    var beggingPage: some View {
        VStack {
            Spacer()
            
            Image(systemName: "waveform.path.ecg")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .foregroundStyle(Color(.systemGray))
            
            Text("We can't continue without access to your contacts :(")
                .foregroundStyle(Color(.systemGray))
                .multilineTextAlignment(.center)
            
            Button {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }
            } label: {
                Text("Open Settings")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: textBoxWidth, height: 44)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
                    .padding(.top, 20)
            }
            
            
            Spacer()
        }
        .padding(.horizontal)
        .onAppear {
            navigationTitle = "Find Contacts"
        }
    }
    
    func fetchContacts() {
        DispatchQueue.global(qos: .userInitiated).async { // Perform work on a background thread
            
            var fetchedContacts: [CNContact] = [] // Create an array to hold fetched contacts

            let contactStore = CNContactStore()
            
            

            // Check if access to contacts is granted
            if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
                
                allowedAccess = true
                
                // Create CNKeyDescriptor objects for the keys you want to fetch, including phoneNumbers
                let keysToFetch: [CNKeyDescriptor] = [
                    CNContactGivenNameKey as CNKeyDescriptor,
                    CNContactFamilyNameKey as CNKeyDescriptor,
                    CNContactPhoneNumbersKey as CNKeyDescriptor // Include phone numbers in the fetch request
                ]
                
                let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
                
                do {
                    try contactStore.enumerateContacts(with: fetchRequest) { (contact, stop) in
                        // Handle each contact here
                        fetchedContacts.append(contact)
                    }
                } catch {
                    print("Error fetching contacts: \(error.localizedDescription)")
                }
                
                let sortedContacts = fetchedContacts.sorted { (contact1, contact2) -> Bool in
                    let name1 = "\(contact1.familyName)\(contact1.givenName)"
                    let name2 = "\(contact2.familyName)\(contact2.givenName)"
                    return name1.localizedCaseInsensitiveCompare(name2) == .orderedAscending
                }
                
                DispatchQueue.main.async { // Update the UI on the main thread
                    // Process and update your SwiftUI view here
                    self.contacts = sortedContacts
                    loadingContacts = false
                    
                }
                
            } else {
                loadingContacts = false
                
                contactStore.requestAccess(for: .contacts) { (granted, error) in
                    if granted {
                        print("Permission granted")
                        // Fetch contacts here
                    } else if let error = error {
                        print("Error requesting contacts access: \(error.localizedDescription)")
                    }
                }
            }
            
        }
    }

    

    private func continueCooldown() {
        canContinue = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            canContinue = true
        }
    }

}

