//
//  RecommendationViewModelTests.swift
//  lastbite-exercise
//
//  Created by Niken Larasati on 31/10/25.
//

import Foundation
import Testing
@testable import Exa

@Suite("RecommendationViewModel – Unit (Pure Compute)")
struct RecommendationViewModelComputeTests {

    @Test("Given variasi weekNumber, When computeBaseMinutes, Then hasil benar")
    func test_computeBaseMinutes() {
        // GIVEN (Input) & WHEN (Panggil) & THEN (Cek)
        #expect(RecommendationViewModel.computeBaseMinutes(for: 1) == 30)
        #expect(RecommendationViewModel.computeBaseMinutes(for: 3) == 45)
        #expect(RecommendationViewModel.computeBaseMinutes(for: 6) == 120)
        #expect(RecommendationViewModel.computeBaseMinutes(for: 10) == 150) // Default
        #expect(RecommendationViewModel.computeBaseMinutes(for: nil) == 150) // Default
    }
    
    @Test("Given variasi frekuensi, When computeMinutesPerSession, Then hasil benar")
    func test_computeMinutesPerSession() {
        // GIVEN
        let base = 60 // Anggap 60 menit
        
        // WHEN & THEN
        let oneDay = RecommendationViewModel.computeMinutesPerSession(from: .oneDay, baseMinutes: base)
        #expect(oneDay == 60)
        
        let threeDays = RecommendationViewModel.computeMinutesPerSession(from: .threeDays, baseMinutes: base)
        #expect(threeDays == 20)
        
        let fiveDays = RecommendationViewModel.computeMinutesPerSession(from: .fiveDays, baseMinutes: base)
        #expect(fiveDays == 12)
    }
}
