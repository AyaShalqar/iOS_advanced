import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var viewModel: ShoppingListViewModel

    var groupedProducts: [String: [Product]] {
        Dictionary(grouping: viewModel.products) { product in
            let category = product.category?.trimmingCharacters(in: .whitespacesAndNewlines)
            return (category?.isEmpty ?? true) ? "Uncategorized" : category!
        }

    }

    var sortedCategories: [String] {
        groupedProducts.keys.sorted()
    }

    var body: some View {
        List {
            ForEach(sortedCategories, id: \.self) { category in
                Section(header: Text(category)) {
                    ForEach(groupedProducts[category] ?? []) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductRow(product: product)
                        }

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
