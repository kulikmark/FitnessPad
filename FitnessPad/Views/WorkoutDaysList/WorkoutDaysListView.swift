//
//  WorkoutDaysListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 05.08.2024.
//

import SwiftUI

//struct WorkoutDaysListView: View {
//    var groupedWorkoutDays: [YearSection]
//    var onDelete: (WorkoutDay) -> Void
//    var onSelect: (WorkoutDay) -> Void
//    
//    var body: some View {
//        List {
//            ForEach(groupedWorkoutDays, id: \.year) { yearSection in
//                Section(header: Text(yearSection.year)
//                    .font(.system(size: 33, weight: .medium))
//                    .foregroundColor(.white)
//                    .padding(10)
//                    .background(Color.blue.opacity(0.5))
//                    .cornerRadius(10)
//                    .padding(.leading, 10)
//                    .listRowInsets(EdgeInsets())
//                    .listRowBackground(Color.clear)) { // Убедитесь, что фон секции прозрачный или задан
//                        ForEach(yearSection.months, id: \.month) { monthSection in
//                            Section(header: Text(monthSection.month)
//                                .font(.system(size: 25, weight: .medium))
//                                .foregroundColor(.white)
//                                .padding(5)
//                                .background(Color.white.opacity(0.1))
//                                .cornerRadius(10)
//                                .padding(.leading, 10)
//                                .listRowBackground(Color.clear)) { // Убедитесь, что фон секции прозрачный или задан
//                                    ForEach(monthSection.days) { day in
//                                        WorkoutDayRow(day: day, onTap: { onSelect(day) })
//                                            .swipeActions {
//                                                Button(role: .destructive) {
//                                                    onDelete(day)
//                                                } label: {
//                                                    Label("Удалить", systemImage: "trash")
//                                                }
//                                            }
//                                            .listRowBackground(Color.clear)
//                                    }
//                                }
//                        }
//                    }
//                    .padding(.top, 7)
//
//            }
//            .listRowSeparator(.hidden)
//        }
//       
//        .scrollIndicators(.hidden)
//        .scrollContentBackground(.hidden)
//    }
//}
//
//struct WorkoutDayRow: View {
//    var day: WorkoutDay
//    var onTap: () -> Void
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text("\(day.date ?? Date(), formatter: dateFormatter)")
//                    .font(.system(size: 27, weight: .medium))
//                    .foregroundColor(.white)
//                    .lineLimit(1)
//            }
//            .padding(.leading, 20)
//        }
//        .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
//        .background(Color.white.opacity(0.1))
//        .cornerRadius(15)
//        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
//        .padding(.horizontal, 20)
//        .onTapGesture {
//            onTap()
//        }
//    }
//
//    var dateFormatter: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MMMM yyyy"
//        return formatter
//    }
//}
