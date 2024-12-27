import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var setupCompleted: Bool {
        didSet {
            UserDefaults.standard.set(setupCompleted, forKey: "setupCompleted")
        }
    }
    
    @Published var extensionEnabled: Bool {
        didSet {
            UserDefaults.standard.set(extensionEnabled, forKey: "extensionEnabled")
        }
    }
    
    init() {
        self.setupCompleted = UserDefaults.standard.bool(forKey: "setupCompleted")
        self.extensionEnabled = UserDefaults.standard.bool(forKey: "extensionEnabled")
    }
    
    func completeSetup() {
        setupCompleted = true
    }
    
    func resetSetup() {
        setupCompleted = false
    }
    
    func updateExtensionStatus(_ enabled: Bool) {
        extensionEnabled = enabled
    }
} 