import FirebaseAnalytics
import SwiftUI

struct AppRoot: View {
    @State private var countryCode: String?
    private let countryContent = ["AU": "https://youtube.com", "BR": "https://google.com", "PT": "https://wikipedia.org"]
    
    var body: some View {
        if let country = countryCode {
            if countryContent.keys.contains(country) {
                WebView(url: URL(string: countryContent[country]!)!)
                    .onAppear { Analytics.logEvent("content_viewed", parameters: ["type": "webview"]) }
            } else {
                TicTacToeView()
                    .onAppear { Analytics.logEvent("content_viewed", parameters: ["type": "game"]) }
            }
        } else {
            VStack {
                Text("Loading...")
                
                ProgressView()
            }
            .onAppear {
                fetchCountry { code in
                    countryCode = code
                }
            }
        }
    }
    
    func fetchCountry(completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://ipapi.co/json/")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { completion(nil); return }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let countryCode = json["country_code"] as? String {
                completion(countryCode)
            } else {
                completion(nil)
            }
        }.resume()
    }
}

#Preview {
    AppRoot()
}
