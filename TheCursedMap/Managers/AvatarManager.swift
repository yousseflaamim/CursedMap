//
//  AvatarManager.swift
//  TheCursedMap
//
//  Created by Alexander Malmqvist on 2025-06-03.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AvatarManager: ObservableObject {
    @Published var selectedAvatar: String = "1avatar1"

    init() {
        fetchSelectedAvatar()
    }

    func fetchSelectedAvatar() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(),
                  let avatar = data["selectedAvatar"] as? String else { return }

            DispatchQueue.main.async {
                self?.selectedAvatar = avatar
            }
        }
    }
}
