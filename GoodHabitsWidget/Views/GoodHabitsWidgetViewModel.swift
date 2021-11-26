//
//  GoodHabitsWidgetViewModel.swift
//  GoodHabitsWidgetExtension
//
//  Created by Simon Bogutzky on 26.11.21.
//

import Foundation

import SwiftUI
import CoreData

extension GoodHabitsWidgetView {
    final class GoodHabitsWidgetViewModel: ObservableObject {

        let missingStatements: Int
        var tomorrowMidnight = Date().addingTimeInterval(24 * 60 * 60).midnight()
        var digits = Date().formatted(.dateTime.day(.twoDigits))
        var abbreviation = Date().formatted(.dateTime.weekday(.abbreviated))

        var missingStatementsString: String {
            missingStatements > 9 ? "9+" : "\(missingStatements)"
        }

        init(missingStatements: Int) {
            self.missingStatements = missingStatements
        }
    }
}

extension GoodHabitsWidgetView.GoodHabitsWidgetViewModel {
    static let previewViewModel = GoodHabitsWidgetView.GoodHabitsWidgetViewModel(missingStatements: 8)
}
