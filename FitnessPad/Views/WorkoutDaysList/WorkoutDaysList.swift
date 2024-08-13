//
//  TrainingsListView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 11.04.2022.
//

//@State private var showDeleteHint: Bool = UserDefaults.standard.bool(forKey: "showDeleteHint")

import SwiftUI
import CoreData

struct WorkoutDaysList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var viewModel: WorkoutViewModel
    @Binding var workoutDay: WorkoutDay?
    @Binding var selectedTab: Tab
    @Binding var selectedDate: Date
    @State private var selectedWorkoutDay: WorkoutDay?
    @State private var showDeleteHint: Bool = true
    @State private var searchText: String = ""
    @State private var showSearchBar: Bool = false
    
    @State private var isAddTrainingDayViewPresented: Bool = false // State to control the modal presentation
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutDay.date, ascending: true)],
        animation: .default)
    private var workoutDays: FetchedResults<WorkoutDay>
    
    private var filteredWorkoutDays: [WorkoutDay] {
        if searchText.isEmpty {
            return Array(workoutDays)
        } else {
            return workoutDays.filter { day in
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMMM yyyy"
                let dateString = formatter.string(from: day.date ?? Date())
                return dateString.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    WorkoutDaysHeaderView(showSearchBar: $showSearchBar, searchText: $searchText)
                    
                    DeleteHintView(showDeleteHint: $showDeleteHint)
                    
                    if filteredWorkoutDays.isEmpty {
                        Text("No workout days available")
                            .font(.system(size: 27, weight: .regular))
                            .foregroundColor(Color("TextColor"))
                            .padding()
                            .frame(maxWidth: .infinity)
                    } else {
                        WorkoutDaysListView(
                            groupedWorkoutDays: groupedWorkoutDays,
                            onDelete: deleteWorkoutDays,
                            onSelect: { selectedWorkoutDay = $0 }
                        )
                    }
                    
                    Spacer()
                    
                    // Adding new training day
                    HStack {
                        Spacer()
                        Button(action: {
                            isAddTrainingDayViewPresented.toggle() // Toggle the state to show the modal
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 30, weight: .regular))
                                .foregroundColor(Color.black)
                                .padding(15)
                                .background(Circle().fill(Color("ButtonColor")))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 90)
                    .padding(.trailing, 20)
                }
                
                // Full-screen cover for WorkoutDayDetails view
                .fullScreenCover(item: $selectedWorkoutDay) { day in
                    WorkoutDayDetails(viewModel: viewModel, workoutDay: .constant(day), selectedTab: $selectedTab)
                }
                .onAppear {
                    if !UserDefaults.standard.bool(forKey: "hasSeenDeleteHint") {
                        showDeleteHint = true
                        UserDefaults.standard.set(true, forKey: "hasSeenDeleteHint")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $isAddTrainingDayViewPresented) {
            AddTrainingDayFullScreenView(
                viewModel: WorkoutViewModel(),
                selectedDate: $selectedDate,
                workoutDay: $workoutDay,
                selectedTab: $selectedTab
            )
        }
        .presentationDetents([.height(400)])
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
    
    var groupedWorkoutDays: [YearSection] {
        let groupedByYear = Dictionary(grouping: filteredWorkoutDays) { day in
            let calendar = Calendar.current
            let year = calendar.component(.year, from: day.date ?? Date())
            return "\(year)"
        }
            .sorted { $0.key > $1.key } // Sort by descending year
        
        return groupedByYear.map { year, days in
            let groupedByMonth = Dictionary(grouping: days) { day in
                let calendar = Calendar.current
                let month = calendar.component(.month, from: day.date ?? Date())
                return month
            }
                .sorted { $0.key > $1.key } // Sort by descending month
            
            let monthSections = groupedByMonth.map { month, days in
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM"
                let monthName = formatter.monthSymbols[month - 1]
                return MonthSection(month: monthName, days: days)
            }
            
            return YearSection(year: year, months: monthSections)
        }
    }
    
    func deleteWorkoutDays(workoutDay: WorkoutDay) {
        withAnimation {
            viewContext.delete(workoutDay)
            
            do {
                try viewContext.save()
            } catch {
                // Handle the error appropriately in a production app
                print("Failed to save context after deletion: \(error.localizedDescription)")
            }
            
            // Refresh the filteredWorkoutDays array by updating the searchText
            searchText = searchText // This line forces a refresh of the filteredWorkoutDays computed property
        }
    }
}

struct AddTrainingDayFullScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutViewModel
    @Binding var selectedDate: Date
    @Binding var workoutDay: WorkoutDay?
    @Binding var selectedTab: Tab
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                AddTrainingDayView(viewModel: viewModel, selectedDate: $selectedDate, workoutDay: $workoutDay, selectedTab: $selectedTab)
                    .background(Color("BackgroundColor")) // Ensure background color is applied
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            CustomBackButtonView() // Используем кастомную кнопку
                        }
                    }
            }
        }
    }
}

