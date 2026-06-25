//
//  FlossyHomeCoordinator.swift
//  FlossyHome
//
//  Created by Lucas Migge de Barros on 20/06/26.
//

import SwiftUI

@MainActor
@Observable
final class FlossyHomeCoordinator {
    
    var path: NavigationPath = .init()
    var presentingSheet: SheetOption?
    
    enum SheetOption: Identifiable {
        var id: String {
            UUID().uuidString
        }
        
    }
    
    enum NavigationOption: Hashable {
        var id: String {
            UUID().uuidString
        }
    }
    
    func makeBaseView() -> some View {
        EmptyView()
    }
    
    func makeSheet(for sheetOption: SheetOption) -> AnyView {
        EmptyView().asAnyView()
    }
    
    func makeView(for navigationOption: NavigationOption) -> AnyView {
        EmptyView().asAnyView()
    }
}

extension View {
    func asAnyView() -> AnyView {
        AnyView(self)
    }
}

struct FlossyHomeCoordinatorView: View {
    
    @State var coordinator: FlossyHomeCoordinator = .init()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.makeBaseView()
                .sheet(item: $coordinator.presentingSheet) { sheetOption in
                    coordinator.makeSheet(for: sheetOption)
                }
                .navigationDestination(for: FlossyHomeCoordinator.NavigationOption.self) { navigationOption in
                    coordinator.makeView(for: navigationOption)
                }
        }
    }
}
