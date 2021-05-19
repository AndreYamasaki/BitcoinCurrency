//
//  ViewController.swift
//  BitcoinCurse
//
//  Created by user191918 on 5/18/21.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    //MARK: - outlets
    
    @IBOutlet weak var currencyPickerView: UIPickerView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    //MARK: - variables and constants
    
    let apiKey = "ODQyYzhiOGE1ZDhmNDgzN2EyOWQ1ODkyMTliMjIxYTc"
    
    /*let request = AF.request("https://apiv2.bitcoinaverage.com/indices/{symbol_set}/ticker/all")*/
    
    let curruncies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
    
    /*var url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"*/
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        
    }
    
    
    //MARK: - functions pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return curruncies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // retorna o titulo para a selacao
        return curruncies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
        fetchData(url: url)
    }
    
    
    //MARK: - funcao fetchData from url
    func fetchData (url: String) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-ba-key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                self.parseJson(json: data)
            }else {
                print ("error")
            }
        }
        task.resume()
        
    }
    
    func parseJson(json: Data){
        do {
            if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                print(json)
                if let askValue = json["ask"] as? NSNumber {
                    print(askValue)
                    
                    let askvalueString = NumberFormatter()
                    askvalueString.groupingSeparator = "."
                    askvalueString.decimalSeparator = ","
                    askvalueString.maximumFractionDigits = 2
                    askvalueString.numberStyle = .decimal
                    
                    DispatchQueue.main.async {
                        
                        self.priceLabel.text = askvalueString.string(from: askValue)
                    }
                    print("success")  } else {
                        print("error")
                    }
            }
        } catch {
            print("error parsing json: \(error)")
        }
    }
    
    
}
