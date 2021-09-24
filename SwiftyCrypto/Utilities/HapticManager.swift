//
//  HapticManager.swift
//  HapticManager
//
//  Created by Łukasz Stachnik on 14/09/2021.
//

import Foundation
import SwiftUI

final class HapticManager {
    
    static let generator = UINotificationFeedbackGenerator()
    
    static func notification(notificationType: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(notificationType)
    }
}
