import SwiftUI

struct DetalhesObraView: View {
    let obra: ObraDeArte

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(obra.imagemNome)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .padding(.horizontal)

                Text(obra.titulo)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                Text("Artista: \(obra.artista)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)

                Text("Ano: \(obra.ano)")
                    .font(.subheadline)
                    .padding(.horizontal)

                Text("Estilo: \(obra.estilo)")
                    .font(.subheadline)
                    .padding(.horizontal)

                if !obra.descricao.isEmpty {
                    Text(obra.descricao)
                        .font(.body)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetalhesObraView_Previews: PreviewProvider {
    static var previews: some View {
        // Exemplo de preview com mock
        DetalhesObraView(obra: ObraDeArte(
            titulo: "Exemplo",
            artista: "Artista X",
            ano: 2023,
            estilo: "Moderno",
            imagemNome: "photo",    // SF Symbol ou asset local
            descricao: "Descrição da obra de arte."
        ))
    }
}
