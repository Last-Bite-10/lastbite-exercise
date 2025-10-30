////
////  HistoryDetailView.swift
////  Exa
////
////  Created by Niken Larasati on 28/10/25.
////
//
// import SwiftUI
//
// struct HistoryDetailView: View {
//    let historyItem: HistoryItem
//    let onSetAsPlan: () -> Void // Action saat tombol "Set as today's plan" ditekan
//    
//    // Variabel computed untuk Total Time
//    var totalTime: String {
//        "\(historyItem.minutes) mins"
//    }
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            // Header: Tanggal & Tombol Close
//            HStack {
//                Spacer()
//                Text(
//                    historyItem.date,
//                    format: .dateTime.weekday(.wide).day().month(.wide).year()
//                )
//                .font(.title3)
//                .fontWeight(.regular)
//                
//                Spacer()
//            }
//            .padding(.top)
//            
//            // Total Time
//            VStack(alignment: .leading) {
//                Text("Total Time: \(totalTime)")
//                    .font(.title3)
//                    .fontWeight(.semibold)
//                    .padding(.bottom, 10)
//                
//                // Daftar Exercise Entry
//                VStack(spacing: 12) {
//                    ForEach(historyItem.entries) { entry in
//                        HStack {
//                            Text(entry.name)
//                                .font(.headline)
//                            Spacer()
//                            // Menampilkan menit yang dilakukan / total menit
//                            Text("\(entry.doneMinutes)/\(entry.targetMinutes) mins")
//                                .font(.headline)
//                                .foregroundColor(.secondary)
//                        }
//                        Divider()
//                    }
//                    // Divider terakhir dihapus
//                    if !historyItem.entries.isEmpty {
//                        Divider().hidden()
//                    }
//                }
//                .padding(.horizontal, 8)
//                .padding(.vertical, 10)
//                
//                .cornerRadius(12)
//            }
//            .background(Color(.systemGray6))
//            
//            Spacer()
//            
//            // Tombol "Set as today's plan"
//            Button(action: onSetAsPlan) {
//                Text("Set as today's plan")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 12)
//                    .background(Color.accentColor) // Menggunakan tint/accent color
//                    .foregroundColor(.white)
//                    .cornerRadius(50)
//            }
//        }
//        .padding(.horizontal, 20)
//    }
// }
//
// #Preview {
//    HistoryDetailView(historyItem: HistoryItem(
//        minutes: 30,
//        totalMinutes: 30,
//        date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
//        entries: [
//            ExerciseEntry(name: "Brisk Walk", doneMinutes: 20, targetMinutes: 20),
//            ExerciseEntry(name: "Squats", doneMinutes: 10, targetMinutes: 10)
//        ]
//        )
//    )
// }
