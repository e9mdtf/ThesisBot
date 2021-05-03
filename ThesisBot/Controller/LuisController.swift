//
//  LuisController.swift
//  ThesisBot
//
//  Created by Vikete Áron on 2021. 04. 16..
//

import Foundation
class LuisController {
    let apiKey = "2036c99a25e949b1a3eb4db02f76d413"
    var luisEntity = ""
    let appId = "48d1b0e5-59ae-4766-afe2-f56461e5a937"
    var luisUrl: URL {
        return URL(string: "https://szakdolgozat-e9mdtf-thesis.cognitiveservices.azure.com/text/analytics/v2.1/keyPhrases")!
    }
    func createRequest (with text : String , handler: @escaping (String)-> Void){
        var id = 1
        let requestJson: [String:Any] = [
            "documents" : [
                [
                "language" : "en",
                "id": id,
                "text" : text
                ]
            ]
            ]
        var request = URLRequest(url: luisUrl)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
         //ha a bundleIdentifier nem megfelelő (nem string) értéket ad vissza, akkor helyette üres stringet küld
        var jsonData:Data?
        do {
            jsonData = try JSONSerialization.data(
              withJSONObject: requestJson,
              options: .prettyPrinted)
        } catch {
            print(error.localizedDescription)
        }
        request.httpBody = jsonData
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                print(json)
                let secondLayer = json["documents"] as! Array<Any>
                let arrayLength = secondLayer.count
                let thirdLayer = secondLayer[arrayLength-1] as! Dictionary<String, AnyObject>
                let lastLayer = thirdLayer["keyPhrases"] as! Array<Any>
                let lastArrayLength = lastLayer.count
                print(lastLayer)
                
                self.luisEntity = lastLayer[lastArrayLength-1] as! String
            } catch {
                print("error")
            }
            id = id + 1
        })
        task.resume()
        handler(luisEntity)
        
}
}
