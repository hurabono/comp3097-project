
import Foundation

struct CategoryModel: Identifiable, Codable {
    let id: UUID = UUID()
    var name: String
    var isExpanded: Bool = false
    var items: [ShoppingItem] = []
    
    var totalTax: Double {
        items.reduce(0) { $0 + $1.taxAmount }
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }
}
