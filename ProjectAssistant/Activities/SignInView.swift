//
//  SignInView.swift
//  ProjectAssistant
//
//  Created by Juan Diego Ocampo on 6/04/22.
//

import AuthenticationServices
import SwiftUI

struct SignInView: View {
    
    enum SignInStatus {
        case unknown
        case authorized
        case failure(Error?)
    }
    
    @State private var status = SignInStatus.unknown
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            Group {
                switch status {
                case .unknown:
                    VStack(alignment: .leading) {
                        ScrollView {
                            // swiftlint:disable line_length
                            Text("In order to keep our community safe, we ask that you sign in before commenting on a project.\n\nWe don't track your personal information; your name is used for display purposes only.\n\nPlease note: we reserve the right to remove messages that are inappropriate or offensive.")
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        
                        SignInWithAppleButton(onRequest: configureSignIn, onCompletion: completeSignIn)
                            .frame(height: 44)
                            .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                        
                        Button("Cancel", action: close)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                case .authorized:
                    Text("You're all set!")
                case .failure(let error):
                    if let error = error {
                        Text("Sorry, there was an error: \(error.localizedDescription)")
                    } else {
                        Text("Sorry, there was an error.")
                    }
                }
            }
            .padding()
            .navigationTitle("Sign In")
            
        }
    }
    
    func configureSignIn(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName]
    }
    
    func completeSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let auth):
            if let appleID = auth.credential as? ASAuthorizationAppleIDCredential {
                if let fullName = appleID.fullName {
                    let formatter = PersonNameComponentsFormatter()
                    var username = formatter.string(from: fullName).trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if username.isEmpty {
                        // Refuse to allow empty string names
                        username = "User-\(Int.random(in: 1001...9999))"
                    }
                    
                    UserDefaults.standard.set(username, forKey: "username")
                    NSUbiquitousKeyValueStore.default.set(username, forKey: "username")
                    status = .authorized
                    close()
                    return
                }
            }
            
            status = .failure(nil)
        case .failure(let error):
            if let error = error as? ASAuthorizationError {
                if error.errorCode == ASAuthorizationError.canceled.rawValue {
                    status = .unknown
                    return
                }
            }
            
            status = .failure(error)
        }
    }
    
    func close() {
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
