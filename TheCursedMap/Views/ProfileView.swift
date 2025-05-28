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
    @State var showSoundSettings = false
    @State private var deleteErrorMessage: String? = nil
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var treasureViewModel = TreasureViewModel()
    @StateObject private var soundManager = SoundManager.shared
    
    
  
    var body: some View {
        // in use of progressView
        let maxCoinsPerLevel = 100
        let progress = min(Double(treasureViewModel.coins % maxCoinsPerLevel) / Double(maxCoinsPerLevel), 1.0)
        
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
                    Image("openChest1") // en mindre öppnad kista
                        .padding()
                    Text("\(treasureViewModel.openedTreasure)")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                        Image("coinpile")
                    Text("\(treasureViewModel.coins)")
                        .foregroundColor(.gray)
                        .padding(20)
                }
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
                
                // ProgressView for Level up
                VStack(alignment: .leading) {
                    Text("Level \(treasureViewModel.level)")
                        .foregroundColor(.yellow)
                        .font(.system(size: 18, weight: .medium, design: .serif))

                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle())
                        .frame(height: 10)
                        .tint(.yellow)
                }
                .padding([.leading, .trailing, .bottom])
                HStack{
                    Button(action: {
                        showSoundSettings = true
                    }) {
                        Image(systemName: "megaphone")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.gray)
                            .padding()
                    }
                    .padding(.horizontal,20)
                    Button(action: {
                        showEditSheet = true
                    }) {
                            Image(systemName: "pencil.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                        
                    }
                    .padding(.horizontal,20)
                    Button(action: {
                        showAlertDelete = true
                    }) {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
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
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                               
                    }
                    .padding(.horizontal,20)
                }
                
                List{
                    HStack{
                        // logik för att eventuellt visa något i en lista. eller något annat, nedan bara ett exempel.
                        Text("Eventuella kommande avatarer här")
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
        .sheet(isPresented: $showSoundSettings) {
            SoundSettingsView()
        }
    }
}

#Preview {
    ProfileView()
}
