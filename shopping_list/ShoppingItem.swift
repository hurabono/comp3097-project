//
//  ShoppingItem.swift
//  shopping_list
//
//  Created by Heesu Cho on 2025-02-27.
//


import Foundation

struct ShoppingItem: Identifiable, Codable {
    let id: UUID = UUID()
    var name: String
    var price: Double
    var category: String
    
    // Tax calculation based on Ontario Tax policy
    // Raw food > No Tax. and Others > Medication, Cleaning, Other is 13% HST
    var taxRate: Double {
        if category.lowercased() == "food" {
            return 0.0
        } else {
            return 0.13
        }
    }
    
    var taxAmount: Double {
        price * taxRate
    }
    
    var totalPrice: Double {
        price + taxAmount
    }
}
