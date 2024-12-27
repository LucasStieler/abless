import UIKit

class AppDetector {
    let appSchemes = [
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
    
    func hasConflictingApps() -> Bool {
        for (_, schemes) in appSchemes {
            for scheme in schemes {
                if let url = URL(string: scheme),
                   UIApplication.shared.canOpenURL(url) {
                    return true
                }
            }
        }
        return false
    }
} 