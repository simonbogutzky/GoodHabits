//
//  HabitListViewModel.swift
//  GoodHabits
//
//  Created by Simon Bogutzky on 26.10.21.
//

import SwiftUI
import CoreData

final class HabitListViewModel: ObservableObject {

    @Published var addHabitModalViewIsPresented = false
    @Published var date = Date().midnight()
    @Published var habits: [Habit] = []
    @Published var alertItem: AlertItem?

    var viewContext: NSManagedObjectContext

    var previousWeekNumber: String {
        String(format: "%02d",
               Calendar.current.component(.weekOfYear, from: date.addingTimeInterval(-7 * 60 * 60 * 24)))
    }

    var weekNumber: String {
        String(format: "%02d",
               Calendar.current.component(.weekOfYear, from: date))
    }

    var nextWeekNumber: String {
        String(format: "%02d",
               Calendar.current.component(.weekOfYear, from: date.addingTimeInterval(7 * 60 * 60 * 24)))
    }

    var monthAndYear: String {
        return date.addingTimeInterval(2 * 60 * 60 * 24).formatted(.dateTime.month(.wide).year())
    }

    var weekDays: [WeekDay] {
        let firstWeekDay = Calendar.current.firstWeekday
        let currentWeekDay = Calendar.current.component(.weekday, from: date)
        var diff = firstWeekDay - currentWeekDay
        if diff > 0 {
            diff -= 7
        }
        let firstWeekDate = date.addingTimeInterval(TimeInterval(diff * 60 * 60 * 24))
        let dayAbbreviations = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        var weekDays: [WeekDay] = []
        for index in 0..<dayAbbreviations.count {
            let currentDate = firstWeekDate.addingTimeInterval(Double(index) * 60 * 60 * 24)
            let number = Calendar.current.component(.day, from: currentDate)
            let weekDayIndex = Calendar.current.component(.weekday, from: currentDate) - 1
            let abbreviationKey = LocalizedStringKey(dayAbbreviations[weekDayIndex])

            let isToday = currentDate == Date().midnight()
            weekDays.append(WeekDay(number: number, abbreviationKey: abbreviationKey, isToday: isToday))
        }
        return weekDays
    }

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }

    func today() {
        date = Date().midnight()
    }

    func nextWeek() {
        date = date.addingTimeInterval(7 * 60 * 60 * 24)
    }

    func previousWeek() {
        date = date.addingTimeInterval(-7 * 60 * 60 * 24)
    }

    func fetchHabits() {
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Habit.created, ascending: true)]
        do {
            self.habits = try viewContext.fetch(fetchRequest)
        } catch {
            self.habits = []
        }
    }

    func addItemWithStatement(_ statement: String) {
        withAnimation {
            _ = Habit(context: viewContext, statement: statement)

            saveViewContext()

            fetchHabits()
        }
    }

    func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { self.habits[$0] }.forEach(self.viewContext.delete)

            saveViewContext()

            fetchHabits()
        }
    }

    func saveViewContext() {
        do {
            try self.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            // You should not use this function in a shipping application,
            // although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func saveHabitWithStatement(_ statement: String) {
        guard !statement.isEmpty else {
            alertItem = AlertContext.invalidHabit
            return
        }

        addItemWithStatement(statement)
        withAnimation {
            addHabitModalViewIsPresented = false
        }
    }

    func getNextPaletteColor() -> Color.PaletteColor {
        let colorPaletteIndex = UserDefaults.standard.integer(forKey: DefaultsKey.paletteColorIndex)
        let nextPaletteColorIndex = (colorPaletteIndex + 1) % Color.paletteColors.count
        UserDefaults.standard.set(nextPaletteColorIndex, forKey: DefaultsKey.paletteColorIndex)
        return Color.paletteColors[nextPaletteColorIndex]
    }
}
