//
//  ShopComponents.swift
//  TheCursedMap
//
//  Created by Emilia Forsheim on 2025-05-28.
//

import SwiftUI

struct PurchasePopup: View {
    var avatar: Avatar
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        Color.black.opacity(0.7).ignoresSafeArea()
        VStack(spacing: 20) {
            Text("Are you sure you want to purchase this avatar?")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Image(avatar.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)

            HStack(spacing: 6) {
                Image("coin1")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("\(avatar.price)")
                    .foregroundColor(.white)
            }

            HStack(spacing: 30) {
                Button("Yes") {
                    onConfirm()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.black)
                .cornerRadius(10)

                Button("No") {
                    onCancel()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.black)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color("GrayBlack"))
        .cornerRadius(20)
        .padding(.horizontal, 40)
    }
}

struct JumpscareView: View {
    var imageName: String
    var onDone: () -> Void
    @State private var scale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image(imageName)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .onAppear {
                    SoundManager.shared.playEffectSound(named: "AvatarScream")
                    withAnimation(.easeIn(duration: 0.3)) {
                        scale = 5.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        onDone()
                        scale = 1.0
                    }
                }
        }
    }
}
