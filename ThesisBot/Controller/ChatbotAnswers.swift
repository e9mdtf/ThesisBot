//
//  ChatbotAnswers.swift
//  ThesisBot
//
//  Created by Vikete Áron on 2021. 04. 18..
//

import Foundation

class ChatbotAnswers {
    var answer = ChatMessages(message: "", avatar: "", color: .blue,isMe: false)
    var chatController = ChatController()
    let cardAnswer = "A pénzintézetünk a következő kártyafajtákat tudja az ügyfeleknek nyújtani: Mastercard Platina kártya,Mastercard Ezüstkártya, Visa Ezüst Kártya. A kártyákról további információt találsz cégünk weboldalán, a következő linken: https://peldabank.hu/bankkartyak"
    let bankAccountAnswer = "A pénzintézetünk az alábbi számlacsomagokat nyújtja lakossági ügyfeleink számára. Kis költség számla, Ingyenes utalás számla, Készpénzfelvét számla. További információt a cég weboldalán találsz a következő linken: https://peldabank.hu/szamlacsomagok"
    let defaultAnswer = "Sajnálom nem értettem az üzenetet. Kérlek próbálj meg egyszerűbben fogalmazni, vagy ha több különböző információt szeretnél, akkor azt több üzenetben megírni nekem. Köszönöm, ThesisBot."
    var chosenAnswer = ""
    
    func checkAnswer(entity:String) {
        let lowerCaseEntity = entity.lowercased()
        switch lowerCaseEntity {
        case "card":
            chosenAnswer = cardAnswer
        case "credit card":
            chosenAnswer = cardAnswer
        case "credit cards":
            chosenAnswer = cardAnswer
        case "account":
            chosenAnswer = bankAccountAnswer
        case "kind of credit cards":
            chosenAnswer = cardAnswer
        case "kind of bank accounts":
            chosenAnswer = bankAccountAnswer
        case "cards":
            chosenAnswer = cardAnswer
        default:
            chosenAnswer = defaultAnswer
        }
    }
}
