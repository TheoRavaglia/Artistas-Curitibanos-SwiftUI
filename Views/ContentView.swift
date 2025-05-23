import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GaleriaViewModel()
    
    // Colunas adaptativas: largura mínima 150pt
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Barra de pesquisa
                TextField("Buscar por título ou artista", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                // Grid de obras
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.filteredObras) { obra in
                            NavigationLink(value: obra) {
                                VStack {
                                    Image(obra.imagemNome)
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(maxWidth: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
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
                                        .stroke(Color.gray.opacity(0.3))
                                )
                            }
                        }
                    }
                    .padding(16)
                }
            }
            .navigationTitle("Galeria Curitibana")
            // Configura o destino da NavigationLink via navigationDestination
            .navigationDestination(for: ObraDeArte.self) { obra in
                DetalhesObraView(obra: obra)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
