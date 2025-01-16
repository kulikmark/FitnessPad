//
//  swipeablePanel.swift
//  FitnessPad
//
//  Created by Марк Кулик on 14.01.2025.
//

import Foundation

//private var emptyExercisesScreenView: some View {
//    // Показываем экран только если exercisesArray пуст
//    if let workoutDay = workoutDay, workoutDay.exercisesArray.isEmpty {
//        return AnyView(
//            VStack {
//                Text("Add an Exercise or Delete the WorkoutDay by swiping the panel on the right.")
//                    .font(.footnote)
//                    .foregroundColor(Color("TextColor"))
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(Color("ViewColor"))
//                    )
//                    .padding(.horizontal, 30)
//                    .multilineTextAlignment(.center)
//            }
//                .frame(maxWidth: 350, maxHeight: 100)
//                .padding(.bottom, 50)
//        )
//    } else {
//        return AnyView(EmptyView()) // Возвращаем пустой view, если упражнения есть
//    }
//}
//
//// -MARK: Swipeable Panel
//private var swipeablePanel: some View {
//    HStack {
//        Capsule()
//            .fill(Color.gray.opacity(0.3))
//            .frame(width: 15, height: 90)
//            .gesture(DragGesture()
//                .onChanged { value in
//                    self.panelOffset = min(value.translation.width, 0)
//                }
//                .onEnded { value in
//                    withAnimation(.bouncy) {
//                        if self.panelOffset < -50 {
//                            self.isPanelVisible = true
//                        } else {
//                            self.isPanelVisible = false
//                        }
//                        self.panelOffset = 0
//                    }
//                }
//            )
//            .onTapGesture {
//                withAnimation(.bouncy) {
//                    self.isPanelVisible.toggle()
//                }
//            }
//        
//        if isPanelVisible {
//            swipeablePanelStack
//                .transition(.move(edge: .trailing))
//        }
//    }
//    .padding(.bottom, 60)
//    
//}
//
//
//// -MARK: Swipeable Panel Stack
//private var swipeablePanelStack: some View {
//    
//    VStack {
//        deleteWorkoutDayButton
//        addExerciseButton
//    }
//    .frame(maxWidth: 80)
//}
