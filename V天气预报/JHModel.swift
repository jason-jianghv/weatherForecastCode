//
//  File.swift
//  V天气预报
//
//  Created by jianghui on 2023/4/15.
//

import Foundation
import UIKit

struct Weather {
    var forecasts: [Forecast]
    init(forecasts: [Forecast]) {
        self.forecasts = forecasts
    }
}

extension Weather: Codable {
    enum CodingKeys: String, CodingKey {
        case forecasts
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        forecasts = try container.decode([Forecast].self, forKey: .forecasts)
    }
}

struct Forecast:Codable {
    var city: String
    var adcode: String
    var province: String
    var reporttime: String
    var casts: [Cast]
    
    init(city: String, adcode: String, province: String, reporttime: String, casts: [Cast]) {
        self.city = city
        self.adcode = adcode
        self.province = province
        self.reporttime = reporttime
        self.casts = casts
    }
}

extension Forecast {
    enum CodingKeys: String, CodingKey {
        case city
        case adcode
        case province
        case reporttime
        case casts
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        city = try container.decode(String.self, forKey: .city)
        adcode = try container.decode(String.self, forKey: .adcode)
        province = try container.decode(String.self, forKey: .province)
        reporttime = try container.decode(String.self, forKey: .reporttime)
        casts = try container.decode([Cast].self, forKey: .casts)
    }
}

struct Cast {
    var date: String
    var week: String
    var dayweather: String
    var nightweather: String
    var daytemp: String
    var nighttemp: String
    var daywind: String
    var nightwind: String
    
    init(date: String, week: String, dayweather: String, nightweather: String, daytemp: String, nighttemp: String, daywind: String, nightwind: String) {
        self.date = date
        self.week = week
        self.dayweather = dayweather
        self.nightweather = nightweather
        self.daytemp = daytemp
        self.nighttemp = nighttemp
        self.daywind = daywind
        self.nightwind = nightwind
    }
}

extension Cast: Codable {
    enum CodingKeys: String, CodingKey {
        case date
        case week
        case dayweather
        case nightweather
        case daytemp
        case nighttemp
        case daywind
        case nightwind
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        week = try container.decode(String.self, forKey: .week)
        dayweather = try container.decode(String.self, forKey: .dayweather)
        nightweather = try container.decode(String.self, forKey: .nightweather)
        daytemp = try container.decode(String.self, forKey: .daytemp)
        nighttemp = try container.decode(String.self, forKey: .nighttemp)
        daywind = try container.decode(String.self, forKey: .daywind)
        nightwind = try container.decode(String.self, forKey: .nightwind)
    }
}

public enum CardType {
    case head
    case list
}

protocol JHWeatherCardModelPortocol: AnyObject {
    var displayType: CardType { get }
    var cast: Cast { get set}
    var city: String { get }
    var reportTime: String { get }
    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func update()
}

class WeatherListModel: JHWeatherCardModelPortocol {
    
    weak var cell: JHForecastTableViewCell?
    
    var displayType: CardType
    
    var cast: Cast
    
    var city: String = ""
    
    var reportTime: String = ""
    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: JHForecastTableViewCell = tableView.dequeueReusableCell(withIdentifier: JHForecastTableViewCell.listCellId, for: indexPath) as! JHForecastTableViewCell
        self.cell = cell
        return cell
    }
    
    func update() {
        cell?.castModel = self.cast
    }
    
    init(displayType: CardType, cast: Cast, city: String, reportTime: String){
        self.displayType = displayType
        self.cast = cast
        self.city = city
        self.reportTime = reportTime
        
    }
    
}

class WeatherHeadModel: JHWeatherCardModelPortocol {
    weak var cell: JHForecastHeadTableViewCell?
    
    var displayType: CardType
    
    var cast: Cast
    
    var city: String = ""
    
    var reportTime: String = ""
    
    func cell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: JHForecastHeadTableViewCell = tableView.dequeueReusableCell(withIdentifier: JHForecastHeadTableViewCell.headCellId, for: indexPath) as! JHForecastHeadTableViewCell
        self.cell = cell
        return cell
    }
    
    func update() {
        cell?.castModel = self.cast
        cell?.uidateUI(city: self.city, cast: self.cast)
    }
    
    init(displayType: CardType, cast: Cast, city: String, reportTime: String){
        self.displayType = displayType
        self.cast = cast
        self.city = city
        self.reportTime = reportTime
    }
}

public func currentTime() -> String {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "HH:mm:ss"// 自定义时间格式 YYYY-MM-dd
    // GMT时间 转字符串，直接是系统当前时间
    return dateformatter.string(from: Date())
}

public func currentWeatherImage(weatherStr: String) -> UIImage {
    var image: UIImage
    // TODO: 这里可以根据需求划分具体天气
    if weatherStr.contains("雨") {
        image = UIImage(named: "rain")!
    } else if weatherStr.contains("雪") {
        image = UIImage(named: "snow")!
    } else if weatherStr.contains("阴") {
        image = UIImage(named: "cloudyDay")!
    } else {
        image = UIImage(named: "sunDay")!
    }
    
    return image
}
