//
//  ExerciseDetailView.swift
//  FitnessPad
//
//  Created by Марк Кулик on 26.01.2025.
//

import SwiftUI
import AVKit

struct ExerciseDetailView: View {
    @ObservedObject var exerciseViewModel: ExerciseViewModel
    var exercise: DefaultExercise
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Заголовок с названием упражнения
                Text(exercise.name ?? "Unknown exercise")
                    .font(.system(size: 24))
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextColor"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Категория упражнения
                if let category = exercise.categories {
                    Text("Category: \(category.name ?? "Unknown")")
                        .font(.system(size: 16))
                        .foregroundColor(Color("TextColor"))
                        .padding(.horizontal)
                }
                
                // Фото упражнения
                if let imageData = exercise.image, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(10)
                        .padding(.horizontal)
                } else {
                    Text("No image available")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
                
                // Видео упражнения
                if let videoData = exercise.video {
                    VideoPlayerView(videoData: videoData)
                } else {
                    Text("No video available")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
                
                // Описание упражнения
                if let description = exercise.exerciseDescription {
                    Text("Description: \(description)")
                        .font(.system(size: 16))
                        .foregroundColor(Color("TextColor"))
                        .padding(.horizontal)
                }
                
                // Атрибуты упражнения
                if let attributes = exercise.attributes as? Set<ExerciseAttribute> {
                    let activeAttributes = attributes.filter { $0.isAdded }
                    if !activeAttributes.isEmpty {
                        Text("Attributes:")
                            .font(.system(size: 16))
                            .foregroundColor(Color("TextColor"))
                            .padding(.horizontal)
                        
                        ForEach(Array(activeAttributes), id: \.self) { attribute in
                            Text("- \(attribute.name ?? "Unknown")")
                                .font(.system(size: 14))
                                .foregroundColor(Color("TextColor"))
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .navigationBarTitle("Exercise Details", displayMode: .inline)
        .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ExerciseEditView(exerciseViewModel: exerciseViewModel)) {
                            Image(systemName: "pencil")
                                .font(.system(size: 18))
                                .foregroundColor(Color("TextColor"))
                        }
                    }
                }
            }
        }
