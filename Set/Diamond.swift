//
//  Diamond.swift
//  Set
//
//  Created by Andrey Sysoev on 11.06.2022.
//

import SwiftUI

struct Diamond: Shape {
    let width: CGFloat
    var height: CGFloat {
        width / 2.5
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let top = CGPoint(x: center.x, y: center.y + height / 2)
        let right = CGPoint(x: center.x + width / 2, y: center.y)
        let bottom = CGPoint(x: center.x, y: center.y - height / 2)
        let left = CGPoint(x: center.x - width / 2, y: center.y)

        var p = Path()
        
        p.move(to: top)
        p.addLine(to: right)
        p.addLine(to: bottom)
        p.addLine(to: left)
        p.addLine(to: top)
        
        return p
    }
}
