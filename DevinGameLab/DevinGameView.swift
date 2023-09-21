//
//  DevinGameView.swift
//  DevinGameLab
//
//  Created by dimitri on 20/09/2023.
//
//
import SwiftUI

struct DevinGameView: View {
    struct GameHistoryEntry: Identifiable, Codable {
        var id = UUID()
        let date: Date
        let attempts: Int
        let wasVictory: Bool
    }

    @State private var target = Int.random(in: 1...100)
    @State private var guess = ""
    @State private var attempts = 10
    @State private var bestAttempts = UserDefaults.standard.integer(forKey: "BestAttempts")
    @State private var hint = ""
    @State private var scoreHistory: [GameHistoryEntry] = {
        if let data = UserDefaults.standard.value(forKey: "ScoreHistory") as? Data,
           let scoreHistory = try? PropertyListDecoder().decode([GameHistoryEntry].self, from: data) {
            return scoreHistory
        } else {
            return []
        }
    }()
    @State private var showVictoryAlert = false
    @State private var totalAttempts = 0
    @State private var hasLost = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Devinez le nombre entre 1 et 100")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .padding()

                VStack {
                    Text("Entrez votre estimation")
                        .font(.title)
                        .foregroundColor(Color.blue)
                        .padding(.top, 20)
                    
                    TextField("", text: $guess)
                        .font(.largeTitle)
                        .padding()
                        .frame(width: 150, height: 150)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                )
                        )
                        .padding(.horizontal, 40)
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                }

                Button(action: checkGuess) {
                    Text("Devinez")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 5)
                }
                .padding(.horizontal, 40)

                HStack(alignment: .center, spacing: 10) {
                    Text("Il reste")
                        .font(.title2)
                        .foregroundColor(Color.gray)
                    Text("\(attempts)")
                        .font(.system(size: getFontSizeForRemainingAttempts(attempts)))
                        .fontWeight(.bold)
                        .foregroundColor(getColorForRemainingAttempts(attempts))
                    Text("Essais")
                        .font(.title2)
                        .foregroundColor(Color.gray)
                }

                Text(hint)
                    .font(.headline)
                    .padding(10)
                    .background(hint.isEmpty ? Color.clear : Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)

                NavigationLink(destination: HistoryGameView(scoreHistoryBinding: $scoreHistory)) {
                    Text("Historique des parties")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.purple)
                }
                .padding(.top, 10)
                
                Spacer()
                
                Text("Meilleur score : \(bestAttempts) tentatives")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .padding(.bottom)
            }
            .padding(.top, 20)
            .background(Color(.systemBackground))
        }
        .alert(isPresented: $showVictoryAlert) {
            if hasLost {
                return Alert(
                    title: Text("Dommage!"),
                    message: Text("Vous n'avez pas trouvé le nombre caché en 10 essais. Le nombre caché était \(target)."),
                    dismissButton: .default(Text("Nouvelle partie")) {
                        startNewGame()
                    }
                )
            } else {
                let currentScore = 10 - attempts + 1
                return Alert(
                    title: Text("Félicitations!"),
                    message: Text("Vous avez trouvé le nombre caché en \(currentScore) essais."),
                    dismissButton: .default(Text("Nouvelle partie")) {
                        totalAttempts += currentScore
                        startNewGame()
                    }
                )
            }
        }
    }

    func getFontSizeForRemainingAttempts(_ remainingAttempts: Int) -> CGFloat {
        let minSize: CGFloat = 20
        let maxSize: CGFloat = 80
        let step = (maxSize - minSize) / 9.0
        return maxSize - step * CGFloat(remainingAttempts - 1)
    }
    
    func checkGuess() {
        if let guessValue = Int(guess) {
            if guessValue == target {
                let currentScore = 10 - attempts + 1
                hint = "Bravo ! Vous avez trouvé le nombre en \(currentScore) tentatives."
                if currentScore < bestAttempts || bestAttempts == 0 {
                    bestAttempts = currentScore
                    UserDefaults.standard.set(bestAttempts, forKey: "BestAttempts")
                }
                let entry = GameHistoryEntry(date: Date(), attempts: currentScore, wasVictory: true)
                scoreHistory.append(entry)
                UserDefaults.standard.set(try? PropertyListEncoder().encode(scoreHistory), forKey: "ScoreHistory")
                showVictoryAlert = true
            } else if guessValue < target {
                hint = "Le nombre caché est plus grand."
                attempts -= 1
                if attempts == 0 {
                    hint = "Désolé, vous avez épuisé vos essais. Le nombre caché était \(target)."
                    hasLost = true
                    let entry = GameHistoryEntry(date: Date(), attempts: 10, wasVictory: false)
                    scoreHistory.append(entry)
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(scoreHistory), forKey: "ScoreHistory")
                    showVictoryAlert = true
                }
            } else {
                hint = "Le nombre caché est plus petit."
                attempts -= 1
                if attempts == 0 {
                    hint = "Désolé, vous avez épuisé vos essais. Le nombre caché était \(target)."
                    hasLost = true
                    let entry = GameHistoryEntry(date: Date(), attempts: 10, wasVictory: false)
                    scoreHistory.append(entry)
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(scoreHistory), forKey: "ScoreHistory")
                    showVictoryAlert = true
                }
            }
        }
    }

    func startNewGame() {
        attempts = 10
        target = Int.random(in: 1...100)
        hint = ""
        guess = ""
    }
    
    func getColorForRemainingAttempts(_ remainingAttempts: Int) -> Color {
        switch remainingAttempts {
        case 1...3:
            return Color.red
        case 4...6:
            return Color.orange
        default:
            return Color.green
        }
    }
}




#Preview {
    DevinGameView()
}
