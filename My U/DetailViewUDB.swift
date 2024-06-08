import SwiftUI
import Firebase
import FirebaseFirestore

class ImageViewModelUDB: ObservableObject {
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

struct DetailViewUDB: View {
    @State private var carreras: [CarreraUDB] = []

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
                            NavigationLink(destination: MateriasViewUDB(carreraId: carrera.id, carreraNombre: carrera.nombre)) {
                                CarreraCardViewUDB(imageName: carrera.imagen, title: carrera.nombre)
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
        db.collection("CarrerasUDB").getDocuments { snapshot, error in
            if let error = error {
                print("Error al obtener carreras: \(error)")
            } else if let snapshot = snapshot {
                carreras = snapshot.documents.compactMap { document in
                    var data = document.data()
                    data["id"] = document.documentID
                    return try? JSONDecoder().decode(CarreraUDB.self, from: JSONSerialization.data(withJSONObject: data))
                }
            }
        }
    }
}

struct CarreraCardViewUDB: View {
    let imageName: String
    let title: String

    @StateObject private var ImageViewModelUDB: ImageViewModelUDB

    init(imageName: String, title: String) {
        self.imageName = imageName
        self.title = title
      
        self._ImageViewModelUDB = StateObject(wrappedValue: My_U.ImageViewModelUDB(url: URL(string: imageName)!))
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = ImageViewModelUDB.image {
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

struct MateriasViewUDB: View {
    @State private var materias: [MateriaUDB] = []
    let carreraId: String
    let carreraNombre: String

    let db = Firestore.firestore()

    var body: some View {
        NavigationView {
            List(materias, id: \.id) { materia in
                HStack {
                    

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
        db.collection("CarrerasUDB").document(carreraId).collection("materias").getDocuments { snapshot, error in
            if let error = error {
                print("Error al obtener materias: \(error)")
            } else if let snapshot = snapshot {
                materias = snapshot.documents.compactMap { document in
                   
                    var data = document.data()
                    data["id"] = document.documentID
                    return try? JSONDecoder().decode(MateriaUDB.self, from: JSONSerialization.data(withJSONObject: data))
                }
            }
        }
    }
}




struct CarreraUDB: Identifiable, Codable {
    let id: String
    let nombre: String
    let imagen: String
}

struct MateriaUDB: Identifiable, Codable {
    let id: String
    let nombre: String
    let codigo: String
    let imagen: String
}


