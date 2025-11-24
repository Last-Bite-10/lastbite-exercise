//
//  RecordSessionManager.swift
//  Exa
//
//  Created for persistent recording sessions
//

import Combine
import SwiftData
import SwiftUI

@MainActor
class RecordSessionManager: ObservableObject {
    // MARK: - Singleton
    static let shared = RecordSessionManager()
    
    // MARK: - Published Properties
    @Published var activeSession: RecordViewModel?
    @Published var isRecording: Bool = false
    @Published var shouldShowRecordView: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Setup observers
        setupSessionObserver()
    }
    
    // MARK: - Session Management
    
    /// Starts a new recording session or returns existing one
    func startSession(
        record: ExerciseRecord,
        healthKitManager: HealthKitManager,
        modelContext: ModelContext,
        watchConnectivityManager: WatchConnectivityManager
    ) -> RecordViewModel {
        // If there's an existing session for this record, return it
        if let existingSession = activeSession,
           existingSession.getCurrentRecord().id == record.id {
            print("[SessionManager] Returning existing session for record: \(record.id)")
            return existingSession
        }
        
        // Clean up any existing session first
        if activeSession != nil {
            print("[SessionManager] Cleaning up previous session before starting new one")
            endSession()
        }
        
        // Create new session
        print("[SessionManager] Creating new recording session for record: \(record.id)")
        let viewModel = RecordViewModel(
            record: record,
            healthKitManager: healthKitManager,
            modelContext: modelContext,
            watchConnectivityManager: watchConnectivityManager
        )
        
        activeSession = viewModel
        isRecording = true
        
        return viewModel
    }
    
    /// Ends the current recording session
    func endSession() {
        guard let session = activeSession else { return }
        
        print("[SessionManager] Ending recording session")
        session.stopMonitoring()
        activeSession = nil
        isRecording = false
    }
    
    /// Pauses the current session without ending it
    func pauseSession() {
        guard let session = activeSession else { return }
        print("[SessionManager] Pausing recording session")
        session.pauseTimer()
    }
    
    /// Resumes the current session
    func resumeSession() {
        guard let session = activeSession else { return }
        print("[SessionManager] Resuming recording session")
        session.startTimer()
    }
    
    /// Finishes and saves the current session
    func finishSession() {
        guard let session = activeSession else { return }
        
        print("[SessionManager] Finishing and saving recording session")
        session.finishExercise()
        activeSession = nil
        isRecording = false
    }
    
    // MARK: - Private Methods
    
    private func setupSessionObserver() {
        // Monitor session changes
        $activeSession
            .sink { [weak self] session in
                self?.isRecording = (session != nil)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    
    /// Triggers navigation back to the active recording session
    func navigateToActiveSession() {
        if activeSession != nil {
            shouldShowRecordView = true
        }
    }
    
    /// Resets the navigation flag
    func resetNavigation() {
        shouldShowRecordView = false
    }
    
    // MARK: - Computed Properties
    
    var hasActiveSession: Bool {
        return activeSession != nil
    }
}

// MARK: - RecordViewModel Extension
extension RecordViewModel {
    /// Helper to get the current record
    func getCurrentRecord() -> ExerciseRecord {
        return self.record
    }
    
    /// Expose record for session management
    var recordId: PersistentIdentifier {
        return record.id
    }
}

