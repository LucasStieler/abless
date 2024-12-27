import UIKit

class AppDetector {
    public let appSchemes = [
        "youtube": [
            "youtube://",
            "vnd.youtube://",
            "youtube-app://",
            "com.google.ios.youtube://",
            "goog.youtube://"
        ],
        "instagram": [
            "instagram://",
            "instagram-stories://",
            "instagram-reels://"
        ],
        "tiktok": [
            "tiktok://",
            "snssdk1233://",
            "tiktok.com://"
        ]
    ]
    
    public func hasConflictingApps() -> Bool {
        return !getInstalledApps().isEmpty
    }
    
    public func getInstalledApps() -> [String] {
        var installedApps: [String] = []
        
        print("Starting app detection check...")
        
        for (app, schemes) in appSchemes {
            var appFound = false
            for scheme in schemes {
                if let url = URL(string: scheme) {
                    if UIApplication.shared.canOpenURL(url) {
                        print("Found installed app: \(app) with scheme: \(scheme)")
                        if !appFound {  // Prevent duplicates
                            installedApps.append(app.capitalized)
                            appFound = true
                        }
                    } else {
                        print("Could not open URL scheme: \(scheme)")
                    }
                }
            }
        }
        
        print("Installed apps found: \(installedApps)")
        return installedApps
    }
} 