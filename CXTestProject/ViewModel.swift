//
//  ViewModel.swift
//  CXTestProject
//
//  Created by Максим Вечирко on 09.05.2021.
//

import Combine
import UIKit.UIColor

private enum SignUpErrors: String {
    case shortName = "username should me more that 5 symbols"
    case prohibitedPassword = "password must not contains to Admin, Password, and so on"
    case passwordMatched = "password doesnt match"
    case passwordShort = "password should be more that 8 symbols"
    case success = ""
}

class ViewModelImpl: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var veryfyPassword: String = ""
    
    @Published var warningMessage: String = ""
    
    @Published var buttonIsEnable: Bool = false
    
    @Published var textColor: UIColor = .red
    
    private var authService = AuthService()
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var repeatPasswordIsMatch: AnyPublisher<SignUpErrors, Never> {
        $veryfyPassword
            .map { [self] in
                self.textColor = .red
                if $0 == password {
                    return .success
                } else {
                    return .passwordMatched
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordIsMatch: AnyPublisher<SignUpErrors, Never> {
        $password
            .map { [self] in
                self.textColor = .red
                if !veryfyPassword.isEmpty {
                    if $0 == veryfyPassword {
                        return .success
                    } else {
                        return .passwordMatched
                    }
                } else {
                    return .success
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    private var isPasswordValide: AnyPublisher<SignUpErrors, Never> {
        $password
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map({
                self.textColor = .red
                if $0 == "admin" || $0 == "password" {
                    return .prohibitedPassword
                } else {
                    if !$0.isEmpty {
                        if $0.count < 8 {
                            return .passwordShort
                        } else {
                            return .success
                        }
                    } else {
                        return .success
                    }
                }
            })
            .eraseToAnyPublisher()
    }
    
    private var isUsernameValide: AnyPublisher<SignUpErrors, Never> {
        $username
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map({
                self.textColor = .red
                if $0.count < 5 {
                    return .shortName
                } else {
                    return .success
                }
            })
            .eraseToAnyPublisher()
    }
    
    private var formIsValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isUsernameValide, isPasswordValide)
            .map { username, password in
                return username == .success && password == .success
            }
            .eraseToAnyPublisher()
    }
    
    init() {
        
        isUsernameValide
            .receive(on: RunLoop.main)
            .map({
                $0.rawValue
            })
            .assign(to: \.warningMessage, on: self)
            .store(in: &cancellableSet)
        
        isPasswordValide
            .receive(on: RunLoop.main)
            .map({
                $0.rawValue
            })
            .assign(to: \.warningMessage, on: self)
            .store(in: &cancellableSet)
        
        passwordIsMatch
            .receive(on: RunLoop.main)
            .map(
                {$0.rawValue
                })
            .assign(to: \.warningMessage, on: self)
            .store(in: &cancellableSet)
        
        repeatPasswordIsMatch
            .receive(on: RunLoop.main)
            .map(
                {$0.rawValue
                })
            .assign(to: \.warningMessage, on: self)
            .store(in: &cancellableSet)
        
        formIsValid
            .receive(on: RunLoop.main)
            .assign(to: \.buttonIsEnable, on: self)
            .store(in: &cancellableSet)
    }
    
    func singUp() {
        authService.auth { [self] (response) in
            self.textColor = .green
            self.warningMessage = response
        }
    }
}

