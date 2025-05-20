//
//  EditProfileView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-20.
//

import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var profileViewModel = ProfileViewModel()
    @State private var newUsername: String = ""
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"),
                                                       Color("Gray"),
                                                       Color("GrayBlack")]),
                           startPoint: .top,
                           endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack{
                // logik för att eventuellt ändra profilbild.
                Image("profile-image")
                    .padding(.bottom, 20)
                Text(profileViewModel.name)
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .foregroundColor(.black)
                    .padding(.bottom, 50)
                
                // ändra till coustom textfield
                TextField("Nytt namn", text: $newUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                
                Button("Spara") {
                                // logik att spara till Firebase här
                                dismiss()
                            }
                .font(.system(size: 24, weight: .medium, design: .serif))
                .frame(width: 280, height: 60)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
                .foregroundColor(.black)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.bottom)
                
                            Button("Avbryt") {
                                dismiss()
                            }
                            .font(.system(size: 24, weight: .medium, design: .serif))
                            .frame(width: 280, height: 60)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"), Color("Gray")]),
                                               startPoint: .top,
                                               endPoint: .bottom)
                            )
                            .foregroundColor(.black)
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
    EditProfileView()
}
