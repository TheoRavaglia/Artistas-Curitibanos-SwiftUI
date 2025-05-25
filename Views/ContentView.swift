import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GaleriaViewModel()
    
    // Colunas adaptativas: largura mínima 150pt
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                obrasGrid
            }
            .navigationTitle("Galeria Curitibana")
            .navigationDestination(for: ObraDeArte.self) { obra in
                DetalhesObraView(obra: obra)
            }
        }
    }
    
    // MARK: - Subviews
    
    private var searchBar: some View {
        TextField("Buscar por título ou artista", text: $viewModel.searchText)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 16)
            .padding(.top, 8)
    }
    
    private var obrasGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.filteredObras) { obra in
                    NavigationLink(value: obra) {
                        ObraCell(obra: obra)
                    }
                }
            }
            .padding(16)
        }
    }
}

struct ObraCell: View {
    let obra: ObraDeArte
    
    var body: some View {
        VStack {
            Image(obra.imagemNome)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(8)
            
            Text(obra.titulo)
                .font(.headline)
                .lineLimit(1)
            
            Text(obra.artista)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray.opacity(0.3))
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
