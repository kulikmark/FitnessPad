    //
    //  NewTrainingDayView.swift
    //  FitnessPad
    //
    //  Created by Марк Кулик on 23.03.2022.
    //

//import SwiftUI
//
//struct WorkoutDayDatePicker: View {
//    @ObservedObject var viewModel: WorkoutViewModel
//    @Environment(\.managedObjectContext) private var viewContext
//    @State private var date = Date()
//    @Binding var newWorkoutDay: WorkoutDay?
//    @State private var isNavigationActive = false
//    @Binding var selectedTab: Tab
//
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                VStack(spacing: 20) {
//                    VStack(spacing: 40) {
//                        Text("Choose your training date")
//                            .font(.system(size: 27))
//                            .fontWeight(.medium)
//                            .foregroundColor(.white)
//                            .padding(.top, 30)
//
//                        DatePicker("", selection: $date, displayedComponents: .date)
//                            .datePickerStyle(GraphicalDatePickerStyle())
//                            .colorInvert()
//                            .accentColor(.black)
//                            .padding(10)
//                            .background(Color("ViewColor").opacity(0.7), in: RoundedRectangle(cornerRadius: 20))
//                            .frame(maxWidth: .infinity)
//                            .padding(.horizontal, 20)
//                    }
//
//                    Button(action: {
//                        saveWorkoutDay(date: date)
//                        isNavigationActive = true
//                    }) {
//                        Text("Next")
//                            .font(.system(size: 25))
//                            .fontWeight(.medium)
//                            .foregroundColor(.black)
//                            .frame(minWidth: 200, maxWidth: 200, minHeight: 70, maxHeight: 70)
//                            .background(Color("ButtonColor"))
//                            .cornerRadius(15)
//                            
//                    }
//                    .padding(70)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//            .background(Color("BackgroundColor")
//                .edgesIgnoringSafeArea(.all)
//            )
//            .navigationDestination(isPresented: $isNavigationActive) {
//                // Передаем Binding<WorkoutDay?>
//                WorkoutDayDetails(viewModel: viewModel, workoutDay: $newWorkoutDay, selectedTab: $selectedTab)
//            }
//        }
//    }
//    
//    private func saveWorkoutDay(date: Date) {
//        let newWorkoutDay = WorkoutDay(context: viewContext)
//        newWorkoutDay.date = date
//        self.newWorkoutDay = newWorkoutDay
//        
//        viewModel.saveContext()
//    }
//}
//
//struct WorkoutDayDatePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        // Create a temporary binding for `selectedTab`
//        @State var selectedTab: Tab = .home // Or any default value you want
//
//        let context = PersistenceController.preview.container.viewContext
//        let viewModel = WorkoutViewModel()
//
//        WorkoutDayDatePicker(
//            viewModel: viewModel,
//            newWorkoutDay: .constant(nil),
//            selectedTab: $selectedTab
//        )
//        .environment(\.managedObjectContext, context)
//    }
//}
