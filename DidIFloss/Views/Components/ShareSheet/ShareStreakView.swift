//
//  ShareStreakView.swift
//  DidIFloss
//
//  Created by Lucas Migge on 31/03/24.
//

import SwiftUI


struct ShareStreakView: UIViewControllerRepresentable {

    let streakDescription: String

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareStreakView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [streakDescription], applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
                                context: UIViewControllerRepresentableContext<ShareStreakView>) {

    }
}
