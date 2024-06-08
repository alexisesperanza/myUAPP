//
//  ContentView.swift
//  My U
//
//  Created by Mi Mac on 4/20/24.
//

import SwiftUI

struct ContainerView: View {
    let imageName: String
    let title: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .padding()
            
            Text(title)
                .font(.headline)
        }
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
        .padding()
    }
}

struct ContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerView(imageName: "image1", title: "Container 1")
    }
}
