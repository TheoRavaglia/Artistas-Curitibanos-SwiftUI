import Foundation
import Combine

/// ViewModel para gerenciar a lista de obras e lógica de filtragem
final class GaleriaViewModel: ObservableObject {
    // Todas as obras carregadas
    @Published private(set) var obras: [ObraDeArte] = []
    
    // Texto de busca digitado pelo usuário
    @Published var searchText: String = ""
    
    // Obras resultantes após aplicação do filtro de busca
    @Published private(set) var filteredObras: [ObraDeArte] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Carrega os dados iniciais do DataManager
        obras = DataManager.obras
        
        // Configura o pipeline de busca e filtragem
        setupBindings()
    }
    
    /// Configura listeners para updates de `searchText` e aplica filtro nas `obras`
    private func setupBindings() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { [unowned self] text -> [ObraDeArte] in
                guard !text.isEmpty else {
                    // Se não há texto, retorna todas as obras
                    return self.obras
                }
                // Filtra por título ou artista
                return self.obras.filter { obra in
                    obra.titulo.localizedCaseInsensitiveContains(text) ||
                    obra.artista.localizedCaseInsensitiveContains(text)
                }
            }
            .assign(to: \ .filteredObras, on: self)
            .store(in: &cancellables)
    }
}
