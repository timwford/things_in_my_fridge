// Food.swift

import Foundation

// MARK: - Food
struct Food: Codable, Equatable, Identifiable {
    var name: String
    var expireDays, created: Int
    var active: Bool
    var foodType: String?
    var id: String?

    enum CodingKeys: String, CodingKey {
        case name
        case expireDays = "expire_days"
        case created, active
        case foodType = "food_type"
        case id
    }
}
