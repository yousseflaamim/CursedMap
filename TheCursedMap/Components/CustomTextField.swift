//
//  CustomTextField.swift
//  TheCursedMap
//
//  Created by Emilia Forsheim on 2025-05-19.
//

import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    var placeHolder: String
    var image: String
    var isSecure: Bool = false

    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Image(systemName: image)
                    .foregroundColor(.black)

                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeHolder)
                            .foregroundColor(.black.opacity(0.5))
                            .font(.body)
                    }

                    if isSecure {
                        SecureField("", text: $text)
                            .foregroundColor(.black)
                            .font(.body)
                    } else {
                        TextField("", text: $text)
                            .foregroundColor(.black)
                            .font(.body)
                    }
                }
            }
            .padding(.vertical, 6)

            Divider()
                .background(Color.black)
        }
        .padding(.bottom, 8)
    }
}
