//
//  DevinGameView.swift
//  DevinGameLab
//
//  Created by dimitri on 20/09/2023.
//
//
import SwiftUI
import SwiftUI

struct DevinGameView: View {
    @State private var target = Int.random(in: 1...100)
    @State private var guess = ""
    @State private var attempts = 10
    @State private var bestAttempts = UserDefaults.standard.integer(forKey: "BestAttempts")
    @State private var hint = ""
    @State private var scoreHistory: [Int] = UserDefaults.standard.array(forKey: "ScoreHistory") as? [Int] ?? []
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
                        .frame(width: 150, height: 150) // Ajustez la largeur et la hauteur selon vos besoins
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center) // Centre le texte entré par l'utilisateur
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
                        totalAttempts += currentScore // Mettez à jour le nombre d'essais ici
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
                scoreHistory.append(currentScore)
                UserDefaults.standard.set(scoreHistory, forKey: "ScoreHistory")
                showVictoryAlert = true
            } else if guessValue < target {
                hint = "Le nombre caché est plus grand."
                attempts -= 1
                if attempts == 0 {
                    hint = "Désolé, vous avez épuisé vos essais. Le nombre caché était \(target)."
                    hasLost = true
                    showVictoryAlert = true
                }
            } else {
                hint = "Le nombre caché est plus petit."
                attempts -= 1
                if attempts == 0 {
                    hint = "Désolé, vous avez épuisé vos essais. Le nombre caché était \(target)."
                    hasLost = true
                    showVictoryAlert = true
                }
            }
        } else {
            hint = "Veuillez entrer un nombre valide."
        }
    }

    func startNewGame() {
        target = Int.random(in: 1...100)
        guess = ""
        attempts = 10
        hint = ""
        hasLost = false
    }

    func getColorForRemainingAttempts(_ remainingAttempts: Int) -> Color {
        let maxAttempts = 10.0
        let percentage = Double(remainingAttempts) / maxAttempts
        
        let redValue = min(1.0, 1.0 * (1 - percentage) + 0.2)
        let greenValue = max(0.0, 0.8 * percentage)
        let blueValue = max(0.0, 0.8 * percentage)
        
        return Color(red: redValue, green: greenValue, blue: blueValue)
    }
}




#Preview {
    DevinGameView()
}
