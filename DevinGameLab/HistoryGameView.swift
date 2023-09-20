//
//  HistoryGameView.swift
//  DevinGameLab
//
//  Created by dimitri on 20/09/2023.
//


import SwiftUI

struct HistoryGameView: View {
    @Binding var scoreHistoryBinding: [Int]
    var body: some View {
        VStack{
            ScrollView {
                ForEach(scoreHistoryBinding, id: \.self) { score in
                    HStack {
                        Image(systemName: "flag.fill")
                            .foregroundColor(.purple)
                            .font(.system(size: 28, weight: .semibold))
                            .padding(.trailing, 10)
                            .padding(.leading, 10)
                        Text("Score :")
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        Text("\(score) tentatives")
                            .font(.headline)
                            .padding(.leading, 5)
                            .padding(.trailing, 10)
                    }
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    HistoryGameView(scoreHistoryBinding: .constant([1, 4, 5]))
}
