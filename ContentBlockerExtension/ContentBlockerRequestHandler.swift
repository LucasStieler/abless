import UIKit
import MobileCoreServices

class ContentBlockerRequestHandler: NSObject, NSExtensionRequestHandling {
    func beginRequest(with context: NSExtensionContext) {
        guard let jsonURL = Bundle.main.url(forResource: "blockerList", withExtension: "json") else {
            let error = NSError(domain: "io.abless", code: 1, userInfo: [NSLocalizedDescriptionKey: "blockerList.json not found"])
            context.cancelRequest(withError: error)
            return
        }
        
        let attachment = NSItemProvider(contentsOf: jsonURL)!
        let item = NSExtensionItem()
        item.attachments = [attachment]
        
        context.completeRequest(returningItems: [item], completionHandler: nil)
    }
} 