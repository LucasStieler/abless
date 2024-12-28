import UIKit

class AppDetector {
    // Define a fixed order for display
    private let appOrder = ["YouTube", "Instagram", "TikTok"]
    
    public let appSchemes = [
        "youtube": [
            "youtube://",
            "vnd.youtube://",
            "youtube-app://",
            "com.google.ios.youtube://",
            "goog.youtube://",
            "youtube-x-callback://"
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
        print("Checking for installed apps...") // Debug print
        
        // Return cached results if recent
        if Date().timeIntervalSince(lastCheckTime) < cacheTimeout {
            print("Returning cached results: \(cachedResults)") // Debug print
            return cachedResults
        }
        
        var foundApps: Set<String> = []
        
        for (app, schemes) in appSchemes {
            print("Checking \(app)...") // Debug print
            for scheme in schemes {
                if let url = URL(string: scheme) {
                    let canOpen = UIApplication.shared.canOpenURL(url)
                    print("Scheme \(scheme): \(canOpen ? "can open" : "cannot open")") // Debug print
                    if canOpen {
                        foundApps.insert(app.capitalized)
                        break
                    }
                }
            }
        }
        
        let installedApps = appOrder.filter { foundApps.contains($0) }
        print("Found installed apps: \(installedApps)") // Debug print
        
        // Update cache
        cachedResults = installedApps
        lastCheckTime = Date()
        return installedApps
    }
    
    public func hasConflictingApps() -> Bool {
        let apps = getInstalledApps()
        print("hasConflictingApps check: \(apps.isEmpty ? "no apps" : "has apps: \(apps)")") // Debug print
        return !apps.isEmpty
    }
} 