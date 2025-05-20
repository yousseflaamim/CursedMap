//
//  ProfileView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-20.
//

import SwiftUI

struct ProfileView: View {
    
  @State var showEditSheet = false
    
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
                        Text("Name")
                            .font(.system(size: 24, weight: .medium, design: .serif))
                            .foregroundColor(.gray)
                            .padding(.bottom)
                        Text("Email")
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
                        
                        // Logik för att radera konto
                        
                    }) {
                            Image(systemName: "trash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .foregroundColor(.gray)
                        
                    }
                    .padding(.horizontal,60)
                    Button(action: {
                        
                        // logik för att logga ut
                        
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
