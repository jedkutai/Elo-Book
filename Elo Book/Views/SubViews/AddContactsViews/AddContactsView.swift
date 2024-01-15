//
//  AddContactsView.swift
//  Elo Book
//
//  Created by Jed Kutai on 1/14/24.
//

import SwiftUI
import Contacts



struct AddContactsView: View {
    @State var user: User
    
    @State private var contacts: [CNContact] = []
    
    @State private var loadingContacts = true
    @State private var allowedAccess = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    var body: some View {
        if loadingContacts {
            loadingPage
        } else {
            if allowedAccess {
                displayContacts
            } else {
                beggingPage
            }
        }
    }
    
    var loadingPage: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                }
                
                Spacer()
                Text("Find Contacts")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                Spacer()
                
                
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color(.clear))
                
            }
            
            Divider()
                .frame(height: 1)
            
            Spacer()
            ProgressView()
            Spacer()
            
        }
        .onAppear {
            fetchContacts()
        }
    }
    
    var addPhoneNumber: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                }
                
                Spacer()
                Text("Find Contacts")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                Spacer()
                
                
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color(.clear))
                
            }
            
            Divider()
                .frame(height: 1)
            
            ScrollView(.vertical, showsIndicators: false) {
                
            }
        }
    }
    
    var displayContacts: some View {
        NavigationStack  {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                    }
                    
                    Spacer()
                    Text("Find Contacts")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                    Spacer()
                    
                    
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color(.clear))
                    
                }
                
                Divider()
                    .frame(height: 1)
                
                ScrollView(.vertical) {
                    ForEach(contacts, id: \.identifier) { contact in
                        Text("\(contact.givenName) \(contact.familyName)")
                            .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        
                        
                        ForEach(self.extractNumericPhoneNumbers(from: contact), id: \.self) { phoneNumber in
                            Text(phoneNumber)
                                .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                        }
                        
                        Divider()
                            .frame(height: 1)
                    }
                }
            }
        }
    }
    
    var beggingPage: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(colorScheme == .dark ? Theme.buttonColorDarkMode : Theme.buttonColor)
                }
                
                Spacer()
                Text("Find Contacts")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(colorScheme == .dark ? Theme.textColorDarkMode : Theme.textColor)
                Spacer()
                
                
                Image(systemName: "chevron.left")
                    .foregroundStyle(Color(.clear))
                
            }
            Spacer()
            
            Image(systemName: "waveform.path.ecg")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .foregroundStyle(Color(.systemGray))
            
            Text("We can't continue without access to your contacts :(")
                .foregroundStyle(Color(.systemGray))
            
            Spacer()
        }
        .padding(.horizontal)
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

                DispatchQueue.main.async { // Update the UI on the main thread
                    // Process and update your SwiftUI view here
                    self.contacts = fetchedContacts // Update the @State variable with fetched contacts
                    loadingContacts = false
                    
                }
            } else {
                loadingContacts = false
            }
            
        }
    }

    // Function to extract numeric phone numbers from CNContact
    func extractNumericPhoneNumbers(from contact: CNContact) -> [String] {
        var numericPhoneNumbers: [String] = []

        for phoneNumber in contact.phoneNumbers {
            let phoneNumberString = phoneNumber.value.stringValue
            let numericPhoneNumber = phoneNumberString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            numericPhoneNumbers.append(String(numericPhoneNumber.suffix(10)))
        }

        return numericPhoneNumbers
    }



}

