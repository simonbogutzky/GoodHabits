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
    @Published var currentDate = Date().midnight() {
        didSet {
            print("DidSet current date: \(currentDate)")
        }
    }

    @Published var referenceDate = Date().midnight() {
        didSet {
            print("DidSet reference date: \(currentDate)")
        }
    }
    @Published var habits: [Habit] = []
    @Published var alertItem: AlertItem?

    var viewContext: NSManagedObjectContext

    var previousWeekNumber: String {
        String(format: "%02d", Calendar.current.component(.weekOfYear, from: referenceDate.addingTimeInterval(TimeInterval(-7 * 86400))))
    }

    var weekNumber: String {
        referenceDate.formatted(.dateTime.week())
    }

    var monthAndYear: String {
        referenceDate.addingTimeInterval(TimeInterval(2 * 86400)).formatted(.dateTime.month(.wide).year())
    }

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        self.referenceDate = self.getFirstDateOfTheWeek(from: currentDate)
    }

    func today() {
        referenceDate = currentDate
    }

    func nextDay() {
        currentDate = currentDate.addingTimeInterval(TimeInterval(86400))
        referenceDate = getFirstDateOfTheWeek(from: currentDate)
        fetchHabits()
    }

    func nextWeek() {
        referenceDate = referenceDate.addingTimeInterval(TimeInterval(7 * 86400))
    }

    func previousWeek() {
        referenceDate = referenceDate.addingTimeInterval(TimeInterval(-7 * 86400))
    }

    func getWeekDays() -> [WeekDay] {
        let firstWeekDate = getFirstDateOfTheWeek(from: referenceDate)
        var weekDays: [WeekDay] = []
        for index in 0..<7 {
            let currentDate = firstWeekDate.addingTimeInterval(TimeInterval(index * 86400))
            let digits = currentDate.formatted(.dateTime.day(.twoDigits))
            let abbreviation = currentDate.formatted(.dateTime.weekday(.abbreviated))
            let isToday = currentDate == self.currentDate
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
        print("Today: \(currentDate)")

        guard !habit.checkIfDone(exclude: 1, until: currentDate) else { return }

        let excluded = habit.excludeDays(until: currentDate)
        let lastDay = Array(habit.days as? Set<Day> ?? []).sorted { $0.date! < $1.date! }.last
        guard let lastDay = lastDay else { return }
        habit.appendDays(days: excluded, from: lastDay.date!.addingTimeInterval(TimeInterval(86400)))

        saveViewContext()
    }

    func addItemWithStatement(_ statement: String) {
        withAnimation {
            _ = Habit(context: viewContext, statement: statement, created: currentDate)

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

    private func getFirstDateOfTheWeek(from date: Date) -> Date {
        let firstWeekDay = Calendar.current.firstWeekday
        let currentWeekDay = Calendar.current.component(.weekday, from: date)
        var diff = firstWeekDay - currentWeekDay
        if diff > 0 {
            diff -= 7
        }
        return date.addingTimeInterval(TimeInterval(diff * 86400)).midnight()
    }

    func getNextPaletteColor() -> Color.PaletteColor {
        let colorPaletteIndex = UserDefaults.standard.integer(forKey: DefaultsKey.paletteColorIndex)
        let nextPaletteColorIndex = (colorPaletteIndex + 1) % Color.paletteColors.count
        UserDefaults.standard.set(nextPaletteColorIndex, forKey: DefaultsKey.paletteColorIndex)
        return Color.paletteColors[nextPaletteColorIndex]
    }
}
