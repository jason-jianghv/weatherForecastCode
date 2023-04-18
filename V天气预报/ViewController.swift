//
//  ViewController.swift
//  V天气预报
//
//  Created by jianghui on 2023/4/15.
//

import UIKit


class ViewController: UIViewController {
    
    
    //北京：110000 上海：310000 广州：440100 深圳：440300 苏州：320500 沈阳：210100
    var cityCodeArray = [110000, 310000, 440100, 440300, 320500, 210100]
    var weatherViewControllerArray: [WeatherViewController] = []
    
    lazy var pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubviews()
        // Do any additional setup after loading the view.
    }
    

    func setupSubviews() {
       
        setupChildControllers(cityCodes: cityCodeArray)
        self.pageViewController.dataSource = self
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        self.addChild(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.setViewControllers([weatherViewControllerArray.first!], direction: .reverse, animated: true)
    }
    
    func setupChildControllers(cityCodes: [Int]) {
        
        for (idx, cityCode) in cityCodes.enumerated() {
//            if idx > 0 {
//                weatherViewControllerArray.append(nil)
//            } else {
                let vc = WeatherViewController(withCode: cityCode, index: idx)
                weatherViewControllerArray.append(vc)
//            }
        }
    }
    
    func returnVC(atIndex: Int) -> WeatherViewController? {
        if case 0..<weatherViewControllerArray.count = atIndex {
            return weatherViewControllerArray[atIndex]
        }
        return nil
//        if case 0..<cityCodeArray.count = atIndex {
//            if let weatherViewController = weatherViewControllerArray[atIndex] {
//                return weatherViewController
//            }
//            let vc = WeatherViewController(withCode: cityCodeArray[atIndex], index: atIndex)
//            weatherViewControllerArray[atIndex] = vc
//            return vc
//        }
//        return nil
    }
}


extension ViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        var index = (viewController as! WeatherViewController).index
        index -= 1
        return returnVC(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        var index = (viewController as! WeatherViewController).index
        index += 1
        return returnVC(atIndex: index)
    }
}
