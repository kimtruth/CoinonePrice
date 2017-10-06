//
//  MainViewController.swift
//  coinchart
//
//  Created by Truth on 2017. 10. 3..
//  Copyright © 2017년 k1mtruth. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let apiUrl = "https://api.coinone.co.kr/ticker/?currency=all"
    
    let logos = ["btc": #imageLiteral(resourceName: "Bitcoin"),
                 "bch": #imageLiteral(resourceName: "Bitcoin"),
                 "eth": #imageLiteral(resourceName: "Ethereum"),
                 "etc": #imageLiteral(resourceName: "EthereumClassic"),
                 "xrp": #imageLiteral(resourceName: "Ripple"),
                 "qtum": #imageLiteral(resourceName: "Qtum")
                 ]
    let names = ["btc": "비트코인",
                 "bch": "비트코인 캐시",
                 "eth": "이더리움",
                 "etc": "이더리움 클래식",
                 "xrp": "리플",
                 "qtum": "퀀텀"]
    let currencies = ["btc", "bch", "eth", "etc", "xrp", "qtum"]
    var prices = [0, 0, 0, 0, 0, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 5,
                             target: self,
                             selector: #selector(updatePrices),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc func updatePrices() {
        Alamofire.request(apiUrl).responseJSON { response in
            print(response.response)
            if let data = response.data {
                let json = JSON(data: data)
                for i in 0..<self.currencies.count {
                    let currency = self.currencies[i]
                    
                    self.prices[i] = json[currency]["last"].intValue
                    
                    print("\(currency) : \(json[currency]["last"])")
                }
                self.tableView.reloadData()
            }
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as! CardCell
        let currency = currencies[indexPath.row]
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        
        cell.logoImage.image = logos[currency]
        cell.titleLabel.text = names[currency] ?? ""
        cell.priceLabel.text = numberFormatter.string(from: NSNumber(value:prices[indexPath.row]))! + " KRW"
        cell.percentLabel.text = ""
        
        return cell
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 99
    }
}
