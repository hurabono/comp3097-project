//
//  ShoppingItem.swift
//  shopping_list
//
//  Created by Heesu Cho on 2025-02-27.
//

import Foundation

struct ShoppingItem: Identifiable, Codable {
    let id = UUID()
    var name: String
    var price: Double
    var category: String

    // Tax calculation based on category
    var taxRate: Double {
        switch category {
        case "Food":
            return 0.05  // 5% tax
        case "Medication":
            return 0.0   // No tax
        case "Cleaning":
            return 0.13  // 13% tax
        default:
            return 0.10  // Default 10% tax
        }
    }

    var taxAmount: Double {
        return price * taxRate
    }

    var totalPrice: Double {
        return price + taxAmount
    }
}

