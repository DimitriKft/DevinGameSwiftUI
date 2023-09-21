//
//  HistoryGameView.swift
//  DevinGameLab
//
//  Created by dimitri on 20/09/2023.
//


import SwiftUI


struct HistoryGameView: View {
    @Binding var scoreHistoryBinding: [DevinGameView.GameHistoryEntry]

    var body: some View {
        List(scoreHistoryBinding.reversed(), id: \.id) { entry in
            HStack {
                if entry.wasVictory {
                    Image(systemName: "flag.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                }

                VStack(alignment: .leading) {
                    Text("Date : \(entry.date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.headline)
                    Text("Tentatives : \(entry.attempts)")
                        .font(.subheadline)
                }
            }
        }
        .navigationBarTitle("Historique des parties", displayMode: .inline)
    }
}


#Preview {
    HistoryGameView(scoreHistoryBinding: .constant([DevinGameView.GameHistoryEntry(date: Date(), attempts: 3, wasVictory: true)]))
}
