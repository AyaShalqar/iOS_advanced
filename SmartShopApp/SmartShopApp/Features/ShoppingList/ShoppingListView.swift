import SwiftUI

struct ShoppingListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ShoppingListViewModel
    @State private var showingAddProduct = false

    init() {
        _viewModel = StateObject(wrappedValue: ShoppingListViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: { }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.orange)
                        .frame(width: 40, height: 40)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 1)
                }
                Spacer()
                Button(action: {
                    showingAddProduct = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.orange)
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Text("Shopping list 🛒")
                .font(.title2).bold()
                .padding(.vertical, 10)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.products) { product in
                        ProductRowStyled(product: product)
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingAddProduct) {
            AddProductView(viewModel: viewModel)
        }
    }
}

struct ProductRowStyled: View {
    let product: Product
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ShoppingListViewModel

    init(product: Product) {
        self.product = product
        _viewModel = StateObject(wrappedValue: ShoppingListViewModel(context: PersistenceController.shared.container.viewContext))
    }

    var body: some View {
        HStack(alignment: .center) {
            Button(action: {
                withAnimation {
                    viewModel.toggleProduct(product)
                }
            }) {
                Image(systemName: product.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(product.isCompleted ? .green : .gray)
                    .padding(10)
                    .background(Color(product.isCompleted ? .green.opacity(0.2) : .gray.opacity(0.2)))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Category")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(product.name ?? "NAME")
                    .font(.headline)
            }
            Spacer()

            HStack(spacing: 4) {
                Button("-") {
                    if product.quantity > 1 {
                        product.quantity -= 1
                        try? viewContext.save()
                    }
                }
                .frame(width: 28, height: 28)
                .background(Color(.systemGray5))
                .cornerRadius(6)

                Text("\(product.quantity)")
                    .frame(width: 24)

                Button("+") {
                    product.quantity += 1
                    try? viewContext.save()
                }
                .frame(width: 28, height: 28)
                .background(Color(.systemGray5))
                .cornerRadius(6)
            }

            Button(action: {
                viewModel.deleteProduct(product)
            }) {
                Image(systemName: "trash")
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
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
                    
                    TextField("Price", value: $viewModel.newProductPrice, format: .number)
                        .keyboardType(.decimalPad)

                    TextField("Store", text: $viewModel.newProductStore)

                    VStack(alignment: .leading) {
                        Text("Importance: \(viewModel.newProductImportance)")
                        Slider(value: Binding(
                            get: { Double(viewModel.newProductImportance) },
                            set: { viewModel.newProductImportance = Int16($0) }
                        ), in: 1...5, step: 1)
                    }
                    .padding(.vertical)
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
