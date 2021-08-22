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
        if day.isVisible {
            Toggle("", isOn: $day.isDone)
                .toggleStyle(CheckboxStyle())
        } else {
            Toggle("", isOn: $day.isDone)
                .toggleStyle(CheckboxStyle()).hidden()
        }
    }
}

struct CheckboxStyle: ToggleStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
 
            configuration.label
 
            Spacer()
            
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(configuration.isOn ? .blue : Color(.systemGray4))
                .font(.system(size: 20, weight: .regular, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            Spacer()
        }
 
    }
}

struct DayCheckBoxView_Previews: PreviewProvider {
    
    static var day: Day {
        let viewContext = PersistenceController.preview.container.viewContext
        let day = Day(context: viewContext)
        day.date = Date()
        day.isDone = false
        day.isVisible = true
        return day
    }
    
    static var previews: some View {
        DayCheckBoxView(day: day)
    }
}
