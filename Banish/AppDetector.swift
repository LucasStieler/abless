import UIKit

class AppDetector {
    private let appOrder = ["YouTube", "Instagram", "TikTok"]
    
    private let appSchemes = [
        "YouTube": [
            "youtube://",
            "vnd.youtube://",
            "youtube-app://",
            "com.google.ios.youtube://"
        ],
        "Instagram": [
            "instagram://",
            "instagram-stories://"
        ],
        "TikTok": [
            "tiktok://",
            "snssdk1233://"
        ]
    ]
    
    private var cachedResults: [String] = []
    private var lastCheckTime: Date = .distantPast
    private let cacheTimeout: TimeInterval = 1.0
    
    public func getInstalledApps() -> [String] {
        if Date().timeIntervalSince(lastCheckTime) < cacheTimeout {
            return cachedResults
        }
        
        print("🔍 Starting app detection...")
        var foundApps: Set<String> = []
        
        print("🔗 Checking URL schemes...")
        for (app, schemes) in appSchemes {
            var appFound = false
            for scheme in schemes where !appFound {
                if let url = URL(string: scheme) {
                    let canOpen = UIApplication.shared.canOpenURL(url)
                    print("  - \(app) [\(scheme)]: \(canOpen ? "✅" : "❌")")
                    if canOpen {
                        print("  ✅ Adding \(app) to found apps")
                        foundApps.insert(app)
                        appFound = true
                    }
                }
            }
        }
        
        let installedApps = appOrder.filter { foundApps.contains($0) }
        print("📱 Found apps: \(installedApps)")
        
        if !installedApps.isEmpty {
            cachedResults = installedApps
            lastCheckTime = Date()
        }
        
        return installedApps
    }
    
    public func hasConflictingApps() -> Bool {
        let apps = getInstalledApps()
        print("🚫 Conflicting apps check: \(apps)")
        return !apps.isEmpty
    }
} 