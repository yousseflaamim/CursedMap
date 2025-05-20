//
//  UserModel.swift
//  TheCursedMap
//
//  Created by Emilia Forsheim on 2025-05-20.
//

import Foundation

struct UserModel: Codable {
    let id: String
    let name: String
    let email: String
}

extension Encodable {
    func asDict() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String : Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
}
