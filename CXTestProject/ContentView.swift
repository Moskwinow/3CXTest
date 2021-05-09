//
//  ContentView.swift
//  CXTestProject
//
//  Created by Максим Вечирко on 09.05.2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel: ViewModelImpl = ViewModelImpl()
    
    var body: some View {
        GeometryReader(content: { geometry in
            VStack(alignment: .leading, spacing: 30, content: {
                Image("icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .frame(width: geometry.size.width,
                           height: geometry.size.height / 4,
                           alignment: .center)
                VStack(alignment: .center, spacing: 10, content: {
                    Text(viewModel.warningMessage)
                        .foregroundColor(Color(viewModel.textColor))
                    TextField("Username", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
    
                    SecureField("Verify password", text: $viewModel.veryfyPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Sign Up") {
                        viewModel.singUp()
                    }
                    .disabled(!viewModel.buttonIsEnable)
                    
                })
                .padding()
                
            })
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
