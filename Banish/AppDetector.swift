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
    private let cacheTimeout: TimeInterval = 1.0
    
    public func getInstalledApps() -> [String] {
        if Date().timeIntervalSince(lastCheckTime) < cacheTimeout {
            return cachedResults
        }
        
        var foundApps: Set<String> = []
        
        let bundleIDs = [
            "com.google.ios.youtube",
            "com.zhiliaoapp.musically",
            "com.burbn.instagram"
        ]
        
        for bundleID in bundleIDs {
            if let url = URL(string: "\(bundleID)://"),
               UIApplication.shared.canOpenURL(url) {
                switch bundleID {
                case "com.google.ios.youtube": foundApps.insert("YouTube")
                case "com.zhiliaoapp.musically": foundApps.insert("TikTok")
                case "com.burbn.instagram": foundApps.insert("Instagram")
                default: break
                }
            }
        }
        
        for (app, schemes) in appSchemes {
            if !foundApps.contains(app.capitalized) {
                for scheme in schemes {
                    if let url = URL(string: scheme),
                       UIApplication.shared.canOpenURL(url) {
                        foundApps.insert(app.capitalized)
                        break
                    }
                }
            }
        }
        
        let installedApps = appOrder.filter { foundApps.contains($0) }
        
        cachedResults = installedApps
        lastCheckTime = Date()
        return installedApps
    }
    
    public func hasConflictingApps() -> Bool {
        return !getInstalledApps().isEmpty
    }
} 