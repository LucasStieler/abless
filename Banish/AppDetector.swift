import UIKit

class AppDetector {
    private let appSchemes = [
        "YouTube": ["youtube://", "vnd.youtube://"],
        "Instagram": ["instagram://"],
        "TikTok": ["tiktok://"]
    ]
    
    private var cachedResults: [String] = []
    private var lastCheckTime: Date?
    
    public func getInstalledApps() -> [String] {
        if let lastCheck = lastCheckTime, Date().timeIntervalSince(lastCheck) < 300 {
            return cachedResults
        }
        
        let foundApps = appSchemes.keys.filter { app in
            appSchemes[app]?.contains { scheme in
                UIApplication.shared.canOpenURL(URL(string: scheme)!)
            } ?? false
        }
        
        cachedResults = foundApps
        lastCheckTime = Date()
        return foundApps
    }
    
    public func hasConflictingApps() -> Bool {
        !getInstalledApps().isEmpty
    }
} 