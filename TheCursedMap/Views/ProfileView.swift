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
    @StateObject private var viewModel = ShopViewModel()

    var body: some View {
        // in use of progressView for xp
        let maxXpPerLevel = 150
        let progress = min(Double(treasureViewModel.xp % maxXpPerLevel) / Double(maxXpPerLevel), 1.0)
        
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
                    Image("openChest1") // en mindre öppnad kista än den andra som blev förstor
                    Text("\(treasureViewModel.openedTreasure)")
                        .font(.system(size: 22, weight: .medium, design: .serif))
                        .foregroundColor(.gray)
                      
                    Spacer()
                        Image("coinpile")
                    Text("\(treasureViewModel.coins)")
                        .foregroundColor(.gray)
                        .font(.system(size: 22, weight: .medium, design: .serif))
              
                }
                .padding(.horizontal)
                HStack{
                    Image(viewModel.selectedAvatar.isEmpty ? "1avatar1" : viewModel.selectedAvatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
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
                    HStack{
                        Text("Level: \(treasureViewModel.level)")
                            .foregroundColor(.yellow)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                        Spacer()
                        Text("XP: \(treasureViewModel.xp)")
                            .foregroundColor(.yellow)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                    }

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
                        SoundManager.shared.playEffectSound(named: "scream")
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
                        SoundManager.shared.playEffectSound(named: "get-out")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                       
                            profileViewModel.signOut()
                        }
              
                    }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                               
                    }
                    .padding(.horizontal,20)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        Text("Köpta Avatarer!")
                            .font(.system(size: 24, weight: .medium, design: .serif))
                            .foregroundColor(Color.yellow)
                            .padding(.bottom)
                        ForEach(viewModel.unlockedAvatars, id: \.self) { avatarName in
                            HStack{
                                VStack{
                                    Image(avatarName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.black, lineWidth: 4))
                                    Button("Välj"){
                                        SoundManager.shared.playButtonSound(named: "click-click")
                                        viewModel.selectedAvatar = avatarName
                                        viewModel.saveUserData()
                                    }
                                    .font(.system(size: 16, weight: .bold, design: .serif))
                                    .foregroundColor(Color.gray)
                                    
                                }
                                .padding(.bottom)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                }
                .padding()
                
                .scrollContentBackground(.hidden)
            }
        }.sheet(isPresented: $showEditSheet) {
            EditProfileView(profileViewModel: profileViewModel)
        }
        .sheet(isPresented: $showSoundSettings) {
            SoundSettingsView()
        }
    }
}

#Preview {
    ProfileView()
}
