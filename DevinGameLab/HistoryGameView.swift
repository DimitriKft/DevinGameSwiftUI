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
                // Vérifiez si c'est la meilleure entrée
                if let best = bestEntry(), entry.id == best.id {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                } else if entry.wasVictory {
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


    }
    func bestEntry() -> DevinGameView.GameHistoryEntry? {
        return scoreHistoryBinding.filter { $0.wasVictory }.min(by: { $0.attempts < $1.attempts })
    }
}



#Preview {
    HistoryGameView(scoreHistoryBinding: .constant([DevinGameView.GameHistoryEntry(date: Date(), attempts: 3, wasVictory: true)]))
}
