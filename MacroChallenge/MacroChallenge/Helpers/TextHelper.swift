//
//  TextHelper.swift
//  MacroChallenge
//
//  Created by Henrique Assis on 10/08/23.
//

import Foundation
import SwiftUI

extension Text {
    /**Resize the Text font accordingly with the current device. phone standard is 17, pad standard is 25, font standard is "Sen-Regular".*/
        func dynamicFont(phone: CGFloat = 17, pad: CGFloat = 25, fontName: String = "Sen-Regular", fontWeight: SwiftUI.Font.Weight = .regular) -> Text {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return font((Font.custom(fontName, size: phone))).fontWeight(fontWeight)
                
            case .pad:
                return font((Font.custom(fontName, size: pad))).fontWeight(fontWeight)
                
            default:
                return font((Font.custom(fontName, size: 25))).fontWeight(fontWeight)
            }
        }
}
