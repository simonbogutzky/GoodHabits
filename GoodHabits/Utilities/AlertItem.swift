//
//  AlertItem.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 08.11.21.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button

    var alert: Alert {
        Alert(title: title, message: message, dismissButton: dismissButton)
    }
}

struct AlertContext {

    // MARK: - Add Habit Errors
    static let invalidHabit = AlertItem(
        title: Text("Invalid behavior pattern"),
        message: Text("A behavior pattern is required. \nPlease try again."),
        dismissButton: .default(Text("Ok")))
}
