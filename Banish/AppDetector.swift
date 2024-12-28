import UIKit

class AppDetector {
    private let appOrder = ["YouTube", "Instagram", "TikTok"]
    
    public let appSchemes = [
        "youtube": [
            "youtube://",
            "vnd.youtube://",
            "youtube-app://",
            "com.google.ios.youtube://",
            "goog.youtube://",
            "youtube-x-callback://",
            "youtubeapp://",
            "googleyoutube://",
            "youtube.com://"
        ],
        "instagram": [
            "instagram://",
            "instagram-stories://"
        ],
        "tiktok": [
            "tiktok://",
            "snssdk1233://",
            "tiktokv://",
            "tiktok.com://",
            "musically://",
            "musical.ly://"
        ]
    ]
    
    private var cachedResults: [String] = []
    private var lastCheckTime: Date = .distantPast
    private let cacheTimeout: TimeInterval = 0.0
    
    public func getInstalledApps() -> [String] {
        print("🔍 Starting app detection...")
        
        var foundApps: Set<String> = []
        
        let bundleIDs = [
            "com.google.ios.youtube": "YouTube",
            "com.zhiliaoapp.musically": "TikTok",
            "com.burbn.instagram": "Instagram",
            "com.google.ios.youtube.GoogleAppYouTube": "YouTube",
            "com.ss.iphone.ugc.Aweme": "TikTok"
        ]
        
        print("📱 Checking bundle IDs...")
        for (bundleID, appName) in bundleIDs {
            if let url = URL(string: "\(bundleID)://") {
                let canOpen = UIApplication.shared.canOpenURL(url)
                print("  - \(bundleID): \(canOpen ? "✅" : "❌")")
                if canOpen {
                    foundApps.insert(appName)
                }
            }
        }
        
        print("🔗 Checking URL schemes...")
        for (app, schemes) in appSchemes {
            if !foundApps.contains(app.capitalized) {
                for scheme in schemes {
                    if let url = URL(string: scheme) {
                        let canOpen = UIApplication.shared.canOpenURL(url)
                        print("  - \(app) [\(scheme)]: \(canOpen ? "✅" : "❌")")
                        if canOpen {
                            foundApps.insert(app.capitalized)
                            break
                        }
                    }
                }
            }
        }
        
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