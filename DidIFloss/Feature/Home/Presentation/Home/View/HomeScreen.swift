//
//  HomeView.swift
//  DidIFloss
//
//  Created by Matheus Migge on 23/01/24.
//

import SwiftUI
import FlossyDesignSystem

struct HomeScreen: Screen {
    @Namespace var animation
    
    @State var viewModel: HomeViewModel
    
    var recordsDates: [Date] {
        viewModel.flossRecords.map { $0.date }
    }
    
    var body: some View {
        NavigationStack {
            List {
                BannerSectionView()
                
                WarningBannerView(model: viewModel.streakBoardViewModel.warmingBoardContent)
                    .listRowSeparator(.hidden)
                
                HStack {
                    Spacer()
                    
                    StreakBoardView(model: viewModel.streakBoardViewModel.streakBoardContent)
                        .padding(.top, 5)
                        .padding(.bottom, 20)
                        .listRowSeparator(.hidden)
                        .onTapGesture(count: 3, perform: {
                            viewModel.goToDeveloperScreen()
                        })
                    
                    Spacer()
                }
                .onTapGesture {
                    viewModel.presentShareSheet()
                }
                
                Section {
                    WeekCalendarView(records: recordsDates, delegate: viewModel)
                        .padding(.vertical, 7.5)
                }
                
                BannerSectionView()
            }
            .listSectionSpacing(25)
            .buttonStyle(.borderless)
            .overlay {
                if viewModel.showingCelebration {
                    CelebrationView(delegate: self.viewModel)
                }
            }
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.presentShareSheet()

                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.plusButtonPressed()

                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(viewModel.showingCelebration)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.goToLogRecords()
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
            }
        }
        .alert("Would you like to remove all records for this day?", isPresented: $viewModel.showingAlert, actions: {
            Button("Remove Records", role: .destructive) {
                viewModel.removeRecordsForFocusedDate()
            }
            
            Button("Cancel", role: .cancel) {
                viewModel.alertDismiss()
            }
      
        })
        .onAppear {
            viewModel.onAppear()
            Task {
                await viewModel.viewDidAppear()
            }
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

#Preview {
    HomeScreen(viewModel: HomeViewModel())
}
