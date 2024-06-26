//
//  Bullet.swift
//  TowerForge
//
//  Created by Zheng Ze on 16/3/24.
//

import Foundation

class Bullet: BaseProjectile {
    static let textureNames: [String] = ["bullet"]
    static let size = CGSize(width: 10, height: 10)
    static let key = "bullet"
    static let damage = 5.0
    static let attackRate = 1.0
    static let velocity = CGVector(dx: 200, dy: 0)

    required init(position: CGPoint, player: Player) {
        super.init(textureNames: Bullet.textureNames,
                   size: Bullet.size,
                   key: Bullet.key,
                   position: position,
                   player: player,
                   velocity: Bullet.velocity)
        self.addComponent(DamageComponent(attackRate: Bullet.attackRate,
                                          attackPower: Bullet.damage,
                                          temporary: true))
    }

    override func collide(with other: any Collidable) -> [TFEvent] {
        var events = super.collide(with: other)
        if let damageComponent = self.component(ofType: DamageComponent.self) {
            events.append(contentsOf: other.collide(with: damageComponent))
        }
        return events
    }

    override func collide(with healthComponent: HealthComponent) -> [TFEvent] {
        guard let damageComponent = self.component(ofType: DamageComponent.self) else {
            return []
        }
        return damageComponent.damage(healthComponent)
    }
}
