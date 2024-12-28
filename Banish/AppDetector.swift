import UIKit

class AppDetector {
    private let appOrder = ["YouTube", "Instagram", "TikTok"]
    
    private let appSchemes = [
        "youtube": [
            "youtube://",
            "vnd.youtube://",
            "youtube-app://"
        ],
        "instagram": [
            "instagram://",
            "instagram-stories://"
        ],
        "tiktok": [
            "tiktok://",
            "snssdk1233://"
        ]
    ]
    
    private var cachedResults: [String] = []
    private var lastCheckTime: Date = .distantPast
    private let cacheTimeout: TimeInterval = 0.0
    
    public func getInstalledApps() -> [String] {
        print("🔍 Starting app detection...")
        
        var foundApps: Set<String> = []
        
        // Check URL schemes first (simpler approach)
        print("🔗 Checking URL schemes...")
        for (app, schemes) in appSchemes {
            for scheme in schemes {
                if let url = URL(string: scheme) {
                    let canOpen = UIApplication.shared.canOpenURL(url)
                    print("  - \(app) [\(scheme)]: \(canOpen ? "✅" : "❌")")
                    if canOpen {
                        print("  ✅ Adding \(app.capitalized) to found apps")
                        foundApps.insert(app.capitalized)
                        break // Found one working scheme, no need to check others
                    }
                }
            }
        }
        
        // Keep apps in the specified order
        let installedApps = appOrder.filter { foundApps.contains($0) }
        print("📱 Found apps: \(installedApps)")
        
        cachedResults = installedApps
        lastCheckTime = Date()
        return installedApps
    }
    
    public func hasConflictingApps() -> Bool {
        let apps = getInstalledApps()
        print("🚫 Conflicting apps check: \(apps)")
        return !apps.isEmpty
    }
} 