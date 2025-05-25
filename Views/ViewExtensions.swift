import SwiftUI

extension View {
    func _onButtonGesture(
        pressing: @escaping (Bool) -> Void,
        perform: @escaping () -> Void
    ) -> some View {
        self.modifier(ButtonGestureModifier(pressing: pressing, perform: perform))
    }
}

private struct ButtonGestureModifier: ViewModifier {
    @State private var isPressed = false
    let pressing: (Bool) -> Void
    let perform: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPressed) { pressing($0) }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !isPressed {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        isPressed = false
                        perform()
                    }
            )
    }
}
