//
//  Tag.swift
//  MacroChallenge
//
//  Created by Aline Reis Silva on 05/07/23.
//

import SwiftUI

struct Tag: Identifiable,Hashable{
    
    var id = UUID().uuidString
    var text: String
    var size: CGFloat = 0
}


