//
//  AchievementsFactory.swift
//  TowerForge
//
//  Created by Rubesh on 15/4/24.
//

import Foundation

class AchievementsFactory {

    static var availableAchievementTypes: [String: Achievement.Type] =
        [
            String(describing: FiftyKillsAchievement.self): FiftyKillsAchievement.self,
            String(describing: ThousandKillsAchievement.self): ThousandKillsAchievement.self,
            String(describing: CenturionAchievement.self): CenturionAchievement.self
        ]

    static func registerAchievementType<T: Achievement>(_ stat: T) {
        availableAchievementTypes[String(describing: T.self)] = T.self
    }

    static func getDefaultAchievementsDatabase(_ data: InferenceDataDelegate?) -> AchievementsDatabase {
        let achievementsDatabase = AchievementsDatabase()
        achievementsDatabase.achievementsDataDelegate = data
        availableAchievementTypes.values.forEach { achievementsDatabase.addAchievement(for: $0.asType) }
        Logger.log("Default achievements retrieved with \(achievementsDatabase.count)", self)
        return achievementsDatabase
    }

    static func getEmptyAchievementsDatabase() -> AchievementsDatabase {
        let achievementsDatabase = AchievementsDatabase()
        availableAchievementTypes.values.forEach { achievementsDatabase.addAchievement(for: $0.asType) }
        Logger.log("Empty achievements retrieved with \(achievementsDatabase.count)", self)
        return achievementsDatabase
    }

    static func createDefaultInstance(of typeName: String, with db: StatisticsDatabase) -> Achievement? {
        guard let type = availableAchievementTypes[typeName] else {
            return nil
        }

        let stats: [Statistic] = db.statistics.values.filter { key in
            type.definedParameters.keys.contains {
                $0 == key.statisticName
            }
        }

        return type.init(dependentStatistics: stats)
    }
}
