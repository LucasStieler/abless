import SwiftUI

extension View {
    func smoothExit(opacity: Binding<CGFloat>, scale: Binding<CGFloat> = .constant(1), completion: @escaping () -> Void) -> some View {
        self.modifier(SmoothExitModifier(opacity: opacity, scale: scale, completion: completion))
    }
}

struct SmoothExitModifier: ViewModifier {
    @Binding var opacity: CGFloat
    @Binding var scale: CGFloat
    let completion: () -> Void
    
    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .scaleEffect(scale)
            .onChange(of: opacity) { newValue in
                if newValue == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        completion()
                    }
                }
            }
    }
} 