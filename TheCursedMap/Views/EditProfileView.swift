//
//  EditProfileView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-20.
//

import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var newUsername: String

    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        _newUsername = State(initialValue: profileViewModel.name)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray"), Color("GrayBlack")]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Image("profile-image")
                    .padding(.bottom, 20)
                
                Text(profileViewModel.name)
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .foregroundColor(.black)
                    .padding(.bottom, 50)
                
                TextField("Nytt namn", text: $newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                
                Button("Spara") {
                    profileViewModel.newDisplayName = newUsername
                    profileViewModel.updateDisplayName { result in
                        switch result {
                        case .success:
                            SoundManager.shared.playButtonSound(named: "click-click")
                            dismiss()
                        case .failure(let error):
                            print("Fel vid uppdatering: \(error.localizedDescription)")
                        }
                    }
                }
                .font(.system(size: 24, weight: .medium, design: .serif))
                .frame(width: 280, height: 60)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
                .foregroundColor(Color(red: 0.6, green: 0.0, blue: 0.0))
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.bottom)
                
                Button("Avbryt") {
                    SoundManager.shared.playButtonSound(named: "click-click")
                    dismiss()
                }
                .font(.system(size: 24, weight: .medium, design: .serif))
                .frame(width: 280, height: 60)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
                .foregroundColor(Color(red: 0.6, green: 0.0, blue: 0.0))
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.bottom)
            }
        }
    }
}

#Preview {
    EditProfileView(profileViewModel: ProfileViewModel())
}
