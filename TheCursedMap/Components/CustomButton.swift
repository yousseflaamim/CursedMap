//
//  LoginButton.swift
//  TheCursedMap
//
//  Created by Emilia Forsheim on 2025-05-19.
//

import SwiftUI

struct CustomButton: View {
    
    var label: String
    var iconName: String?
    var iconImage: Image?
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let iconImage = iconImage {
                    iconImage
                        .resizable()
                        .frame(width: 25, height: 25)
                } else if let iconName = iconName {
                    Image(systemName: iconName)
                        .resizable()
                        .frame(width: 25, height: 25)
                }
                
                Text(label)
                    .bold()
                    .foregroundStyle(Color.black)
            }
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity)
            .background(
                Color.gray.opacity(0.4)
                    .blur(radius: 0.5)
            )
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.25), lineWidth: 1)
            )
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
        }
    }
}

