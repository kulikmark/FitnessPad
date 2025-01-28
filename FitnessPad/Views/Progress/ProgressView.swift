import SwiftUI
import CoreData
import Charts


struct ProgressView: View {
    @EnvironmentObject var viewModel: WorkoutViewModel
    
    @State private var selectedTimeFrame: TimeFrame = .week
    
    enum TimeFrame: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            VStack {
                Picker("Time Frame", selection: $selectedTimeFrame) {
                    ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                        Text(timeFrame.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Chart {
                    ForEach(filteredBodyWeights, id: \.date) { bodyWeight in
                        LineMark(
                            x: .value("Date", bodyWeight.date ?? Date()),
                            y: .value("Weight", bodyWeight.weight)
                        )
                    }
                }
                .padding()
            }
        }
    }
    
    private var filteredBodyWeights: [BodyWeight] {
        let bodyWeights = viewModel.fetchBodyWeights()
        
        switch selectedTimeFrame {
        case .week:
            return bodyWeights.filter { bodyWeight in
                guard let date = bodyWeight.date else { return false }
                return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
            }
        case .month:
            return bodyWeights.filter { bodyWeight in
                guard let date = bodyWeight.date else { return false }
                return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .month)
            }
        case .year:
            return bodyWeights.filter { bodyWeight in
                guard let date = bodyWeight.date else { return false }
                return Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year)
            }
        }
    }
}
