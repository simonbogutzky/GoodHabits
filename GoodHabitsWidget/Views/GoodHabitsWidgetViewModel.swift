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

        var missingStatements = 0
        var tomorrowMidnight = Date().addingTimeInterval(24 * 60 * 60).midnight()
        var digits = Date().formatted(.dateTime.day(.twoDigits))
        var abbreviation = Date().formatted(.dateTime.weekday(.abbreviated))

        var viewContext: NSManagedObjectContext

        @Published var missingStatementsString = "0"

        init(viewContext: NSManagedObjectContext) {
            self.viewContext = viewContext
            fetchMissingStatementsOfToday()
        }

        private func fetchMissingStatementsOfToday() {

            let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
            // fetchRequest.predicate = NSPredicate(format: "firstName == %@", firstName)
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Habit.created, ascending: true)]
            do {
                self.missingStatements = try viewContext.fetch(fetchRequest).count
                self.missingStatementsString = missingStatements > 9 ? "9+" : "\(missingStatements)"
                print("✅ view model - fetch count = \(self.missingStatements)")
            } catch {
                print("❌ fetch error")
            }
        }
    }
}

extension GoodHabitsWidgetView.GoodHabitsWidgetViewModel {
    static let previewViewModel = GoodHabitsWidgetView.GoodHabitsWidgetViewModel(
        viewContext: PersistenceController.preview.container.viewContext
    )
}
