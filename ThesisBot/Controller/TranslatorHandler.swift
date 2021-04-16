//
//  TranslatorHandler.swift
//  ThesisBot
//
//  Created by Vikete Áron on 2021. 04. 15..
//

import Foundation

class TranslatorHandler {
    let googleNlpKey = "AIzaSyDy7VR7Zi4zehbzIWJJINDXrG_QrXJRZEE"
    var TranslateURL : URL {
        return URL(string: "https://translation.googleapis.com/language/translate/v2?key=\(googleNlpKey)")!
    }
    func createTranslateRequest (with text: String, handler: @escaping (String) -> Void) {
        var request = URLRequest(url: TranslateURL, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 300)
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "x-ios-bundle-identifier")
        let translationJson : [String : Any] = [
            "encodingType":"UTF-8",
            "document": [
                "q" : text,
                "target" : "en"
            ]
        ]
        let sendJson = JSON(translationJson)
        guard let sendTranslateData = try? sendJson.rawData() else {
            return
        }
        request.httpBody = sendTranslateData
        let task = session.dataTask(with: TranslateURL) {
            (data, response, error) in
            guard error == nil else {
              print("A google nlp api hívása sikertelen")
              print(error!)
              return
            }
            guard let responseData = data else {
              print("Nem érkezett adat a válaszban")
              return
            }
            do {
              guard let receivedTranslation = try JSONSerialization.jsonObject(with: responseData,
                options: []) as? [String: Any] else {
                  print("A válasz JSON nem fordítható át szótár formátumba")
                  return
              }
              print("A megkapott fordítás a következő: " + receivedTranslation.description)

              guard let translatedText = receivedTranslation["translatedText"] as? String else {
                print("Nem sikerült megtalálni a fordított szöveget a JSON-be")
                return
              }
              print("Az entity neve: \(translatedText)")
            } catch  {
              print("Nem megfelelő adatok vannak a válaszban")
              return
            }
          }
          task.resume()
    }
}
