import UnityAds
import SwiftUI

class TicTacToeViewModel: NSObject, ObservableObject, UnityAdsShowDelegate, UnityAdsLoadDelegate, UnityAdsInitializationDelegate {
    @Published var board = Array(repeating: "", count: 9)
    @Published var isXTurn = true
    @Published var winner: String?
    @Published var isAdShowing = false
    
    private let gameId = "5826606"
    private let adUnitId = "Interstitial_iOS"
    private let testMode = true 
    
    override init() {
        super.init()
        UnityAds.setDebugMode(true)
        UnityAds.initialize(gameId, testMode: testMode, initializationDelegate: self)
    }
    
    func makeMove(at index: Int) {
        guard board[index].isEmpty, winner == nil else { return }
        board[index] = isXTurn ? "X" : "O"
        checkWinner()
        isXTurn.toggle()
    }
    
    func checkWinner() {
        let lines = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        for line in lines {
            if board[line[0]] != "", board[line[0]] == board[line[1]], board[line[1]] == board[line[2]] {
                winner = board[line[0]]
                return
            }
        }
        if !board.contains("") { winner = "Draw" }
    }
    
    func reset() {
        showAd()
        board = Array(repeating: "", count: 9)
        isXTurn = true
        winner = nil
    }
    
    private func loadAd() {
        UnityAds.load(adUnitId, loadDelegate: self)
        print("Attempting to load ad for placement: \(adUnitId)")
    }
    
    private func showAd() {
        if UnityAds.isInitialized() {
            isAdShowing = true
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                UnityAds.show(rootViewController,
                              placementId: adUnitId,
                              showDelegate: self)
                print("Showing ad from window scene")
            } else {
                UnityAds.show(UIViewController(),
                              placementId: adUnitId,
                              showDelegate: self)
                print("Showing ad with fallback UIViewController")
            }
        } else {
            print("Unity Ads not initialized yet")
        }
    }
    
    func initializationComplete() {
        print("Unity Ads initialized successfully")
        loadAd()
    }
    
    func initializationFailed(_ error: UnityAdsInitializationError, withMessage: String) {
        print("Unity Ads Initialization Failed: \(error) - \(withMessage)")
    }
    
    func unityAdsAdLoaded(_ placementId: String) {
        print("Ad loaded successfully for placement: \(placementId)")
    }
    
    func unityAdsAdFailed(toLoad placementId: String, withError error: UnityAdsLoadError, withMessage message: String) {
        print("Ad Load Failed for \(placementId): \(error) - \(message)")
        isAdShowing = false
    }
    
    func unityAdsShowComplete(_ placementId: String, withFinish state: UnityAdsShowCompletionState) {
        print("Ad show completed for \(placementId) with state: \(state.rawValue)")
        isAdShowing = false
        loadAd()
    }
    
    func unityAdsShowFailed(_ placementId: String, withError error: UnityAdsShowError, withMessage message: String) {
        print("Ad Show Failed for \(placementId): \(error) - \(message)")
        isAdShowing = false
        loadAd()
    }
    
    func unityAdsShowStart(_ placementId: String) {
        print("Ad started showing for placement: \(placementId)")
    }
    
    func unityAdsShowClick(_ placementId: String) {
        print("Ad clicked for placement: \(placementId)")
    }
}
