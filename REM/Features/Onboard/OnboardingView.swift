//
//  OnboardingView.swift
//  REM
//
//  Created by yury antony on 04/06/25.
//

import SwiftUI

struct OnboardingView: View {
    // Flag para encerrar o onboarding
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    // Contador de página
    @State private var pageIndex = 0
    
    private let pages: [OnboardingPage] = [
        .init(title: "Bem-vindo ao Sleepp Records",
              description: "Registre cada episódio de paralisia do sono conforme acontecer."),
        .init(title: "Criar um registro",
              description: "Toque no botão “+” na tela principal para adicionar um novo episódio."),
        .init(title: "Selecionar experiências",
              description: "Dentro do registro, marque sensações como “Alucinação Visual” ou “Formigamento”."),
        .init(title: "Editar ou Excluir",
              description: "Altere data, nome, nota e experiências a qualquer momento. Apague com o botão “Delete”."),
        .init(title: "Pronto para usar",
              description: "Agora que você sabe como registrar, comece a logar sempre que ocorrer um episódio!")
    ]
    
    var body: some View {
        VStack {
            Spacer()
            
            // Conteúdo da página atual
            let page = pages[pageIndex]
            Text(page.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.top, 8)
            
            Spacer()
            
            HStack {
                // Botão anterior
                Button(action: {
                    if pageIndex > 0 { pageIndex -= 1 }
                }) {
                    Text("Anterior")
                }
                .disabled(pageIndex == 0)
                
                Spacer()
                
                // Botão pular (só na 1ª a 4ª página)
                if pageIndex < pages.count - 1 {
                    Button("Pular") {
                        hasSeenOnboarding = true
                    }
                }
                
                Spacer()
                
                // Botão próximo ou “Começar” na última página
                Button(action: {
                    if pageIndex < pages.count - 1 {
                        pageIndex += 1
                    } else {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text(pageIndex < pages.count - 1 ? "Próximo" : "Começar")
                }
            }
            .padding()
        }
        // Caso queira, você pode colocar uma PageControl automática:
        .overlay(
            HStack(spacing: 8) {
                ForEach(0..<pages.count) { idx in
                    Circle()
                        .fill(idx == pageIndex ? Color.awake : Color.gray.opacity(0.4))
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 40)
            , alignment: .bottom
        )
        .background(Color("OnboardingBackground").edgesIgnoringSafeArea(.all))
    }
}

// Modelo simples para cada página do onboarding
struct OnboardingPage {
    let title: String
    let description: String
}
