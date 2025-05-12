import SwiftUI

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PurchaseHistory.date, ascending: false)],
        animation: .default)
    private var purchaseHistory: FetchedResults<PurchaseHistory>
    
    var body: some View {
        List {
            ForEach(purchaseHistory) { history in
                Section(header: Text(formatDate(history.date ?? Date()))) {
                    ForEach(history.products?.allObjects as? [Product] ?? []) { product in
                        HStack {
                            Text(product.name ?? "")
                            Spacer()
                            Text("Qty: \(product.quantity)")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationTitle("Purchase History")
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
} 