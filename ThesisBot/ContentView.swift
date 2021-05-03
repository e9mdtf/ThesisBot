//
//  ContentView.swift
//  ThesisBot
//
//  Created by Vikete Áron on 2021. 03. 21..
//

import SwiftUI
struct ChatMessages:Hashable {
    var message:String
    var avatar:String
    var color:Color
    var isMe:Bool = false
}

var entity = ""
var translateCall = TranslatorHandler()
var nlpCall = GoogleNaturalLanguageHandler()
var luisCall = LuisController()
var chatbotAnswer = ChatbotAnswers()
struct ChatRow : View {

    var chatMessage:ChatMessages
    var body: some View{
        Group{
            if !chatMessage.isMe{
                HStack {
                Text(chatMessage.avatar)
                Text(chatMessage.message)
                    .bold()
                    .padding(10)
                    .foregroundColor(Color.white)
             .background(chatMessage.color)
                    .cornerRadius(10)
                
            
            }
        }
            else {
                HStack {
                    Group {
                        Spacer()
                        Text(chatMessage.message)
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(chatMessage.color)
                            .cornerRadius(10)
                        Text(chatMessage.avatar)
                    }
                }
            }
    }
}
}

struct ContentView:View {
    var isLuis : Bool
    @State var composedMessage: String = ""
    @EnvironmentObject var chatController: ChatController
    var body: some View {
        VStack{
            
             List{
                ForEach(chatController.messages, id: \.self)
                { msg in
                    ChatRow(chatMessage:msg)
        }
        }
            
        HStack {
            TextField("Üzenet...", text: $composedMessage).frame(minHeight: CGFloat(30))
            Button(action: sendMessage){
                Text("Küldés")
            }
        }.frame(minHeight: CGFloat(50)).padding()
        }
        
    
    }
    func sendMessage(){
        chatController.sendMessage(ChatMessages(message: composedMessage, avatar: "Én", color: .green, isMe: true))
        translateCall.createTranslateRequest(with: composedMessage, handler: {_ in print(translateCall.translatedText)})
        sleep(1)
        if isLuis {
            luisCall.createRequest(with: translateCall.translatedText, handler: {_ in print(luisCall.luisEntity)})
            chatbotAnswer.checkAnswer(entity: luisCall.luisEntity)
        }
        else{
            nlpCall.createRequest(with: translateCall.translatedText, handler: {_ in print(nlpCall.nlpEntity)})
            sleep(1)
            chatbotAnswer.checkAnswer(entity: nlpCall.nlpEntity)
        }
        sleep(1)
        chatController.sendMessage(ChatMessages(message: chatbotAnswer.chosenAnswer, avatar: "ThesisBot", color: .blue, isMe: false))
        composedMessage = ""
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(isLuis: false)
                .environmentObject(ChatController())
        }
    }
}
