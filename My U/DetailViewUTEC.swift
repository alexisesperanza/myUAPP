import SwiftUI
import Firebase
import FirebaseFirestore

class ImageViewModel: ObservableObject {
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
                // Maneja el error (por ejemplo, muestra una imagen predeterminada)
            }
        }.resume()
    }
}

struct DetailViewUTEC: View {
    @State private var carreras: [Carrera] = []

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
                            NavigationLink(destination: MateriasView(carrera: carrera)) {
                                CarreraCardView(imageName: carrera.imagen, title: carrera.nombre)
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
        db.collection("CarrerasUTEC").getDocuments { snapshot, error in
            if let error = error {
                print("Error al obtener carreras: \(error)")
            } else if let snapshot = snapshot {
                carreras = snapshot.documents.compactMap { document in
                    var data = document.data()
                    data["id"] = document.documentID
                    return try? JSONDecoder().decode(Carrera.self, from: JSONSerialization.data(withJSONObject: data))
                }
            }
        }
    }
}

struct CarreraCardView: View {
    let imageName: String
    let title: String

    @StateObject private var imageViewModel: ImageViewModel

    init(imageName: String, title: String) {
        self.imageName = imageName
        self.title = title
        // Corrección: Usa un signo de interrogación para inicializar con un valor opcional
        self._imageViewModel = StateObject(wrappedValue: ImageViewModel(url: URL(string: imageName)!))
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = imageViewModel.image {
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

struct MateriasView: View {
    @State private var materias: [Materia] = []
    let carrera: Carrera

    let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            List(materias, id: \.id) { materia in
                HStack {
                    // Vista para la imagen
                    
                    
                    Text(materia.nombre)
                }
            }
            .navigationTitle(carrera.nombre)
            .onAppear {
                fetchMaterias(carreraId: carrera.id)
            }
        }
    }

    func fetchMaterias(carreraId: String) {
        db.collection("CarrerasUTEC").document(carreraId).collection("materias").getDocuments { snapshot, error in
            if let error = error {
                print("Error al obtener materias: \(error)")
            } else if let snapshot = snapshot {
                materias = snapshot.documents.compactMap { document in
                    var data = document.data()
                    data["id"] = document.documentID
                    return try? JSONDecoder().decode(Materia.self, from: JSONSerialization.data(withJSONObject: data))
                }
            }
        }
    }
}

// Vista para la imagen de la materia


struct Carrera: Identifiable, Codable {
    let id: String
    let nombre: String
    let imagen: String
}

struct Materia: Identifiable, Codable {
    let id: String
    let nombre: String
    let codigo: String
    let imagen: String
}

