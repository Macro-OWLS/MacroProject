//
//  FirebaseAuthService.swift
//  MacroProject
//
//  Created by Agfi on 09/11/24.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

final class FirebaseAuthService {
    public static var shared = FirebaseAuthService()
    private let db = Firestore.firestore()
    
    private init() { }
    
    func register(registerInput: RegisterDTO) async -> AuthDataResult? {
        do {
            return try await Auth.auth().createUser(withEmail: registerInput.email, password: registerInput.password)
        } catch {
            return nil
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(NSError(domain: "InvalidCredentials", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid email or password"])))
                return
            }
            
            if let authDataResult = authResult {
                completion(.success(authDataResult))
            } else {
                completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Sign-in failed"])))
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(true))
        } catch let signOutError {
            completion(.failure(signOutError))
        }
    }
    
    func getSessionUser() -> User? {
        return Auth.auth().currentUser
    }
}
