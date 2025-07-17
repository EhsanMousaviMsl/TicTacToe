import Foundation

enum GameMode {
    case singlePlayer
    case multiPlayer
}

class GameState: ObservableObject
{
    @Published var board = [[Cell]]()
    @Published var turn = Tile.Cross
    @Published var noughtsScore = 0
    @Published var crossesScore = 0
    @Published var showAlert = false
    @Published var alertMessage = "Draw"
    @Published var gameMode: GameMode = .multiPlayer
    
    
    
    
    init()
    {
        resetBoard()
    }
    
    func turnText() -> String
    {
        return turn == Tile.Cross ? "Turn: X" : "Turn: O"
    }
    
    func placeTile(_ row: Int, _ column: Int) {
        if board[row][column].tile != Tile.Empty {
            return
        }
        
        board[row][column].tile = turn == Tile.Cross ? Tile.Cross : Tile.Nought
        
        if checkForVictory() {
            if turn == Tile.Cross {
                crossesScore += 1
            } else {
                noughtsScore += 1
            }
            let winner = turn == Tile.Cross ? "Crosses" : "Noughts"
            alertMessage = winner + " Win!"
            showAlert = true
        } else if checkForDraw() {
            alertMessage = "Draw"
            showAlert = true
        } else {
            turn = turn == Tile.Cross ? Tile.Nought : Tile.Cross
            

            if gameMode == .singlePlayer && turn == Tile.Nought {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.makeAIMove()
                }
            }
        }
    }
    
    private func makeAIMove() {
            var availableMoves = [(Int, Int)]()
            
            for (rowIndex, row) in board.enumerated() {
                for (colIndex, cell) in row.enumerated() {
                    if cell.tile == Tile.Empty {
                        availableMoves.append((rowIndex, colIndex))
                    }
                }
            }
            
            if let randomMove = availableMoves.randomElement() {
                placeTile(randomMove.0, randomMove.1)
            }
        }

    
    func checkForDraw() -> Bool
    {
        for row in board
        {
            for cell in row
            {
                if cell.tile == Tile.Empty
                {
                    return false
                }
            }
        }
        
        return true
    }
    
    func checkForVictory() -> Bool
    {
        // vertical victory
        if isTurnTile(0, 0) && isTurnTile(1, 0) && isTurnTile(2, 0)
        {
            return true
        }
        if isTurnTile(0, 1) && isTurnTile(1, 1) && isTurnTile(2, 1)
        {
            return true
        }
        if isTurnTile(0, 2) && isTurnTile(1, 2) && isTurnTile(2, 2)
        {
            return true
        }
        
        // horizontal victory
        if isTurnTile(0, 0) && isTurnTile(0, 1) && isTurnTile(0, 2)
        {
            return true
        }
        if isTurnTile(1, 0) && isTurnTile(1, 1) && isTurnTile(1, 2)
        {
            return true
        }
        if isTurnTile(2, 0) && isTurnTile(2, 1) && isTurnTile(2, 2)
        {
            return true
        }
        
        // diagonal victory
        if isTurnTile(0, 0) && isTurnTile(1, 1) && isTurnTile(2, 2)
        {
            return true
        }
        if isTurnTile(0, 2) && isTurnTile(1, 1) && isTurnTile(2, 0)
        {
            return true
        }
        
        
        return false
    }
    
    func isTurnTile(_ row: Int,_ column: Int) -> Bool
    {
        return board[row][column].tile == turn
    }
    
    func resetBoard()
    {
        var newBoard = [[Cell]]()
        
        for _ in 0...2
        {
            var row = [Cell]()
            for _ in 0...2
            {
                row.append(Cell(tile: Tile.Empty))
            }
            newBoard.append(row)
        }
        board = newBoard
    }
    
    func resetGame() {
        resetBoard()
        noughtsScore = 0
        crossesScore = 0
    }
    
}
