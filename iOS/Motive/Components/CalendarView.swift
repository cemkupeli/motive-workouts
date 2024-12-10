//
//  CalendarView.swift
//  Motive
//
//  Created by Cem Kupeli on 10/16/24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    
    private var calendar: Calendar {
        let calendar = Calendar.current
        return calendar
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter
    }()
    
    private var daysOfWeek: [String] {
        let symbols = dateFormatter.veryShortWeekdaySymbols
        let firstWeekdayIndex = calendar.firstWeekday - 1
        let orderedSymbols = Array(symbols![firstWeekdayIndex...] + symbols![..<firstWeekdayIndex])
        return orderedSymbols
    }
    
    private var datesInMonth: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: selectedDate),
              let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)) else { return [] }
        
        return range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .padding()
                }
                
                Spacer()
                
                Text(DateService.fullDate(from: selectedDate))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.bottom, 10)
                
                Spacer()
                
                Button {
                    selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            
            HStack(spacing: 0) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical)
            
            let firstDate = datesInMonth.first ?? Date()
            let firstWeekday = calendar.component(.weekday, from: firstDate)
            let leadingEmptyDays = (firstWeekday - calendar.firstWeekday + 7) % 7
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(0..<leadingEmptyDays, id: \.self) { _ in
                    Text("")
                        .frame(width: 40, height: 40)
                }
                
                ForEach(datesInMonth, id: \.self) { date in
                    let sameDay = isSameDay(date1: date, date2: selectedDate)
                    Text("\(calendar.component(.day, from: date))")
                        .frame(width: 40, height: 40)
                        .background(sameDay ? .blue : .clear)
                        .foregroundStyle(sameDay ? .white : .black)
                        .clipShape(Circle())
                        .onTapGesture {
                            selectedDate = date
                        }
                }
            }
            
            Button {
                selectedDate = Date()
            } label: {
                Text("Go to Today")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .padding()
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        calendar.isDate(date1, inSameDayAs: date2)
    }
}
