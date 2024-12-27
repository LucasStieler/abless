import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var setupCompleted: Bool {
        didSet {
            UserDefaults.standard.set(setupCompleted, forKey: "setupCompleted")
        }
    }
    
    init() {
        self.setupCompleted = UserDefaults.standard.bool(forKey: "setupCompleted")
    }
    
    func completeSetup() {
        setupCompleted = true
    }
    
    func resetSetup() {
        setupCompleted = false
    }
} 