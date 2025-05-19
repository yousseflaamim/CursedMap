//
//  StartView.swift
//  TheCursedMap
//
//  Created by Jeanette Norberg on 2025-05-19.
//

import SwiftUI

struct StartView: View {
    
    @State var showInfo = false
    
    var body: some View {
        
        NavigationStack {
         ZStack{
            // Background Color, maybe change later?
            Color(red: 120/550, green: 120/550, blue: 120/550)
                .ignoresSafeArea()
            
            VStack{
                // Ersätt med logga bild senare
                Text("The Cursed Map!")
                    .font(.system(size: 24, weight: .medium, design: .serif))
                    .padding()
                Spacer()
                
                Button("Start Map"){
                    // Start Game logic
                }
                .font(.system(size: 24, weight: .medium, design: .serif))
                .frame(width:280, height: 60)
                .background(Color(.darkGray))
                .foregroundColor(.black)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.black, lineWidth: 1)
                )
                .padding(.bottom)
                
                NavigationLink(destination: TreasureView()) {
                                       Text("Your Treasures")
                                           .font(.system(size: 24, weight: .medium, design: .serif))
                                           .frame(width: 280, height: 60)
                                           .background(Color(.darkGray))
                                           .foregroundColor(.black)
                                           .cornerRadius(30)
                                           .overlay(
                                               RoundedRectangle(cornerRadius: 30)
                                                   .stroke(Color.black, lineWidth: 1)
                                           )
                                   }
            
                Spacer()
                
                HStack{
                    Button(action: {
                        showInfo = true
                    }) {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color(.darkGray))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.black, lineWidth: 0.5)
                                    )
                                Image(systemName: "info")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                                    .padding(30)
                            }
                            
                        }
                    }
                    Spacer()
                    Button(action: {
                        // Show Profile logic
                    }) {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color(.darkGray))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(Color.black, lineWidth: 0.5)
                                    )
                                
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                                    .padding(30)
                            }
                        }
                    }
                }
            }
        }
            
            // Popup for info about app, when user presser info button
            if showInfo {
                VStack() {
                 Text("INFO")
                    .font(.system(size: 24, weight: .bold, design: .serif))
                    .bold()
                    .padding(.bottom)

                    Text("The Cursed Map är ett mystiskt äventyr där du utforskar förbannade områden, samlar skatter och löser Quiz. Du får själv ge dig ut på en promenad för att hitta skattkistorna, med hjälp av kartan. När du hittat en kista och du löst quizet får du skatten i kistan, men om du inte löser det kan du kanske bli skrämd 👻. Så frågan är VÅGAR DU?!")
                         .font(.system(size: 20, weight: .medium, design: .serif))
                         .multilineTextAlignment(.center)
                         .padding(.horizontal)
                               // makes a line between button and text
                    Text("______________________________")

                    Button(action: {
                        showInfo = false
                    }) {
                    Text("OK")
                      .font(.system(size: 24, weight: .bold, design: .serif)) // text style diffrent
                      .bold()
                      .padding()
                      .foregroundColor(.black)
                      .background(Color(.darkGray))
                  }
                }
                .padding()
                .frame(width: 300)
                .background(Color(.darkGray)) // Backgound color on popup
                .cornerRadius(16)
                .shadow(radius: 10)
            }
        }
    }
}


#Preview {
    StartView()
}
