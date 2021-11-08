//
//  HapticManager.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 08.11.21.
//

import UIKit

struct HapticManager {

    static func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
