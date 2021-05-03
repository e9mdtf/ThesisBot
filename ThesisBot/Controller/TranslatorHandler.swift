//
//  TranslatorHandler.swift
//  ThesisBot
//
//  Created by Vikete Áron on 2021. 04. 15..
//

import Foundation

class TranslatorHandler {
    let session = URLSession.shared
    let googleNlpKey = "AIzaSyDy7VR7Zi4zehbzIWJJINDXrG_QrXJRZEE"
    var TranslateURL : URL {
        return URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(googleNlpKey)")!
    }
    var translatedText = ""
    func createTranslateRequest (with text: String, handler: @escaping (String) -> Void) {
        var request = URLRequest(url: TranslateURL, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 300)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "x-ios-bundle-identifier")
        let translationJson : [String : Any] = [
                "q" : text ,
                "target" : "en"
        ]
        let sendJson = JSON(translationJson)
        guard let sendTranslateData = try? sendJson.rawData() else {
            return
        }
        request.httpBody = sendTranslateData
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                let nestedDict = json["data"] as! Dictionary<String, Any>
                let secondLayer = nestedDict["translations"] as! Array<Any>
                let lastLayer = secondLayer[0] as! Dictionary<String, String>
                print("A szótárból csinált szótár printelve")
                print(nestedDict)
                print("Második szint:")
                print(secondLayer)
                print("Utolsó szint i hope")
                print(lastLayer)
                self.translatedText = lastLayer["translatedText"]!
            } catch {
                print("error")
            }
            
        })
        task.resume()
        handler(translatedText)
    }


}

