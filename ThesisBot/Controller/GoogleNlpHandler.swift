//
//  GoogleNlpHandler.swift
//  ThesisBot
//
//  Created by Vikete Áron on 2021. 03. 25..
//

import Foundation
    class GoogleNaturalLanguageHandler {
    let googleNlpKey = "AIzaSyDy7VR7Zi4zehbzIWJJINDXrG_QrXJRZEE"
    var nlpEntity = ""
    var nlpUrl : URL {
        return URL(string: "https://language.googleapis.com/v1/documents:analyzeEntitySentiment?key=\(googleNlpKey)")!
    }
    func createRequest (with text : String , handler: @escaping (String)-> Void){
        var request = URLRequest(url: nlpUrl)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "x-ios-bundle-identifier") //ha a bundleIdentifier nem megfelelő (nem string) értéket ad vissza, akkor helyette üres stringet küld
        let requestJson: [String:Any] = [
            "document": [
                "type": "PLAIN_TEXT",
                "language": "EN",
                "content" : text
            ],
            "encodingType":"UTF8"
            ]
        let sendJson = JSON(requestJson)
        guard let sendData = try? sendJson.rawData() else {
            return
        }
        request.httpBody = sendData
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let nlpjson = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(nlpjson)
                let nlpsecondLayer = nlpjson["entities"] as! Array<Any>
                let arraySize = nlpsecondLayer.count
                let nlplastLayer = nlpsecondLayer[arraySize-1] as! Dictionary<String, Any>
                self.nlpEntity = nlplastLayer["name"] as! String
                print("Az nlpentity értéke a következő:")
                print(self.nlpEntity)
                print("ez volt az nlpentity értéke")
            } catch {
                print("error")
            }
        })
        task.resume()
        handler(nlpEntity)
    }
        }

