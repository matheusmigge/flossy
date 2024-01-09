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
    @State var showAlert = false
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        GeometryReader { screen in
            VStack {
                
                Text("Last time you flossed:")
                    .font(.caption)
                    .padding(.top, 100)
                    
                Text("\(viewModel.formatedLastFloss)")
                    .font(.subheadline)
                    .bold()
                    .padding(.bottom, 20)
                
                Spacer()
                
                Text("How many times you flossed until now:")
                    .font(.caption)
                
                Text("\(viewModel.formatedFlossCount)")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                
                Button("Enter log") {
                    showAlert = true
                }
                .buttonStyle(.borderedProminent)
                .padding(.bottom, 50)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Have you really flossed?"),
                        primaryButton: .destructive(Text("Dismiss")),
                        secondaryButton:
                            .default(Text("I've flossed! ").bold()) {
                                viewModel.flossButtonPressed()
                            }
                    )
                }
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
