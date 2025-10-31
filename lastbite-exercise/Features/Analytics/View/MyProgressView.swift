//
//  MyProgressView.swift
//  lastbite-exercise
//
//  Created by Ali Ahmad Fahrezy on 22/10/25.
//

import SwiftUI

struct MyProgressView: View {
    // DIHAPUS: Semua @State data hardcoded telah dihapus.
    
    // DITAMBAHKAN: ViewModel diinisialisasi sebagai source of truth
    @State private var viewModel = MyProgressViewModel()
     
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Weekly Progress Section
                WeeklyProgressView(
                    // DIUBAH: Data diambil dari viewModel
                    currentMinutes: viewModel.currentWeeklyMinutes,
                    totalMinutes: viewModel.totalWeeklyMinutes
                )
                 
                // Trophies Section
                TrophiesView(
                    // DIUBAH: Data diambil dari viewModel
                    trophies: viewModel.trophies
                )
                 
                Spacer()
            }
            .padding()
        }
        .navigationTitle(Text("My Progress"))
    }
}

#Preview {
    MyProgressView()
}
