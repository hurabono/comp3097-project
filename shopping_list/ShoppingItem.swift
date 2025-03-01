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
    
    // 온타리오 법 기준 세금 계산:
    // "Food"이면 세금 없음, 그 외(예: Medication, Cleaning, Other)는 13% HST 적용
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
