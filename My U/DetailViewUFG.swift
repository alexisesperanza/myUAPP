import SwiftUI
import Firebase
import FirebaseFirestore

class ImageViewModelUFG: ObservableObject {
    @Published var image: UIImage?

    init(url: URL) {
        loadImage(from: url)
    }

    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            } else if let error = error {
                print("Error al cargar la imagen: \(error.localizedDescription)")
              
            }
        }.resume()
    }
}

struct DetailViewUFG: View {
    @State private var carreras: [CarreraUFG] = []

    let db = Firestore.firestore()
    let title: String

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Selecciona la carrera:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    LazyVGrid(columns: [GridItem(), GridItem()], spacing: 20) {
                        ForEach(carreras, id: \.id) { carrera in
                            NavigationLink(destination: MateriasViewUFG(carreraId: carrera.id, carreraNombre: carrera.nombre)) {
                                CarreraCardViewUFG(imageName: carrera.imagen, title: carrera.nombre)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle(title)
            .onAppear {
                fetchCarreras()
            }
        }
    }

    func fetchCarreras() {
        db.collection("CarrerasUFG").getDocuments { snapshot, error in
            if let error = error {
                print("Error al obtener carreras: \(error)")
            } else if let snapshot = snapshot {
                carreras = snapshot.documents.compactMap { document in
                    var data = document.data()
                    data["id"] = document.documentID
                    return try? JSONDecoder().decode(CarreraUFG.self, from: JSONSerialization.data(withJSONObject: data))
                }
            }
        }
    }
}

struct CarreraCardViewUFG: View {
    let imageName: String
    let title: String

    @StateObject private var ImageViewModelUFG: ImageViewModelUFG

    init(imageName: String, title: String) {
        self.imageName = imageName
        self.title = title
     
        self._ImageViewModelUFG = StateObject(wrappedValue: My_U.ImageViewModelUFG(url: URL(string: imageName)!))
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = ImageViewModelUFG.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 150)
                    .clipped()
            } else {
                ProgressView()
            }

            LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)

            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
        }
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct MateriasViewUFG: View {
    @State private var materias: [MateriaUFG] = []
    let carreraId: String
    let carreraNombre: String

    let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            List(materias, id: \.id) { materia in
                HStack {
                    // Vista para la imagen

                    Text(materia.nombre)
                        .font(.headline)
                    Spacer()
                    Text(materia.codigo)
                        .font(.subheadline)
                }
            }
            .navigationTitle(carreraNombre)
            .onAppear {
                fetchMaterias()
            }
        }
    }

    func fetchMaterias() {
        db.collection("CarrerasUFG").document(carreraId).collection("materias").getDocuments { snapshot, error in
            if let error = error {
                print("Error al obtener materias: \(error)")
            } else if let snapshot = snapshot {
                materias = snapshot.documents.compactMap { document in
                  
                    var data = document.data()
                    data["id"] = document.documentID
                    return try? JSONDecoder().decode(MateriaUFG.self, from: JSONSerialization.data(withJSONObject: data))
                }
            }
        }
    }
}




struct CarreraUFG: Identifiable, Codable {
    let id: String
    let nombre: String
    let imagen: String
}

struct MateriaUFG: Identifiable, Codable {
    let id: String
    let nombre: String
    let codigo: String
    let imagen: String
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewUFG(title: "Selecciona la carrera que deseas ver las materias")
    }
}
