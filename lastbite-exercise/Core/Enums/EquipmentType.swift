//
//  EquipmentType.swift
//  Exa
//
//  Created by Ali Ahmad Fahrezy on 30/10/25.
//

enum EquipmentType: String, Codable, Hashable, CaseIterable {
    // DIUBAH: dari .none = "None" agar sesuai data
    case noEquipment = "No equipment"
    case jumpRope = "Jump Rope"
    case exerciseMat = "Exercise Mat"
    case dumbbell = "Dumbbell"
    case stairs = "Stairs"
    case wallSurface = "Wall Surface"
    case racket = "Racket"
    // DITAMBAHKAN: untuk "Basketball"
    case ball = "Ball"
    case bicycle = "Bicycle"
    case paddleTennis = "Paddle Tennis"
    case volleyball = "Volleyball"
}
