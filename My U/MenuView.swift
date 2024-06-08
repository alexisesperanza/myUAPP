//
//  MenuView.swift
//  My U
//
//  Created by Mi Mac on 4/20/24.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        Menu {
            Button(action: {
                // Handle exit action
            }) {
                Label("Salir", systemImage: "power")
            }
            
            Button(action: {
                // Handle dark mode switch action
            }) {
                Label("Modo oscuro", systemImage: "moon.fill")
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .font(.title)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
