//
//  ForecastHeadTableviewCell.swift
//  V天气预报
//
//  Created by jianghui on 2023/4/17.
//

import Foundation
import UIKit

class JHForecastHeadTableViewCell: UITableViewCell {
    static let headCellId = "JHForecastHeadTableViewCellIdentify"
    
    var castModel: Cast!
    
    lazy var cityLabel = UILabel.makeLabel(.large)
    lazy var dayTempLabel = UILabel.makeLabel(.regular, .right)
    lazy var nightTempLabel = UILabel.makeLabel(.regular)
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
        self.selectionStyle = .none
        addSubview(cityLabel)
        addSubview(dayTempLabel)
        addSubview(nightTempLabel)
        addSubview(weatherLabel)
        
        cityLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top).inset(80)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(self.cityLabel.snp.bottom).offset(widgetPadding)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        dayTempLabel.snp.makeConstraints { make in
            make.right.equalTo(self.snp_centerXWithinMargins).offset(-widgetPadding / 2)
            make.top.equalTo(self.weatherLabel.snp.bottom).offset(widgetPadding)
        }
        
        nightTempLabel.snp.makeConstraints { make in
            make.left.equalTo(self.dayTempLabel.snp.right).offset(widgetPadding)
            make.top.equalTo(self.weatherLabel.snp.bottom).offset(widgetPadding)
        }
    }
    
    public func uidateUI(city: String, cast: Cast) {
        DispatchQueue.main.async {
            self.cityLabel.text = city
            self.dayTempLabel.text = "最高" + self.castModel.daytemp
            self.nightTempLabel.text = "最低" + self.castModel.nighttemp
            let timeString = currentTime()
            let aclock:Int = Int(timeString.prefix(2)) ?? 12
            self.weatherLabel.text = aclock <= divideDayAndNight ? self.castModel.dayweather: self.castModel.nightweather
        }
        
    }
}