struct YearSection {
    let year: String
    let months: [MonthSection]
}

struct MonthSection {
    let month: String
    let days: [WorkoutDay]
}


struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var control: SearchBar
        
        init(_ control: SearchBar) {
            self.control = control
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            control.text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search workout days"
        searchBar.barTintColor = UIColor(Color("ViewColor"))
        searchBar.searchTextField.backgroundColor = UIColor(Color.white.opacity(0.3))
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.tintColor = .white
        searchBar.layer.cornerRadius = 10
        searchBar.layer.masksToBounds = true
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

//struct WorkoutDaysList_Previews: PreviewProvider {
//    static var previews: some View {
//        // Создаем временные состояния и переменные
//        let context = PersistenceController.preview.container.viewContext
//        let viewModel = WorkoutViewModel()
//        
//        // Создание тестового WorkoutDay
//        let workoutDay = WorkoutDay(context: context)
//        workoutDay.date = Date()
//        
//        // Использование @State для привязки состояния в превью
//        return Group {
//            WorkoutDaysList(
//                viewModel: viewModel,
//                workoutDay: .constant(workoutDay),
//                selectedTab: .constant(.workoutDays), selectedDate: <#Binding<Date>#>
//            )
//            .environment(\.managedObjectContext, context)
//        }
//    }
//}


struct WorkoutDaysListView: View {
    var groupedWorkoutDays: [YearSection]
    var onDelete: (WorkoutDay) -> Void
    var onSelect: (WorkoutDay) -> Void
    @State private var expandedSections: [String: Bool] = [:] // Track expanded/collapsed state
    
    var body: some View {
        List {
            ForEach(groupedWorkoutDays, id: \.year) { yearSection in
                Section(
                    header: ZStack(alignment: .leading) {
                        LinearGradient(gradient: Gradient(colors: [Color("ViewColor"), Color("ViewColor").opacity(0.8)]),
                                       startPoint: .leading, endPoint: .trailing)
                        .cornerRadius(5)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, -20)
                        
                        Text(yearSection.year)
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                    }
                ) {
                    ForEach(yearSection.months, id: \.month) { monthSection in
                        let sectionKey = "\(yearSection.year)-\(monthSection.month)" // Unique key for each month section
                        Section(
                            header: HStack {
                                Image(systemName: expandedSections[sectionKey, default: false] ? "chevron.down" : "chevron.right")
                                    .foregroundColor(.black)
                                Text(monthSection.month)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 20)
                            .padding(10)
                            .background(Color("ViewColor2"))
                            .cornerRadius(8)
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                withAnimation {
                                    expandedSections[sectionKey, default: false].toggle()
                                }
                            }
                        ) {
                            if expandedSections[sectionKey, default: false] {
                                ForEach(monthSection.days) { day in
                                    WorkoutDayRow(day: day, onTap: { onSelect(day) })
                                        .swipeActions {
                                            Button(role: .destructive) {
                                                onDelete(day)
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        .listRowBackground(Color.clear)
                                }
                            }
                        }
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
    }
}



struct WorkoutDayRow: View {
    var day: WorkoutDay
    var onTap: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(day.date ?? Date(), formatter: dateFormatter)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .padding(.leading, 20)
        }
        .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
        .background(Color.white.opacity(0.3))
        .cornerRadius(12)
        .onTapGesture {
            onTap()
        }
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
}
