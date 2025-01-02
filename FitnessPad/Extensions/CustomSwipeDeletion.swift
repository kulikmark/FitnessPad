//
//  CustomSwipeDeletion.swift
//  FitnessPad
//
//  Created by Марк Кулик on 31.12.2024.
//

// MARK: - Custom Swipe Deletion
//import SwiftUI
//import CoreData
//
//struct WorkoutDayDetailsView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @ObservedObject var viewModel: WorkoutViewModel
//    @Binding var workoutDay: WorkoutDay?
//
//    @State private var swipedId: NSManagedObjectID? = nil
//
//    var body: some View {
//        ZStack {
//            Color("BackgroundColor")
//                .edgesIgnoringSafeArea(.all)
//
//            ScrollView {
//                VStack(alignment: .center, spacing: 15) {
//                    if let workoutDay = workoutDay {
//                        exerciseListView(workoutDay: workoutDay)
//                    } else {
//                        Text("No exercises available")
//                            .foregroundColor(Color.gray)
//                    }
//                }
//            }
//        }
//        .padding(.top, 20)
//    }
//
//    private func exerciseListView(workoutDay: WorkoutDay) -> some View {
//        ForEach(workoutDay.exercisesArray, id: \.self) { exercise in
//            createSwipeableExerciseView(exercise: exercise)
//        }
//    }
//
//    private func createSwipeableExerciseView(exercise: Exercise) -> some View {
//        let isSwiped = exercise.objectID == swipedId
//        let onSwipe: () -> Void = { swipedId = exercise.objectID }
//        let onDelete: () -> Void = { deleteExercise(exercise) }
//        let onSwipeBack: () -> Void = { if swipedId == exercise.objectID { swipedId = nil } }
//
//        return SwipeableView(
//            isSwiped: isSwiped,
//            onSwipe: onSwipe,
//            onDelete: onDelete,
//            onSwipeBack: onSwipeBack
//        ) {
//            ExerciseView(viewModel: viewModel, exercise: exercise)
//        }
//    }
//
//    private func deleteExercise(_ exercise: Exercise) {
//        viewModel.deleteExercise(exercise)
//    }
//}
//
//import SwiftUI
//
//struct ExerciseView: View {
//
//    @ObservedObject var viewModel: WorkoutViewModel
//
//    let exercise: Exercise
//    @State private var isExpanded: Bool = false // Состояние для отслеживания раскрытия
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            VStack {
//                HStack {
//                    Text(exercise.name ?? "Unknown Exercise")
//                        .font(.system(size: 27, weight: .medium))
//                        .foregroundColor(Color("TextColor"))
//
//                    Spacer()
//
//                    // Иконка стрелки, изменяющаяся в зависимости от состояния isExpanded
//                    Image(systemName: isExpanded ? "text.line.last.and.arrowtriangle.forward" : "text.line.first.and.arrowtriangle.forward")
//                        .resizable()
//                        .frame(width: 18, height: 18)
//                        .foregroundColor(Color("TextColor"))
//                        .onTapGesture {
//
//                            isExpanded.toggle()
//
//                        }
//                }
//                .padding(.horizontal, 20)
//                .padding(.vertical)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .background(Color("ViewColor"))
//            }
//
//            VStack {
//                if isExpanded {
//
//                    WorkoutDayDetailsSetsView(viewModel: viewModel, exercise: exercise)
//                        .padding(.horizontal, 20)
//
//                }
//            }
//        }
//        .background(Color("BackgroundColor"))
//
//
//
//    }
//}
//
//
//
//struct SwipeableView<Content: View>: View {
//    let content: Content
//    let onDelete: () -> Void
//    let onSwipe: () -> Void
//    let onSwipeBack: () -> Void
//    let isSwiped: Bool
//
//    @State private var offset: CGFloat = 0
//
//    init(
//        isSwiped: Bool,
//        onSwipe: @escaping () -> Void,
//        onDelete: @escaping () -> Void,
//        onSwipeBack: @escaping () -> Void,
//        @ViewBuilder content: @escaping () -> Content
//    ) {
//        self.isSwiped = isSwiped
//        self.onSwipe = onSwipe
//        self.onDelete = onDelete
//        self.onSwipeBack = onSwipeBack
//        self.content = content()
//    }
//
//    var body: some View {
//        ZStack {
//            HStack {
//                Spacer()
//                Button(action: {
//                    withAnimation { onDelete() }
//                }) {
//                    Text("Delete")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.red)
//                        .cornerRadius(8)
//                }
//                .frame(width: 100)
//                .offset(x: offset + 100)
//            }
//
//            content
//                .background(Color.white)
//                .offset(x: offset)
//                .gesture(
//                    DragGesture()
//                        .onChanged { gesture in
//                            withAnimation { offset = gesture.translation.width }
//                        }
//                        .onEnded { _ in
//                            withAnimation {
//                                if offset < -100 {
//                                    offset = -100
//                                    onSwipe()
//                                } else {
//                                    offset = 0
//                                    onSwipeBack()
//                                }
//                            }
//                        }
//                )
//        }
//        .onAppear { offset = 0 }
//        .onChange(of: isSwiped) { oldvalue, newValue in
//            if !newValue {
//                withAnimation { offset = 0 }
//            }
//        }
//    }
//}
//
//extension WorkoutDay {
//    var exercisesArray: [Exercise] {
//        let set = exercises as? Set<Exercise> ?? []
//        return set.sorted { ($0.name ?? "") < ($1.name ?? "") }
//    }
//}
//
//
//
//
//
//struct WorkoutDayDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.shared.container.viewContext
//
//        // Создаем пример тренировочного дня
//        let workoutDay = WorkoutDay(context: context)
//        workoutDay.date = Date()
//
//        // Создаем пример упражнения
//        let exercise = Exercise(context: context)
//        exercise.name = "Push-ups"
//        workoutDay.addToExercises(exercise)
//
//        // Добавляем пример подходов к упражнению
//        let set1 = ExerciseSet(context: context)
//        set1.weight = 20
//        set1.reps = 15
//        set1.count = 1
////        set1.weightUnit = WeightUnit.kg.rawValue
//        set1.exercise = exercise
//
//        let set2 = ExerciseSet(context: context)
//        set2.weight = 25
//        set2.reps = 12
//        set2.count = 2
////        set2.weightUnit = WeightUnit.kg.rawValue
//        set2.exercise = exercise
//
//        // Возвращаем `WorkoutDayDetailsView` с переданными данными
//        return WorkoutDayDetailsView(
//            viewModel: WorkoutViewModel(),
//            workoutDay: .constant(workoutDay)
//        )
//        .environment(\.managedObjectContext, context)  // Используем mock контекст
//    }
//}
//
