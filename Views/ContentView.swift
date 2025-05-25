import SwiftUI

struct ContentView: View {
    // ViewModel para gerenciar os dados e estado
    @StateObject private var viewModel = GaleriaViewModel()
    
    // Configuração das colunas da grid (adaptativa com mínimo de 150pt)
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
            // Navegação para tela de detalhes
            .navigationDestination(for: ObraDeArte.self) { obra in
                DetalhesObraView(obra: obra)
            }
        }
        // Animação para mudanças na lista filtrada
        .animation(.default, value: viewModel.filteredObras)
    }
    
    // Barra de busca com indicador de loading
    private var searchBar: some View {
        TextField("Buscar por título ou artista", text: $viewModel.searchText)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .overlay(
                HStack {
                    Spacer()
                    // Mostra spinner durante a busca
                    if viewModel.isSearching {
                        ProgressView()
                            .padding(.trailing, 25)
                            .transition(.opacity)
                    }
                }
            )
            // Animação suave ao mostrar/ocultar spinner
            .animation(.easeInOut, value: viewModel.isSearching)
    }
    
    // Grid de obras com animações
    private var obrasGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.filteredObras.indices, id: \.self) { index in
                    let obra = viewModel.filteredObras[index]
                    
                    // Célula clicável que navega para detalhes
                    NavigationLink(value: obra) {
                        ObraCell(obra: obra)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            // Efeito de fade-in com delay progressivo
                            .opacity(viewModel.isSearching ? 0 : 1)
                            .animation(
                                .easeInOut(duration: 0.3)
                                .delay(Double(index) * 0.03),
                                value: viewModel.filteredObras
                            )
                    }
                    .buttonStyle(.plain) // Remove estilo padrão do botão
                }
            }
            .padding(16)
        }
        .background(Color(.secondarySystemBackground))
    }
}

// Célula individual da obra de arte
struct ObraCell: View {
    let obra: ObraDeArte
    @State private var isPressed = false // Estado para animação de toque
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Imagem da obra (proporção quadrada)
            Image(obra.imagemNome)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(8)
            
            // Informações textuais
            VStack(alignment: .leading, spacing: 4) {
                Text(obra.titulo)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                Text(obra.artista)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 4)
        }
        .padding(12)
        // Efeito de escala ao tocar
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.interactiveSpring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        // Gestos para detectar toque
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// Preview para desenvolvimento
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
