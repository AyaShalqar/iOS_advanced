import SwiftUI

struct ShoppingListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ShoppingListViewModel
    @State private var showingAddProduct = false
    @State private var showingRecommendations = false
    
    init() {
        _viewModel = StateObject(wrappedValue: ShoppingListViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductRow(product: product)
                    .swipeActions {
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.deleteProduct(product)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            .onMove { source, destination in
                viewModel.moveProduct(from: source, to: destination)
            }
        }
        .navigationTitle("Shopping List")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddProduct = true
                } label: {
                    Image(systemName: "plus")
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showingRecommendations = true
                } label: {
                    Image(systemName: "lightbulb")
                }
            }

            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }

            ToolbarItem(placement: .bottomBar) {
                Button("Save to History") {
                    viewModel.markCompletedAsPurchased()
                }
            }
        }

        .sheet(isPresented: $showingAddProduct) {
            AddProductView(viewModel: viewModel)
        }
        .sheet(isPresented: $showingRecommendations) {
            RecommendationsView(recommendations: viewModel.getRecommendations())
        }
    }
}

struct ProductRow: View {
    let product: Product
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ShoppingListViewModel
    
    init(product: Product) {
        self.product = product
        _viewModel = StateObject(wrappedValue: ShoppingListViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        HStack {
            Button {
                withAnimation {
                    viewModel.toggleProduct(product)
                }
            } label: {
                Image(systemName: product.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(product.isCompleted ? .green : .gray)
            }
            
            VStack(alignment: .leading) {
                Text(product.name ?? "")
                    .strikethrough(product.isCompleted)
                
                if let category = product.category, !category.isEmpty {
                    Text(category)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Text("\(product.quantity)")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

struct AddProductView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ShoppingListViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Details")) {
                    TextField("Name", text: $viewModel.newProductName)
                    TextField("Category", text: $viewModel.newProductCategory)
                    Stepper("Quantity: \(viewModel.newProductQuantity)", value: $viewModel.newProductQuantity, in: 1...99)
                }
            }
            .navigationTitle("Add Product")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Add") {
                    viewModel.addProduct()
                    dismiss()
                }
                .disabled(viewModel.newProductName.isEmpty)
            )
        }
    }
}

struct RecommendationsView: View {
    let recommendations: [String]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(recommendations, id: \.self) { item in
                Text(item)
            }
            .navigationTitle("Recommended Items")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
} 
