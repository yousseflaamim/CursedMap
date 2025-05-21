//
//  HUDManager.swift
//  TheCursedMap
//
//  Created by gio on 5/21/25.
//


import Foundation
import ProgressHUD
import UIKit

struct HUDManager {
    
    private static func baseConfiguration(statusColor: UIColor) {
        ProgressHUD.colorAnimation = statusColor
        ProgressHUD.colorHUD = .black
        ProgressHUD.colorStatus = statusColor
        ProgressHUD.fontStatus = .systemFont(ofSize: 18, weight: .bold)
    }
    
    static func showLoading(_ message: String = "Loading...") {
        baseConfiguration(statusColor: .blue)
        ProgressHUD.animate(message)
    }
    
    static func showSuccess(_ message: String = "Success") {
        baseConfiguration(statusColor: .green)
        ProgressHUD.succeed(message)
    }
    
    static func showError(_ message: String = "Error") {
        baseConfiguration(statusColor: .red)
        ProgressHUD.failed(message)
    }
    
    static func dismiss() {
        ProgressHUD.dismiss()
    }
}
