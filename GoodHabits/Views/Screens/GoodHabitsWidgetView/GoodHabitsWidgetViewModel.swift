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
        var tomorrowMidnight = Date().addingTimeInterval(TimeInterval(86400)).midnight()

        var digits = Date().formatted(.dateTime.day(.twoDigits))
        var abbreviation = Date().formatted(.dateTime.weekday(.abbreviated))

        var viewContext: NSManagedObjectContext

        @Published var missingStatementsString = "0"

        init(viewContext: NSManagedObjectContext) {
            self.viewContext = viewContext
            fetchMissingStatementsOfToday()
        }

        func fetchMissingStatementsOfToday() {

            let fetchRequest: NSFetchRequest<Day> = Day.fetchRequest()
            let lowerBound = Date().addingTimeInterval(-1 * 60 * 60 * 24).gmtMidnight()
            let upperBound = Date().gmtMidnight()
            let datePredicate = NSPredicate(format: "%K <= %@ AND %K >= %@ AND %K == %@ AND %K == %@",
                                            #keyPath(Day.date),
                                            upperBound as NSDate,
                                            #keyPath(Day.date),
                                            lowerBound as NSDate,
                                            #keyPath(Day.isDone),
                                            NSNumber(value: false),
                                            #keyPath(Day.isExcluded),
                                            NSNumber(value: false)
                                            )
            fetchRequest.predicate = datePredicate
            do {
                self.missingStatements = try viewContext.fetch(fetchRequest).count
                self.missingStatementsString = missingStatements > 9 ? "9+" : "\(missingStatements)"
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
