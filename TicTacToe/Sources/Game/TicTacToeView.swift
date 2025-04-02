import SwiftUI

struct TicTacToeView: View {
    @StateObject private var viewModel = TicTacToeViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            ZStack {
                if viewModel.winner == nil {
                    Text("Turn: \(viewModel.isXTurn ? "X" : "O")")
                } else {
                    Text(viewModel.winner == "Draw" ? "Draw!" : "Winner: \(viewModel.winner!)")
                }
            }
            .font(.largeTitle)
            
            VStack(spacing: 10) {
                ForEach(0..<3) { row in
                    HStack(spacing: 10) {
                        ForEach(0..<3) { col in
                            let index = row * 3 + col
                            Button(action: { viewModel.makeMove(at: index) }) {
                                Text(viewModel.board[index])
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundStyle(viewModel.board[index] == "X" ? .blue : .red)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                            .disabled(viewModel.isAdShowing)
                        }
                    }
                }
            }
            .disabled(viewModel.isAdShowing)
            
            Button("Restart") {
                viewModel.reset()
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.winner == nil)
        }
        .padding()
        .overlay(
            viewModel.isAdShowing ?
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(ProgressView())
            : nil
        )
    }
}

#Preview {
    TicTacToeView()
}
