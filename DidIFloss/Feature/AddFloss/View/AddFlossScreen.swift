//
//  AddFlossView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 31/01/24.
//

import SwiftUI
import FlossyDesignSystem

struct AddFlossScreen: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var viewModel: AddFlossViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 50) {
                    
                    @Bindable var bindableViewModel = viewModel
                    DatePicker("datePicker", selection: $bindableViewModel.selectedDate)
                        .datePickerStyle(.graphical)
                        .tint(FlossyColors.greenyBlue)
                    
                    Button {
                        Task { await viewModel.addLogRecord() }
                    } label: {
                        Text("Add")
                            .bold()
                            .foregroundStyle(colorScheme == .light ? Color.white : Color.black)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accentColor)
                            }
                            
                    }
                    .disabled(!viewModel.isSelectedDateValid)
                    .opacity(viewModel.isSelectedDateValid ? 1 : 0.75)
                    .overlay {
                        if !viewModel.isSelectedDateValid {
                            Text("You may not add records in the future ")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .offset(y: -50)
                        }
                    }
                    
                }
                .padding(.horizontal)
                .toolbar {
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            Task { await viewModel.addLogRecord() }
                        } label: {
                            Text("Add")
                                .bold()
                        }
                        .disabled(!viewModel.isSelectedDateValid)
                    }
                }
     
            }
        }
        .presentationDetents([.fraction(0.75), .large])
        .presentationCornerRadius(25)
        .presentationBackground(Material.regular)
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

#Preview {
    AddFlossScreen(viewModel: AddFlossViewModel())
}
