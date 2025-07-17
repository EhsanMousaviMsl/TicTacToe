import SwiftUI

struct ModeSelectionView: View {
    @StateObject var gameState = GameState()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Tic Tac Toe")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                
                
                NavigationLink {
                    ContentView(gameState: gameState)
                } label: {
                    Text("Single Player")
                        .font(.title)
                        .padding()
                        .frame(width: 200)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    gameState.gameMode = .singlePlayer
                })
                NavigationLink {
                    ContentView(gameState: gameState)
                } label: {
                    Text("Multiplayer")
                        .font(.title)
                        .padding()
                        .frame(width: 200)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    gameState.gameMode = .multiPlayer
                })
                
                Spacer()
            }
            .padding()
        }
    }
}


#Preview {
    ModeSelectionView()
}
