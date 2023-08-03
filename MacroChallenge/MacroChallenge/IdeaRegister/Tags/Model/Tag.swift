//
//  Tag.swift
//  MacroChallenge
//
//  Created by Natan de Camargo Rodrigues on 04/07/23.
//

import Foundation

struct Tag: Identifiable, Codable, Hashable {
    var id: UUID = UUID()
    var name: String
    var color: String //não é possível decodificar um Color
    var size: CGFloat = 0
    var isTagSelected: Bool = false 
    
    /*var color: Color {
        Color(hex: colorHex)
    }
    
    init(name: String, color: Color) {
        self.name = name
        self.colorHex = color.toHex()
    }*/
}

/*
 Uma alternativa que tentei fazer, foi usar essa extensão que pega a cor escrita com hexa como string e transforma em Color pra ser usada.
 Mas ainda nao sei se será útil por isso deixei comentado, apenas como alternativa. Peguei essa extensão com o chat.
 
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)

        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    func toHex() -> String {
        let components = self.cgColor.components!
        let r = UInt8(components[0] * 255.0)
        let g = UInt8(components[1] * 255.0)
        let b = UInt8(components[2] * 255.0)

        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
*/

