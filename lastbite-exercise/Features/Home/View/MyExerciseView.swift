//
//  MyExerciseView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftData
import SwiftUI

struct MyExerciseView: View {
    @State private var viewModel = RecommendationViewModel()
    @State private var questionnaireViewModel = QuestionnaireViewModel()
    
    @State private var locationManager = LocationManager()
    @State private var weatherManager = WeatherManager.shared
    
    @State private var showQuestionnaire: Bool = false
    @State private var showPlan: Bool = false
    @State private var showPlanModifySheet = false
    @State private var weeklyStreaks = [true, true, false, true, false]
    @State private var currentDate = Date()
    @State private var progress: Double = 0.2
    @State private var completedMinutes = 2
    @State private var totalMinutes = 10

    @Query private var preferences: [Preference]
    @Query private var records: [ExerciseRecord]
    @Query private var allWeeks: [Weekly]

    private let healthKitManager = HealthKitManager.shared

    init() {
        healthKitManager.requestAuthorization()
        
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(Color("BlueTwo"))
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor(Color("BlueTwo"))
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Streak Section
                    StreakView(allWeeks: allWeeks)
                        .padding(.horizontal)
                        .padding(.bottom, 20)

                    if preferences.first?.planChosen == nil {
                        PlanSelectionView(
                            showQuestionnaire: $showQuestionnaire
                        )
                    } else if showPlan || !records.isEmpty {
                        // Today's Plan Header
                        TodaysPlanHeader(onModifyTapped: {
                            showPlanModifySheet = true
                        })

                        // Today's Plan Section
                        TodaysPlan().environment(viewModel)
                    }

                    // Recent History Section
                    RecentHistoryView().environment(viewModel)
                }
            }
            .navigationTitle("My Exercise")
            .task {
                await healthKitManager.requestAuthorization()
                
                locationManager.requestLocationAuthorization()
            }
            .onChange(of: locationManager.currentLocation) { oldLocation, newLocation in
                if let location = newLocation {
                    print("📍 View mendeteksi lokasi baru: \(location.latitude), \(location.longitude)")
                    
                    Task {
                        print("☁️ Meminta data cuaca ke WeatherManager...")
                        await weatherManager.fetchWeather(for: location)
                    }
                }
            }
            .toolbarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showPlanModifySheet) {
            ExerciseSelectionSheet().environment(viewModel)
        }.fullScreenCover(isPresented: $showQuestionnaire) {
            
            let onDoneAction = {
                showQuestionnaire = false
                showPlan = true
            }
            
            let onCancelAction = {
                showQuestionnaire = false
                preferences.first?.planChosen = nil
            }
            
            NavigationStack {
                if preferences.first?.planChosen == .beginner {
                    StartSmallView(onDone: onDoneAction)
                } else {
                    StartStrongView(onDone: onDoneAction)
                }
            }
            .environment(questionnaireViewModel)
            .environment(locationManager)
            .environment(\.dismissFlow, onCancelAction)
        }
    }
}

#Preview {
    MyExerciseView()
}
