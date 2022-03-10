//
//  ParkilingButtonStyle.swift
//  Parkiling
//
//  Created by Nicholas on 04/03/22.
//

import SwiftUI

// MARK: - Enum for Button Style
enum CustomButtonType {
    case primary
    case secondary
    
    // Function that returns a specific style
    func getTextColor() -> Color {
        switch self {
        case .primary:
            return .white
        case .secondary:
            return .accentColor
        }
    }
    
    func getBackgroundColor() -> Color {
        switch self {
        case .primary:
            return .accentColor
        case .secondary:
            return .clear
        }
    }
    
    func getBorderColor() -> Color {
        switch self {
        case .primary:
            return .clear
        case .secondary:
            return .accentColor
        }
    }
    
    func getBorderWidth() -> CGFloat {
        switch self {
        case .primary:
            return 0
        case .secondary:
            return 4
        }
    }
}

struct ParkilingButtonStyle: PrimitiveButtonStyle {
    private let width: CGFloat?
    private let height: CGFloat?
    private let type: CustomButtonType
    @GestureState private var pressed = false
    
    init(
        _ type: CustomButtonType,
        width: CGFloat? = nil,
        height: CGFloat? = 45
    ) {
        self.width = width
        self.height = height
        self.type = type
    }
    
    func makeBody(configuration: Configuration) -> some View {
        let tapGesture = LongPressGesture(minimumDuration: 300)
            .updating($pressed) { bool, state, _ in
                state = bool
            }
        
        return ZStack {
            Capsule()
                .strokeBorder(
                    type.getBorderColor(),
                    lineWidth: 4
                )
                .background(Capsule().foregroundColor(type.getBackgroundColor()))
            HStack {
                configuration.label
            }
            .foregroundColor(type.getTextColor())
            .font(.system(.headline, design: .rounded))
        }
        .frame(width: width, height: height, alignment: .center)
        .opacity(pressed ? 0.5 : 1.0)
        .gesture(tapGesture)
        .onChange(of: pressed) { newValue in
            if !newValue {
                DispatchQueue.main.async {
                    configuration.trigger()
                }
            }
        }
    }
}

struct ParkilingButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Button {
                print("This is a button")
            } label: {
                Image(systemName: "1.square.fill")
                Text("Primary Button")
            }
            .buttonStyle(ParkilingButtonStyle(.primary))
            .padding()
            .previewLayout(.sizeThatFits)
            Button {
                print("This is a button")
            } label: {
                Image(systemName: "2.square.fill")
                Text("Secondary Button")
            }
            .buttonStyle(ParkilingButtonStyle(.secondary))
            .padding()
            .previewLayout(.sizeThatFits)
            
            // Dark mode
            Button {
                print("This is a button")
            } label: {
                Image(systemName: "1.square.fill")
                Text("Primary Button")
            }
            .buttonStyle(ParkilingButtonStyle(.primary))
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
            Button {
                print("This is a button")
            } label: {
                Image(systemName: "2.square.fill")
                Text("Secondary Button")
            }
            .buttonStyle(ParkilingButtonStyle(.secondary))
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
    }
}
