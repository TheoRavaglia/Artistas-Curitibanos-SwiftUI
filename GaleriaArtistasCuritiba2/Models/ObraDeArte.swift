import Foundation

struct ObraDeArte: Identifiable {
    let id: UUID
    let titulo: String
    let artista: String
    let ano: Int
    let estilo: String
    let imagemNome: String
    let descricao: String

    // inicializador “conveniente” que já gera um UUID
    init(
        id: UUID = UUID(),
        titulo: String,
        artista: String,
        ano: Int,
        estilo: String,
        imagemNome: String,
        descricao: String
    ) {
        self.id = id
        self.titulo = titulo
        self.artista = artista
        self.ano = ano
        self.estilo = estilo
        self.imagemNome = imagemNome
        self.descricao = descricao
    }
}
