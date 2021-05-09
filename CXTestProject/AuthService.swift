//
//  AuthService.swift
//  CXTestProject
//
//  Created by Максим Вечирко on 09.05.2021.
//


import Foundation

class AuthService {
    func auth(completion: @escaping(String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion("SUCCESS")
        }
    }
}
