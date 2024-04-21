//
//  TotalDamageStatistic.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

/// Total Damage dealt by the player in the course of the game
final class TotalDamageDealtStatistic: Statistic {
    static let expMultiplier: Double = 10
    var prettyName: String = "Total Damage"
    var permanentValue: Double = .zero
    var currentValue: Double = .zero
    var maximumCurrentValue: Double = .zero

    var statisticUpdateLinks: StatisticUpdateLinkDatabase {
        self.getStatisticUpdateLinks()
    }

    init(permanentValue: Double = .zero,
         currentValue: Double = .zero,
         maxCurrentValue: Double = .zero) {
        self.permanentValue = permanentValue
        self.currentValue = currentValue
        self.maximumCurrentValue = maxCurrentValue
    }

    func getStatisticUpdateLinks() -> StatisticUpdateLinkDatabase {
        let eventType = TFEventTypeWrapper(type: DamageEvent.self)
        let eventUpdateClosure: (Statistic, DamageEvent?) -> Void = { statistic, event in
            guard let event = event, event.player != .ownPlayer else {
                return
            }
            statistic.updateCurrentValue(by: Double(event.damage))
            Logger.log("Updating statistic with event detail: \(String(describing: event))", self)
        }

        let statisticUpdateActor = StatisticUpdateActor<DamageEvent>(action: eventUpdateClosure)
        let anyStatisticUpdateActorWrapper = AnyStatisticUpdateActorWrapper(statisticUpdateActor)

        var statisticUpdateLinksMap: [TFEventTypeWrapper: AnyStatisticUpdateActor] = [:]
        statisticUpdateLinksMap[eventType] = anyStatisticUpdateActorWrapper
        return StatisticUpdateLinkDatabase(statisticUpdateLinks: statisticUpdateLinksMap)

    }

    convenience init(from decoder: any Decoder) throws {
          let container = try decoder.container(keyedBy: StatisticCodingKeys.self)
          _ = try container.decode(StatisticTypeWrapper.self, forKey: .statisticName)
          let value = try container.decode(Double.self, forKey: .permanentValue)
          let current = try container.decode(Double.self, forKey: .currentValue)

          self.init(permanentValue: value, currentValue: current)
    }

    func merge<T: Statistic>(with that: T) -> T? {
        guard let that = that as? Self else {
            return nil
        }

        let largerPermanent = max(self.permanentValue, that.permanentValue)
        let largerCurrent = max(self.currentValue, that.currentValue)
        let largerMaxCurrent = max(self.maximumCurrentValue, that.maximumCurrentValue)

        guard let stat = Self(permanentValue: largerPermanent,
                              currentValue: largerCurrent,
                              maxCurrentValue: largerMaxCurrent) as? T else {
            return nil
        }

        return stat
    }
}
