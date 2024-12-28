import UIKit

class AppDetector {
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
        
        var installedApps: [String] = []
        for (app, schemes) in appSchemes {
            for scheme in schemes {
                if let url = URL(string: scheme),
                   UIApplication.shared.canOpenURL(url) {
                    installedApps.append(app.capitalized)
                    break // Exit inner loop once we find a match
                }
            }
        }
        
        // Update cache
        cachedResults = installedApps
        lastCheckTime = Date()
        return installedApps
    }
    
    public func hasConflictingApps() -> Bool {
        return !getInstalledApps().isEmpty
    }
} 