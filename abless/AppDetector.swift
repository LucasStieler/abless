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
        print("Checking for conflicting apps...")
        for (app, schemes) in appSchemes {
            print("Checking \(app) schemes...")
            for scheme in schemes {
                if let url = URL(string: scheme) {
                    print("Testing URL scheme: \(scheme)")
                    if UIApplication.shared.canOpenURL(url) {
                        print("✅ Found installed app: \(app) with scheme: \(scheme)")
                        return true
                    } else {
                        print("❌ Could not open URL scheme: \(scheme)")
                    }
                }
            }
        }
        print("No conflicting apps found")
        return false
    }
} 