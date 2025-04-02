import SwiftUI
import WebKit

struct WebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> WKWebViewController {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return WKWebViewController(webView: webView)
    }
    
    func updateUIViewController(_ uiViewController: WKWebViewController, context: Context) {}
}

class WKWebViewController: UIViewController {
    let webView: WKWebView
    
    init(webView: WKWebView) {
        self.webView = webView
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = webView
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
