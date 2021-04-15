//
//  GoogleNlpHandler.swift
//  ThesisBot
//
//  Created by Vikete Áron on 2021. 03. 25..
//

import Foundation
class GoogleNaturalLanguageHandler {
    let currentSession = URLSession.shared
    var googleNlpKey = "AIzaSyDy7VR7Zi4zehbzIWJJINDXrG_QrXJRZEE"
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
            "encodingType": "UTF-8",
            "document": [
                "type": "PLAIN_TEXT",
                "content" : text
            ]
            ]
        let json = JSON(requestJson)
        guard let sendData = try? json.rawData() else {
            return
        }
        request.httpBody = sendData
        let task = session.dataTask(with: nlpUrl) {
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
              guard let receivedEntities = try JSONSerialization.jsonObject(with: responseData,
                options: []) as? [String: Any] else {
                  print("Could not get JSON from responseData as dictionary")
                  return
              }
              print("A megkapott entity a következő: " + receivedEntities.description)

              guard let entityName = receivedEntities["name"] as? String else {
                print("Nem sikerült megtalálni az Entity nevét a szótárban")
                return
              }
              print("Az entity neve: \(entityName)")
            } catch  {
              print("error parsing response from POST on /todos")
              return
            }
          }
          task.resume()
        //completion handler megírása net alapján ha ott kijön a json egy objectként, akkor utána mint dictionary ki lehet szedni mi a történés és az alapján üzenetet rakni
        //same kerül a luisba és a fordítóba is kb.
        
        
        //guard let response = request.allHTTPHeaderFields else {
            //print("Response error please try again")
            //return
        }
        
}

