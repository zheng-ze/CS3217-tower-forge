//
//  DeathMatchMode.swift
//  TowerForge
//
//  Created by Vanessa Mae on 27/03/24.
//

import Foundation

class DeathMatchMode: GameMode {
    var eventManager: EventManager
    var modeName: String = "Death Match Mode"
    var modeDescription: String = "Kill as many units within the time limit"
    var gameProps: [any GameProp] = [DeathProp(position: PositionConstants.DEATH_MATCH_POINT_OWN,
                                               player: .ownPlayer),
                                     DeathProp(position: PositionConstants.DEATH_MATCH_POINT_OPP,
                                               player: .oppositePlayer),
                                     PointProp(initialPoint: 0)]
    var timer = TimerProp(timeLength: TimeInterval(60))
    var gameState = GameState.IDLE
    var currentOwnKillCounter: Int
    var currentOpponentKillCounter: Int

    init(eventManager: EventManager) {
        self.currentOwnKillCounter = 0
        self.currentOpponentKillCounter = 0
        self.eventManager = eventManager
        self.gameProps.append(timer)
        eventManager.registerHandler(forEvent: KillEvent.self) { event in
            if let killEvent = event as? KillEvent {
                // Check if the event reduces life
                if killEvent.player == .ownPlayer {
                    self.currentOpponentKillCounter += 1
                } else if killEvent.player == .oppositePlayer {
                    self.currentOwnKillCounter += 1
                }
            }
        }
    }
    func updateGame(deltaTime: TimeInterval) {
        if timer.time < 0 {
            if currentOwnKillCounter > currentOpponentKillCounter {
                gameState = .WIN
            } else if currentOwnKillCounter < currentOpponentKillCounter {
                gameState = .LOSE
            } else {
                gameState = .DRAW
            }
        }
    }
    func getGameResults() -> [GameResult] {
        let result = [GameResult(variable: "Total Kill", value: String(self.currentOwnKillCounter)),
                      GameResult(variable: "Opponent Kill", value: String(self.currentOpponentKillCounter))]
        return result
    }

}
