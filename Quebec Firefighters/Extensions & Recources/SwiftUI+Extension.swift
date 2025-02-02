//
//  SwiftUI+Extension.swift
//  Quebec Firefighters
//
//  Created by Alireza on 2/1/25.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
extension UIColor {
    var swiftUIColor: Color {
        Color(self)
    }
}
#elseif canImport(AppKit)
import AppKit
extension NSColor {
    var swiftUIColor: Color {
        Color(self)
    }
}
#endif
