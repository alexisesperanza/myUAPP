import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Selecciona la universidad que deseas consultar:")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 20)

                    NavigationLink(destination: DetailViewUTEC(title: "Universidad Tecnológica de El Salvador")) {
                        ZStack(alignment: .bottomLeading) { // ZStack para el contenedor de UTEC
                            Image("logoUTEC")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 250)
                                .clipped()
                            
                            LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                            
                            Text("Universidad Tecnológica")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    .buttonStyle(PlainButtonStyle())

                    HStack(spacing: 20) {
                        NavigationLink(destination: DetailViewUDB(title: "Universidad Don Bosco")) {
                            ZStack(alignment: .bottomLeading) { // ZStack para el contenedor de UDB
                                Image("logoUDB")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 150)
                                    .clipped()

                                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)

                                Text("Universidad Don Bosco")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        .buttonStyle(PlainButtonStyle())

                        NavigationLink(destination: DetailViewUFG(title: "Universidad Francisco Gavidia")) {
                            ZStack(alignment: .bottomLeading) { // ZStack para el contenedor de UFG
                                Image("logoUFG")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 150)
                                    .clipped()

                                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)

                                Text("Universidad Francisco Gavidia")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("My U App")
            .navigationBarItems(trailing: MenuView())
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
