//
//  StatisticsDatabase+Codable.swift
//  TowerForge
//
//  Created by Rubesh on 14/4/24.
//

import Foundation

/// This extension adds encoding and decoding functionality to
/// the Statistics Database to allow for storing and loading from file.
extension StatisticsDatabase: Codable {

    private static func generateStatisticsCollection(_ statsArray: [Statistic]) -> [StatisticTypeWrapper: Statistic] {
        var statisticsMap: [StatisticTypeWrapper: Statistic] = [:]

        for stat in statsArray {
            statisticsMap[stat.statisticName] = stat
        }

        return statisticsMap
    }

    func encode(to encoder: Encoder) throws {
        Logger.log("StatisticsDatabase encoder called", self)
        var container = encoder.container(keyedBy: StatisticsDatabaseCodingKeys.self)
        var objectsContainer = container.nestedUnkeyedContainer(forKey: .statistics)
        try statistics.values.forEach { try objectsContainer.encode($0) }
    }

    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StatisticsDatabaseCodingKeys.self)
        var objectsArrayForType = try container.nestedUnkeyedContainer(forKey: .statistics)
        var objects: [Statistic] = []

        while !objectsArrayForType.isAtEnd {
            let statObjectDict = try objectsArrayForType.nestedContainer(keyedBy: StatisticCodingKeys.self)
            if let statObject = try Self.decodeObject(statObjectDict) {
                objects.append(statObject)
            }
        }

        Logger.log("Loaded Statistics Database with \(objects.count)", Self.self)
        let statObjectsMap = Self.generateStatisticsCollection(objects)

        self.init(statObjectsMap)
    }

    /*convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StatisticsDatabaseCodingKeys.self)
        var statistics = [StatisticTypeWrapper: Statistic]()
        let statsContainer = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: .statistics)

        for key in statsContainer.allKeys {
            let statDecoder = try statsContainer.superDecoder(forKey: key)
            if let statistic = try StatisticsFactory.statisticDecoder[key.stringValue]?(statDecoder) {
                if let statType = key.stringValue.asTFClassFromString as? Statistic.Type {
                    statistics[statType.asType] = statistic
                }
            }
        }

        self.init(statistics)
    }*/

    private static func decodeObject(_ statObjectDict: KeyedDecodingContainer<StatisticCodingKeys>)
    throws -> (any Statistic)? {

        let type = try statObjectDict.decode(String.self, forKey: .statisticName)
        let permanentValue = try statObjectDict.decode(Double.self, forKey: .permanentValue)
        let currentValue = try statObjectDict.decode(Double.self, forKey: .currentValue)

        guard let instance = StatisticsFactory.createInstance(of: type,
                                                              permanentValue: permanentValue,
                                                              currentValue: currentValue) else {

            throw DecodingError.dataCorruptedError(forKey: .statisticName,
                                                   in: statObjectDict,
                                                   debugDescription: "Cannot instantiate Statistic of type \(type)")
        }

        Logger.log("Object decoding success for \(instance)", self)
        return instance
    }
}
