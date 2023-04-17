//
//  WeatherViewController.swift
//  V天气预报
//
//  Created by jianghui on 2023/4/15.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    
    var castsArray: [JHWeatherCardModelPortocol] = []
    let index: Int
    let cityCode: Int
    lazy var tableView = UITableView(frame: .zero, style: .plain)
    lazy var backImageView = UIImageView()
    
    init(withCode: Int, index: Int) {
        self.cityCode = withCode
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        setupSubviews()
        
        Task.init {
            do {
                let weathers = try await WeatherService.instance.getWeather(cityCode: self.cityCode)
                if (weathers.count > 0) {
                    let forecast = weathers[0]
                    let casts = forecast.casts
                    for (idx, cast) in casts.enumerated() {
                        if idx == 0 {
                            let headModel = WeatherHeadModel(displayType: .head, cast: cast, city: forecast.city, reportTime: forecast.reporttime)
                            castsArray.append(headModel)
                            
                            setBackgroundImageContent(cast: cast)
                        } else {
                            let listModel = WeatherListModel(displayType: .list, cast: cast, city: forecast.city, reportTime: forecast.reporttime)
                            castsArray.append(listModel)
                        }
                    }
                    
                    tableView.reloadData()
                }
            } catch {
                
            }
        }
        
        print("the current index: \(self.index)")
    }
    
    func setupSubviews() {
        
        backImageView.image = UIImage(named: "sunDay")
        self.view.addSubview(backImageView)
        
        backImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
        tableView.register(JHForecastTableViewCell.self, forCellReuseIdentifier: JHForecastTableViewCell.listCellId)
        tableView.register(JHForecastHeadTableViewCell.self, forCellReuseIdentifier: JHForecastHeadTableViewCell.headCellId)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        
    }
    
    func setBackgroundImageContent(cast: Cast) {
        let timeString = currentTime()
        let aclock:Int = Int(timeString.prefix(2)) ?? 12
        let weatherStr = aclock <= divideDayAndNight ? cast.dayweather: cast.nightweather
        self.backImageView.image =  currentWeatherImage(weatherStr: weatherStr)
    }
    
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return castsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = castsArray[indexPath.row]
        switch model.displayType {
        case .head:
            return 280
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = castsArray[indexPath.row]
        let cell = model.cell(tableView: tableView, indexPath: indexPath)
        model.update()
        return cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: JHForecastTableViewCell.listCellId, for: indexPath) as? JHForecastTableViewCell
////        cell?.castModel = cast
//        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = castsArray[indexPath.row]
        let detailMessageController = JHWeatherMessageVieController()
        detailMessageController.weatherModel = model
//        detailMessageController.modalPresentationStyle = .
        self.present(detailMessageController, animated: true)
    }
}
