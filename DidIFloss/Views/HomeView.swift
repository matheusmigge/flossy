//
//  HomeView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 23/01/24.
//

import SwiftUI

struct HomeView: View {
    @Namespace var animation
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var currentStreakState: HomeViewModel.State {
        viewModel.streakStatus
    }
    
    var dayStreak: Int {
        viewModel.streakCount
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    BannerView()
                }.listRowInsets(.init(top: -20, leading: -20, bottom: -20, trailing: -20))
                
                ZStack {
                    Rectangle()
                        .foregroundStyle(.flamingoPink)
                    
                    switch viewModel.streakStatus {
                        
                    case .noLogsRecorded:
                        Text("NO LOGS ⚠️")
                            .padding(20)
                            .foregroundStyle(.primary)
                            .font(.caption)
                        
                        
                    case .positiveStreak:
                        VStack {
                            if viewModel.userHasLoggedToday {
                                
                                Text("🫡 O de hoje tá pago!")
                                    .padding(20)
                                    .foregroundStyle(.primary)
                                    .font(.caption)
                            } else {
                                
                                Text("⚠️ Você ainda não passou fio dental hoje. Cuidado para não perder o seu combo!")
                                    .padding(20)
                                    .foregroundStyle(.primary)
                                    .font(.caption)
                            }
                            
                        }
                    case .negativeStreak:
                        Text("NEGATIVE STREAK ❌")
                            .padding(20)
                            .foregroundStyle(.primary)
                            .font(.caption)
                    }
                }
                .listRowInsets(.init(top: -10, leading: -10, bottom: -10, trailing: -10))
                
                VStack {
                    HStack {
                        Spacer()
                        ZStack {
                            Text("\(dayStreak) dias seguidos!")
                                .font(.system(size: 35))
                                .fontWeight(.black)
                                .foregroundStyle(.lightYellow)
                            
                            Text("\(dayStreak) dias seguidos!")
                                .font(.system(size: 35))
                                .fontWeight(.black)
                                .offset(x: 3, y: -3)
                                .foregroundStyle(.flamingoPink)
                        }
                        Spacer()
                    }
                    .padding(.top)
                    .foregroundStyle(Color("sky-blue"))
                    
                    switch viewModel.streakStatus {
                        
                    case .noLogsRecorded:
                        Text("NO LOGS ⚠️")
                            .font(.title)
                        
                    case .positiveStreak:
                        VStack {
                            Text("POSITIVE STREAK ✅")
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                    case .negativeStreak:
                        Text("NEGATIVE STREAK ❌")
                            .font(.title)
                    }
                }
                .listRowSeparator(.hidden)
                
                CalendarView(records: $viewModel.flossRecords, style: .week)
                
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
                    NavigationLink {
                        LogRecordsView(viewModel: ContentViewModel())
                        
                    } label: {
                        Image(systemName: "calendar")
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .tint(Color.primary)
    }
}

#Preview {
    HomeView()
    
}
