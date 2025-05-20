//
//  ProfileView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-20.
//

import SwiftUI

struct ProfileView: View {
    
    @State var showAlertDelete = false
    @State var showEditSheet = false
    @State private var deleteErrorMessage: String? = nil
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        
        ZStack {
            // Bakground
            LinearGradient(
                gradient: Gradient(colors: [Color("GrayBlack")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack {
            
                HStack{
                    Image("profile-image")
                        .padding()
                    VStack{
                        Text(profileViewModel.name)
                            .font(.system(size: 24, weight: .medium, design: .serif))
                            .foregroundColor(.gray)
                            .padding(.bottom)
                        Text(profileViewModel.email)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .foregroundColor(.gray)
                    }
                }
                HStack{
                    Button(action: {
                        showEditSheet = true
                    }) {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.gray)
                        
                    }
                    .padding(.horizontal,20)
                    Button(action: {
                        showAlertDelete = true
                    }) {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.gray)
                                .alert("Vill du radera ditt konto och allt innehåll?", isPresented: $showAlertDelete) {
                                    Button("Radera", role: .destructive) {
                                        profileViewModel.deleteAccount { result in
                                            switch result {
                                            case .success:
                                                profileViewModel.signOut()
                                                print("Account deleted")
                                                // user logs out
                                            case .failure(let error):
                                                deleteErrorMessage = error.localizedDescription
                                            }
                                        }
                                    }
                                    Button("Avbryt", role: .cancel) { }
                                } message: {
                                    Text("Det går inte att ångra, all data kommer raderas.")
                                }
                        
                    }
                    .padding(.horizontal,60)
                    Button(action: {
                        
                        profileViewModel.signOut()
                        
                    }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.gray)
                        
                    }
                    .padding(.horizontal,20)
                }
                
                List{
                    
                    HStack{
                        // logik för att eventuellt visa något i en lista. eller något annat, nedan bara ett exempel.
                        Text("20 Maj:  You opened 2 chests")
                            .font(.system(size: 16, weight: .medium, design: .serif))
                    }
                    .listRowBackground(Color.gray)
                    .padding()
                    
                }
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color("GrayBlack"),Color("Gray"), Color("GrayBlack")]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                )
                .scrollContentBackground(.hidden)
            }
        }.sheet(isPresented: $showEditSheet) {
            EditProfileView()
               
        }
    }
}

#Preview {
    ProfileView()
}
