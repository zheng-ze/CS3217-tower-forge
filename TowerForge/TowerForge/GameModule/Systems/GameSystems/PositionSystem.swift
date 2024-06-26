//
//  PositionSystem.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation
import UIKit

class PositionSystem: TFSystem {
    var isActive = true
    unowned var entityManager: EntityManager
    unowned var eventManager: EventManager

    init(entityManager: EntityManager, eventManager: EventManager) {
        self.entityManager = entityManager
        self.eventManager = eventManager
    }

    func update(within time: CGFloat) {
        let positionComponents = entityManager.components(ofType: PositionComponent.self)
        for positionComponent in positionComponents {
            guard let entity = positionComponent.entity,
                  let playerComponent = entity.component(ofType: PlayerComponent.self) else {
                continue
            }
            if playerComponent.player == .ownPlayer && positionComponent.position.x > GameWorld.worldSize.width {
                handleOutOfGame(entity: entity)
            } else if playerComponent.player == .oppositePlayer
                        && positionComponent.position.x < UIScreen.main.bounds.minX {
                handleOutOfGame(entity: entity)
            }
        }
    }

    func updatePosition(for entityId: UUID, to position: CGPoint) {
        guard let currentEntity = entityManager.entity(with: entityId),
              let positionComponent = currentEntity.component(ofType: PositionComponent.self) else {
            return
        }

        positionComponent.changeTo(to: position)
    }

    func handleOutOfGame(entity: TFEntity) {
        guard let playerComponent = entity.component(ofType: PlayerComponent.self) else {
            return
        }

        eventManager.add(RemoveEvent(on: entity.id, at: CACurrentMediaTime()))

        guard entity is BaseUnit else {
            return
        }

        if eventManager.isHost {
            eventManager.add(RemoteLifeEvent(reduceBy: 1, player: playerComponent.player,
                                             source: eventManager.currentPlayer ?? .defaultPlayer))
        }
    }
}
