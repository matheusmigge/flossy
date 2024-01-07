//
//  ContentView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 27/12/23.
//

import SwiftUI

struct ContentView: View {
    
    enum Contents {
        case empty, content
    }
    
    @State var currentContent: Contents = .empty
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        GeometryReader { screen in
            VStack {
                
                Text("Did I Floss?")
                    .font(.title)
                    .bold()
                    .padding(.top, 100)
                    .padding(.bottom, 20)
                
                
                Text("Last time you flossed:")
                    .font(.caption)
                Text("\(viewModel.formatedLastFloss)")
                
                Spacer()
                
                Text("How many times you flossed until now:")
                    .font(.caption2)
                
                Text("\(viewModel.formatedFlossCount)")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                
                Button("I've flossed! 🎉") {
                    viewModel.flossButtonPressed()
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 50)
            }
            .frame(width: screen.size.width, height: screen.size.height)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
        }
    }
}
#Preview {
    NavigationView{
        ContentView()
    }
    
}
