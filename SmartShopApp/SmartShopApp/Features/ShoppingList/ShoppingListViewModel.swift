import Foundation
import CoreData
import Combine

class ShoppingListViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var newProductName = ""
    @Published var newProductCategory = ""
    @Published var newProductQuantity: Int16 = 1
    @Published var error: String?
    @Published var newProductPrice: Double = 0.0
    @Published var newProductStore: String = ""
    @Published var newProductImportance: Int16 = 1
    
    private let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchProducts()
    }
    
    func fetchProducts() {
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Product.name, ascending: true)]
        
        do {
            products = try viewContext.fetch(request)
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func addProduct() {
        guard !newProductName.isEmpty else { return }
        
        let product = Product(context: viewContext)
        product.id = UUID()
        product.name = newProductName
        product.category = newProductCategory
        product.quantity = newProductQuantity
        product.isCompleted = false
        product.price = newProductPrice
        product.store = newProductStore
        product.importance = newProductImportance

        
        saveContext()
        resetNewProduct()
    }
    
    func toggleProduct(_ product: Product) {
        product.isCompleted.toggle()
        saveContext()
    }
    
    func deleteProduct(_ product: Product) {
        viewContext.delete(product)
        saveContext()
    }
    
    func moveProduct(from source: IndexSet, to destination: Int) {
        var revisedItems = products.map { $0 }
        revisedItems.move(fromOffsets: source, toOffset: destination)
        
        for (index, item) in revisedItems.enumerated() {
            item.name = "\(index)" // This is just for ordering, we'll keep the original name
        }
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            fetchProducts()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    private func resetNewProduct() {
        newProductName = ""
        newProductCategory = ""
        newProductQuantity = 1
        newProductPrice = 0.0
        newProductStore = ""
        newProductImportance = 1

    }
    
    // AI Recommendations (Mock implementation)
    func getRecommendations() -> [String] {
        // In a real app, this would use ML to analyze purchase history
        return ["Milk", "Bread", "Eggs", "Butter"]
    }
    
    func markCompletedAsPurchased() {
        let completed = products.filter { $0.isCompleted }
        guard !completed.isEmpty else { return }

        let history = PurchaseHistory(context: viewContext)
        history.date = Date()
        history.products = NSSet(array: completed)

        // Удаляем завершённые продукты из текущего списка (если нужно)
        for product in completed {
            viewContext.delete(product)
        }

        saveContext()
    }

}
