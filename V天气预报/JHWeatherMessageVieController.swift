//
//  JHWeatherMessageVieController.swift
//  V天气预报
//
//  Created by jianghui on 2023/4/17.
//

import Foundation
import UIKit

class JHWeatherMessageVieController: UIViewController {
    
    var weatherModel:JHWeatherCardModelPortocol?
    
    lazy var cityLabel = UILabel.makeLabel(.large)
    lazy var dateLabel = UILabel.makeLabel(.regular)
    lazy var dayTempLabel = UILabel.makeLabel(.regular)
    lazy var nightTempLabel = UILabel.makeLabel(.regular)
    lazy var weatherLabel = UILabel.makeLabel(.regular)
    lazy var dayWindLabel = UILabel.makeLabel(.regular)
    lazy var nightWindLabel = UILabel.makeLabel(.regular)
    lazy var reportTimeLabel = UILabel.makeLabel(.regular)
    lazy var backImageView = UIImageView()
    
    override func viewDidLoad() {
        setupUI()
        
        update()
    }
    
    func setupUI(){
        view.backgroundColor = .white
        backImageView.image = UIImage(named: "sunDay")
        self.view.addSubview(backImageView)
        view.addSubview(cityLabel)
        view.addSubview(weatherLabel)
        view.addSubview(dateLabel)
        view.addSubview(dayTempLabel)
        view.addSubview(nightTempLabel)
        view.addSubview(dayWindLabel)
        view.addSubview(nightWindLabel)
        
        backImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        cityLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.top).inset(80)
        }
        
        weatherLabel.snp.makeConstraints { make in
            make.top.equalTo(self.cityLabel.snp.bottom).offset(widgetPadding)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.left).inset(edgesPadding)
            make.centerY.equalToSuperview()
        }
        
        dayTempLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self.view).inset(edgesPadding)
            make.top.equalTo(self.dateLabel.snp.bottom).offset(widgetPadding)
        }
        
        nightTempLabel.snp.makeConstraints { make in
            make.left.right.equalTo(self.view).inset(edgesPadding)
            make.top.equalTo(self.dayTempLabel.snp.bottom).offset(widgetPadding)
        }
    }
    
    func update() {
        if let model = self.weatherModel {
            self.cityLabel.text = model.city
            let timeString = currentTime()
            let aclock:Int = Int(timeString.prefix(2)) ?? 12
            let weatherStr = aclock <= divideDayAndNight ? model.cast.dayweather: model.cast.nightweather
            self.backImageView.image =  currentWeatherImage(weatherStr: weatherStr)
            self.weatherLabel.text = "天气: " + weatherStr
            self.dateLabel.text = model.cast.date
            self.dayTempLabel.text = "白天: \(model.cast.dayweather)  风向:\(model.cast.daywind)风  最高温度:\(model.cast.daytemp)"
            self.nightTempLabel.text = "夜里: \(model.cast.nightweather) 风向:\(model.cast.nightwind)风  最低温度:\(model.cast.nighttemp)"
        }
        
    }
}
