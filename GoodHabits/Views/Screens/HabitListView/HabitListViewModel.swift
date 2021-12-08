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
        date.formatted(.dateTime.week())
    }

    var monthAndYear: String {
        date.addingTimeInterval(2 * 60 * 60 * 24).formatted(.dateTime.month(.wide).year())
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

    func getWeekDays() -> [WeekDay] {
        let firstWeekDate = getFirstDateOfTheCurrentWeek()
        var weekDays: [WeekDay] = []
        for index in 0..<7 {
            let currentDate = firstWeekDate.addingTimeInterval(Double(index) * 60 * 60 * 24)
            let digits = currentDate.formatted(.dateTime.day(.twoDigits))
            let abbreviation = currentDate.formatted(.dateTime.weekday(.abbreviated))
            let isToday = currentDate == Date().midnight()
            weekDays.append(WeekDay(digits: digits, abbreviation: abbreviation, isToday: isToday))
        }
        return weekDays
    }

    func fetchHabits() {
        let fetchRequest: NSFetchRequest<Habit> = Habit.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \Habit.created, ascending: true)]
        do {
            let habits = try viewContext.fetch(fetchRequest)

            for habit in habits {
                checkHabit(habit)
            }

            self.habits = habits
        } catch {
            self.habits = []
        }
    }

    private func checkHabit(_ habit: Habit) {
        guard !habit.checkIfDone(exclude: 2) else { return }

        let excluded = habit.excludeDays()
        habit.appendDays(days: excluded, from: Date().midnight().addingTimeInterval(TimeInterval(86400)))
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

    private func getFirstDateOfTheCurrentWeek() -> Date {
        let firstWeekDay = Calendar.current.firstWeekday
        let currentWeekDay = Calendar.current.component(.weekday, from: date)
        var diff = firstWeekDay - currentWeekDay
        if diff > 0 {
            diff -= 7
        }
        return date.addingTimeInterval(TimeInterval(diff * 60 * 60 * 24))
    }

    func getNextPaletteColor() -> Color.PaletteColor {
        let colorPaletteIndex = UserDefaults.standard.integer(forKey: DefaultsKey.paletteColorIndex)
        let nextPaletteColorIndex = (colorPaletteIndex + 1) % Color.paletteColors.count
        UserDefaults.standard.set(nextPaletteColorIndex, forKey: DefaultsKey.paletteColorIndex)
        return Color.paletteColors[nextPaletteColorIndex]
    }
}
