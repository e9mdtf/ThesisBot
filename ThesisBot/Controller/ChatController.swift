//
//  ChatController.swift
//  ThesisBot
//
//  Created by Vikete Áron on 2021. 03. 21..
//

import Foundation
import Combine
import SwiftUI

class ChatController : ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    @Published var messages = [
        ChatMessages(message: "Üdvözöllek! Én a Példa Pénzügyi szolgáltató chatbotja vagyok. Kérlek semmilyen személyes adatot (pin kód, jelszó) ne adj meg ezen a felületen. Engem kérdezhetsz a pénzügyeidet érintő kérdésekben.", avatar: "ThesisBot", color: .blue),
    ]
    func sendMessage(_ chatMessage: ChatMessages) {
        messages.append(chatMessage)
        didChange.send()
    }
}
