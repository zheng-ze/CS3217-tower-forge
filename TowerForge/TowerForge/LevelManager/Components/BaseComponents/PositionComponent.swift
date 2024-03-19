//
//  PositionComponent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 17/03/24.
//

import Foundation
import CoreGraphics

class PositionComponent: TFComponent {
    var position: CGPoint

    init(position: CGPoint) {
        self.position = position
        super.init()
    }

    func changeTo(to position: CGPoint) {
        guard let entity = entity, let spriteComponent = entity.component(ofType: SpriteComponent.self) else {
            return
        }
        self.position = position
    }
}