import UIKit

class AppDetector {
    // Define a fixed order for display
    private let appOrder = ["YouTube", "Instagram", "TikTok"]
    
    public let appSchemes = [
        "youtube": [
            "youtube://",
            "vnd.youtube://",
            "youtube-app://",
            "com.google.ios.youtube://"
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
    private let cacheTimeout: TimeInterval = 1.0 // 1 second cache
    
    public func getInstalledApps() -> [String] {
        // Return cached results if recent
        if Date().timeIntervalSince(lastCheckTime) < cacheTimeout {
            return cachedResults
        }
        
        // First, find all installed apps
        var foundApps: Set<String> = []
        for (app, schemes) in appSchemes {
            for scheme in schemes {
                if let url = URL(string: scheme),
                   UIApplication.shared.canOpenURL(url) {
                    foundApps.insert(app.capitalized)
                    break
                }
            }
        }
        
        // Then return them in the fixed order
        let installedApps = appOrder.filter { foundApps.contains($0) }
        
        // Update cache
        cachedResults = installedApps
        lastCheckTime = Date()
        return installedApps
    }
    
    public func hasConflictingApps() -> Bool {
        return !getInstalledApps().isEmpty
    }
} 