//
//  ShopView.swift
//  TheCursedMap
//
//  Created by Emilia Forsheim on 2025-05-27.
//

import SwiftUI
import AVFoundation

struct ShopView: View {
    @StateObject private var viewModel = ShopViewModel()
    @State private var selectedCategory = "1"

    @State private var showPurchasePopup = false
    @State private var avatarToPurchase: Avatar? = nil
    @State private var showJumpscare = false
    @State private var jumpscareAvatar: Avatar? = nil
    @State private var animateSelected = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color("GrayBlack"),
                Color("Gray"),
                Color("GrayBlack")
            ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    HStack(spacing: 6) {
                        Image("coinpile")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("\(viewModel.coinBalance)")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
                .padding(.trailing, 20)
                .padding(.top, 10)

                Image(viewModel.selectedAvatar.isEmpty ? "1avatar1" : viewModel.selectedAvatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .padding(.bottom, 50)
                    .scaleEffect(animateSelected ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: animateSelected)

                VStack(spacing: 20) {
                    
                    // MARK: CATEGORY
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(1...9, id: \.self) { cat in
                                Button(" \(cat) ") {
                                    selectedCategory = String(cat)
                                }
                                .padding(8)
                                .background(selectedCategory == String(cat) ? Color.red : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // MARK: AVATAR
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                            ForEach(viewModel.allAvatars.filter { $0.category == selectedCategory }) { avatar in
                                ZStack(alignment: .topTrailing) {
                                    VStack {
                                        Image(avatar.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 80)
                                            .cornerRadius(8)

                                        if !viewModel.isUnlocked(avatar.imageName) {
                                            HStack(spacing: 6) {
                                                Image("coinpile")
                                                    .resizable()
                                                    .frame(width: 20, height: 20)
                                                Text("\(avatar.price)")
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.7))
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        if viewModel.isUnlocked(avatar.imageName) {
                                            viewModel.selectedAvatar = avatar.imageName
                                            viewModel.saveUserData()
                                            SoundManager.shared.playButtonSound(named: "hello")
                                            animateSelected = true
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                animateSelected = false
                                            }
                                        } else {
                                            if viewModel.coinBalance < avatar.price {
                                                jumpscareAvatar = avatar
                                                showJumpscare = true
                                            } else {
                                                avatarToPurchase = avatar
                                                showPurchasePopup = true
                                                SoundManager.shared.playButtonSound(named: "hello")
                                            }
                                        }
                                    }

                                    if !viewModel.isUnlocked(avatar.imageName) {
                                        Image(systemName: "lock.fill")
                                            .font(.system(size: 30))
                                            .frame(width: 18, height: 22)
                                            .foregroundColor(.red)
                                            .padding(10)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.3))
                )
                .padding(.horizontal)
            }
          

            if showPurchasePopup, let avatar = avatarToPurchase {
                PurchasePopup(
                    avatar: avatar,
                    onConfirm: {
                        SoundManager.shared.playButtonSound(named: "cash-pay")
                        viewModel.purchase(avatar)
                        showPurchasePopup = false
                    },
                    onCancel: {
                        showPurchasePopup = false
                    }
                )
            }

            if showJumpscare, let image = jumpscareAvatar?.imageName {
                JumpscareView(
                    imageName: image,
                    onDone: {
                        showJumpscare = false
                    }
                )
            }
        }
    }
}

struct ShopView_Previews: PreviewProvider {
    static var previews: some View {
        ShopView()
    }
}
