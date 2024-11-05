//
//  AuthService.swift
//  MacroProject
//
//  Created by Agfi on 05/11/24.
//

struct RegisterDTO {
    var email: String
    var password: String
    var fullName: String
}

final class AuthService {
    public static var shared = AuthService()
    private let supabase = SupabaseService.shared.getClient()
    
    func register(user: RegisterDTO, completion: @escaping (_ isSucceed: Bool, _ error: Error?) -> Void) async {
        do {
            try await supabase.auth.signUp(email: user.email,
                                           password: user.password,
                                           data: [
                                            "fullName": .string(user.fullName),
                                           ])
            completion(true, nil)
        } catch {
            print("Failed to register. \(error.localizedDescription)")
            completion(false, error)
        }
    }
    
    func signIn(email: String, password: String) async -> Result<Bool, Error> {
        do {
            try await supabase.auth.signIn(email: email, password: password)
            return .success(true)
        } catch {
            print(error)
            return .failure(error)
        }
    }
    
    func signOut(completion: @escaping (Result<Bool, Error>) -> Void) async {
        do {
            try await supabase.auth.signOut()
            completion(.success(true))
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
