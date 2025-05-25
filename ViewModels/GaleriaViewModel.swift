import Foundation
import Combine

/// ViewModel responsável por gerenciar o estado da galeria e a lógica de busca
final class GaleriaViewModel: ObservableObject {
    // MARK: - Propriedades Publicadas
    
    /// Lista completa de obras de arte
    @Published private(set) var obras: [ObraDeArte] = []
    
    /// Texto digitado na barra de busca
    @Published var searchText: String = ""
    
    /// Lista filtrada de obras baseada no texto de busca
    @Published private(set) var filteredObras: [ObraDeArte] = []
    
    /// Flag que indica se uma busca está em andamento
    @Published var isSearching: Bool = false
    
    // MARK: - Propriedades Privadas
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Inicialização
    
    init() {
        // Carrega os dados iniciais
        obras = DataManager.obras
        // Configura os observáveis
        setupBindings()
    }
    
    // MARK: - Configuração dos Bindings
    
    /// Configura os observáveis para a barra de busca
    private func setupBindings() {
        $searchText
            // Ativa flag de busca quando o texto muda
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isSearching = true
            })
            // Debounce para evitar buscas muito rápidas
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            // Ignora textos repetidos
            .removeDuplicates()
            // Aplica o filtro nas obras
            .map { [unowned self] text in
                text.isEmpty ? self.obras : self.obras.filter {
                    $0.titulo.localizedCaseInsensitiveContains(text) ||
                    $0.artista.localizedCaseInsensitiveContains(text)
                }
            }
            // Desativa flag de busca quando completa
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isSearching = false
            })
            // Atualiza a lista filtrada
            .assign(to: \.filteredObras, on: self)
            // Armazena a subscription
            .store(in: &cancellables)
    }
}
