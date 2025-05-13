import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: ShoppingListViewModel

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
            .environmentObject(ShoppingListViewModel(context: PersistenceController.shared.container.viewContext))
    }
}
