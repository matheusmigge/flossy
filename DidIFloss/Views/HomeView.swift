//
//  HomeView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 23/01/24.
//

import SwiftUI

struct HomeView: View {
    
    enum Contents {
        case noLogsRecorded, someLogRecorded
    }
    
    @State var currentContent: Contents = .someLogRecorded
    @State var flossRecords: [FlossRecord] = []
    
    var body: some View {
        
            List {
                Section {
                    BannerView()
                }.listRowInsets(.init(top: -20, leading: -20, bottom: -20, trailing: -20))
                
                
                ZStack {
                    
                    Rectangle()
                        .foregroundStyle(.flamingoPink)
                    
                    Text("⚠️ Você ainda não passou fio dental hoje. Cuidado para não perder o seu combo!")
                        .padding(20)
                        .foregroundStyle(.primary)
                        .font(.caption)
                }
                .listRowInsets(.init(top: -10, leading: -10, bottom: -10, trailing: -10))
                
                VStack {
                    HStack {
                        ZStack {
                            Text("5 dias seguidos!")
                                .font(.system(size: 35))
                                .fontWeight(.black)
                                .foregroundStyle(.lightYellow)
                            
                            Text("5 dias seguidos!")
                                .font(.system(size: 35))
                                .fontWeight(.black)
                                .offset(x: 3, y: -3)
                                .foregroundStyle(.flamingoPink)
                        }
                    }
                    .padding(.top)
                    .foregroundStyle(Color("sky-blue"))
                    
                    switch currentContent {
                        
                    case .noLogsRecorded:
                        Text("Nenhum log???")
                            .font(.title)
                    
                        
                    case .someLogRecorded:
                        VStack {
                            Text("Muito bem!! Você já está há 5 dias seguidos passando fio dental. Continue assim!")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                
                CalendarView(records: $flossRecords, style: .week)
                
                Section {
                    BannerView()
                }.listRowInsets(.init(top: -20, leading: -20, bottom: -20, trailing: -20))
            }
            .buttonStyle(.borderless)
            
            .onAppear() {
                let persistance = PersistanceManager()
                persistance.getFlossRecords { records in
                    self.flossRecords = records
                }
            }
        
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "plus")
            }
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "calendar")
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
}
