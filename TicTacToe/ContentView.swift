import SwiftUI

struct ContentView: View {
    @StateObject var gameState: GameState
    
    var body: some View {
        let borderSize = CGFloat(5)
        
        VStack {
            HStack {
                Text(gameState.gameMode == .singlePlayer ? "Single Player" : "Multiplayer")
                    .font(.headline)
                
                Spacer()
                
                Button("Reset Game") {
                    gameState.resetGame()
                }
            }
            .padding(.horizontal)
            
            Text(gameState.turnText())
                .font(.title)
                .bold()
                .padding()
            
            Spacer()
            
            Text(String(format: "Crosses: %d", gameState.crossesScore))
                .font(.title)
                .bold()
                .padding()
            
            VStack(spacing: borderSize) {
                ForEach(0...2, id: \.self) { row in
                    HStack(spacing: borderSize) {
                        ForEach(0...2, id: \.self) { column in
                            let cell = gameState.board[row][column]
                            
                            Text(cell.displayTile())
                                .font(.system(size: 60))
                                .foregroundColor(cell.tileColor())
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .background(Color.white)
                                .onTapGesture {
                                    // Only allow human player to tap in single player mode
                                    if gameState.gameMode == .multiPlayer ||
                                       (gameState.gameMode == .singlePlayer && gameState.turn == .Cross) {
                                        gameState.placeTile(row, column)
                                    }
                                }
                        }
                    }
                }
            }
            .background(Color.black)
            .padding()
            .alert(isPresented: $gameState.showAlert) {
                Alert(
                    title: Text(gameState.alertMessage),
                    dismissButton: .default(Text("Okay")) {
                        gameState.resetBoard()
                    }
                )
            }
            
            Text(String(format: "Noughts: %d", gameState.noughtsScore))
                .font(.title)
                .bold()
                .padding()
            
            Spacer()
        }
    }
}


