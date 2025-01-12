//
//  Color+HEX.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/09.
//

import UIKit

enum Color {
    case theme
    case tint
    case border
    case shadow
    
    case background
    case lightBackground
    case darkBackground
    case lightText
    case darkText
    
    case affirmation
    case negation
    
    case custom(hexString: String, alpha: Double)
    
    func withAlpha(_ alpha: Double) -> UIColor {
        return self.value.withAlphaComponent(CGFloat(alpha))
    }
}

extension Color {
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .border:
            instanceColor = UIColor(hexString: "#BBF1C8")
        case .theme:
            instanceColor = UIColor(hexString: "#80BDAB")
        case .tint:
            instanceColor = UIColor(hexString: "#FF9595")
        case .shadow:
            instanceColor = UIColor(hexString: "#CCCCCC")
        case .background:
            instanceColor = UIColor(hexString: "#241E27")
        case .lightBackground:
            instanceColor = UIColor(hexString: "#433748")
        case .darkBackground:
            instanceColor = UIColor(hexString: "#1F1A22")
        case .lightText:
            instanceColor = UIColor(hexString: "#EBEBF5")
        case .darkText:
            instanceColor = UIColor(hexString: "#1C1C1E")
        case .affirmation:
            instanceColor = UIColor(hexString: "#80BDAB")
        case .negation:
            instanceColor = UIColor(hexString: "#8B0000")
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return instanceColor
    }
}

extension UIColor {
    convenience init(hexString: String) {
        var hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)

        if hexString.hasPrefix("#") {
            let startIndex = hexString.index(after: hexString.startIndex)
            hexString = String(hexString[startIndex...])
        }
        
        let scanner = Scanner(string: hexString)
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
                
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}
