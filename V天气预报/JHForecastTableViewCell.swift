//
//  ForecastTableviewCell.swift
//  V天气预报
//
//  Created by jianghui on 2023/4/15.
//

import Foundation
import UIKit

class JHForecastTableViewCell: UITableViewCell {
    
    static let listCellId = "JHForecastTableViewCellIdentify"
    
    var castModel: Cast! {
        didSet {
            updateUI()
        }
    }
    
    lazy var weekLabel = UILabel.makeLabel(.regular)
    lazy var dayTempLabel = UILabel.makeLabel(.regular, .right)
    lazy var nightTempLabel = UILabel.makeLabel(.regular , .right)
    lazy var weatherLabel = UILabel.makeLabel(.regular)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        self.backgroundColor = .clear
//        self.selectionStyle = .none
        addSubview(weekLabel)
        addSubview(dayTempLabel)
        addSubview(nightTempLabel)
        addSubview(weatherLabel)
        
        weekLabel.snp.makeConstraints { make in
            make.left.equalTo(self).inset(edgesPadding)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.left.equalTo(self.weekLabel.snp.right).offset(50)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        nightTempLabel.snp.makeConstraints { make in
            make.right.equalTo(self).inset(edgesPadding)
            make.centerY.equalTo(self.snp.centerY)
            make.width.greaterThanOrEqualTo(20)
        }
        
        dayTempLabel.snp.makeConstraints { make in
            make.right.equalTo(self.nightTempLabel.snp.left).offset(-widgetPadding)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.weekLabel.text = self.weekName(week: self.castModel.week)
            self.dayTempLabel.text = self.castModel.daytemp
            self.nightTempLabel.text = self.castModel.nighttemp
            let timeString = currentTime()
            let aclock:Int = Int(timeString.prefix(2)) ?? 12
            let weatherStr = aclock <= divideDayAndNight ? self.castModel.dayweather: self.castModel.nightweather
            self.weatherLabel.text = weatherStr
        }
    }
    
    func weekName(week: String) -> String {
        switch week {
        case "1":
            return "星期一"
        case "2":
            return "星期二"
        case "3":
            return "星期三"
        case "4":
            return "星期四"
        case "5":
            return "星期五"
        case "6":
            return "星期六"
        case "7":
            return "星期天"
        default:
            return ""
        }
    }
}
