import SwiftUI

struct LoadingView: View {
    @State private var opacity = 0.0
    @State private var scale = 0.8
    @State private var showMainContent = false
    
    // Text animation states
    @State private var textOpacity = 1.0
    @State private var textOffset: CGFloat = 0
    
    var body: some View {
        Group {
            if showMainContent {
                ContentView()
                    .transition(.opacity)
            } else {
                ZStack {
                    // Background gradient
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    VStack(spacing: 30) {
                        // App icon or logo
                        Image(systemName: "shield.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .opacity(opacity)
                            .scaleEffect(scale)
                        
                        // Animated text
                        Text("Distracting Short Videos")
                            .font(.title2)
                            .foregroundColor(.white)
                            .opacity(textOpacity)
                            .offset(x: textOffset)
                        
                        Text("will vanish")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                            .opacity(opacity)
                    }
                }
            }
        }
        .onAppear {
            // Initial animation
            withAnimation(.easeOut(duration: 0.8)) {
                opacity = 1
                scale = 1
            }
            
            // Text vanishing animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    textOpacity = 0
                    textOffset = -50
                }
            }
            
            // Transition to main content
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeIn(duration: 0.5)) {
                    showMainContent = true
                }
            }
        }
    }
} 