import SwiftUI

struct CategoriesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ShoppingListViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ShoppingListViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    var groupedProducts: [String: [Product]] {
        Dictionary(grouping: viewModel.products) { $0.category ?? "Uncategorized" }
    }
    
    var sortedCategories: [String] {
        groupedProducts.keys.sorted()
    }
    
    var body: some View {
        List {
            ForEach(sortedCategories, id: \.self) { category in
                Section(header: Text(category)) {
                    ForEach(groupedProducts[category] ?? []) { product in
                        ProductRow(product: product)
                    }
                }
            }
        }
        .navigationTitle("Categories")
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
} 