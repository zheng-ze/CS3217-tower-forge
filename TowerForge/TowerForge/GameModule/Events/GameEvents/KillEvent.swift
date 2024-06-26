//
//  KillEvent.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

struct KillEvent: TFEvent {
    let timestamp: TimeInterval
    let entityId: UUID
    let player: Player

    init(on entityId: UUID, at timestamp: TimeInterval, player: Player) {
        self.timestamp = timestamp
        self.entityId = entityId
        self.player = player
    }

    func execute(in target: any EventTarget) -> EventOutput {
        var success = false
        if let removeSystem = target.system(ofType: RemoveSystem.self) {
            success = removeSystem.handleRemove(for: entityId)
        }

        guard success else {
            return EventOutput()
        }

        if let statsSystem = target.system(ofType: StatisticSystem.self) {
            statsSystem.notify(for: self)
        }

        if let homeSystem = target.system(ofType: HomeSystem.self) {
            homeSystem.changeDeathCount(for: player.getOppositePlayer(), change: 1)
        }
        return EventOutput()
    }
}
