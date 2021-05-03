//
//  ButtonView.swift
//  ThesisBot
//
//  Created by Vikete Áron on 2021. 04. 29..
//

import SwiftUI

struct ButtonView: View {
    @State var isLuis:Bool
    var body: some View {
        
        NavigationView {
            GeometryReader{ metrics in
            VStack{
                Text("Elérhető beszédfelismerő szolgáltatások:")
                    .padding()
                    .font(.title)
                    .multilineTextAlignment(TextAlignment.center)
                NavigationLink(destination: ContentView(isLuis: true)) {
                Text("Microsoft LUIS használata")
                    .foregroundColor(Color.white)
                    .frame(width: metrics.size.width * 0.5)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.blue, lineWidth: 10)
                    )
                    .font(.system(size: 15, weight: .heavy, design: .default))
                    .background(Color.blue)
                    .cornerRadius(40)
            }.buttonStyle(DefaultButtonStyle())
                NavigationLink(destination: ContentView(isLuis: false)){
                    Text("Google NLP használata")
                        .foregroundColor(Color.white)
                        .frame(width: metrics.size.width * 0.5)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.blue, lineWidth: 10)
                        )
                        .font(.system(size: 15, weight: .heavy, design: .default))
                        .background(Color.blue)
                        .cornerRadius(40)
                }.buttonStyle(DefaultButtonStyle())
            }
            .padding()
            
            }
            
        }
        
    }

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(isLuis: false)
    }
}
}
