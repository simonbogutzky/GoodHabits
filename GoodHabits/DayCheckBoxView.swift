//
//  DayCheckBoxView.swift
//  GoodHabits
//
//  Created by Dr. Simon Bogutzky on 12.08.21.
//

import SwiftUI

struct DayCheckBoxView: View {
    @ObservedObject var day: Day
    
    init(day: Day) {
        self.day = day
    }
    
    var body: some View {
        Toggle("", isOn: $day.isDone)
            .toggleStyle(CheckboxStyle())
    }
}

struct CheckboxStyle: ToggleStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
 
            configuration.label
 
            Spacer()
 
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .blue : .gray)
                .font(.system(size: 20, weight: .regular, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
 
    }
}

struct DayCheckBoxView_Previews: PreviewProvider {
    
    static var day: Day {
        let viewContext = PersistenceController.preview.container.viewContext
        let day = Day(context: viewContext)
        day.date = Date()
        day.isDone = true
        return day
    }
    
    static var previews: some View {
        DayCheckBoxView(day: day)
    }
}
