//
//  LoginViewController.swift
//  Unsplash
//
//  Created by KimJaeYoun on 2021/12/21.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    private var webAuthenticationSession: ASWebAuthenticationSession?
    private let unsplashAPIManager = UnsplashAPIManager()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getAuthrization()
    }
}

//MARK: - Method
extension LoginViewController {
    func getAuthrization() {
        guard let URL = try? UnsplashRouter.userAuthorize.asURLRequest().url else {
            return
        }
        let ASwebCallbackURLScheme = "jissCallback"
        
        webAuthenticationSession = ASWebAuthenticationSession(url: URL,
                                                              callbackURLScheme: ASwebCallbackURLScheme) { [weak self] callBackURL, erorr in
            guard erorr == nil,
                  let callBackURL = callBackURL else { return }
            
            guard let accessCode = callBackURL.getValue(for: "code") else { return }
           
            self?.unsplashAPIManager.fetchAccessToken(accessCode: accessCode) { isSuccess in
                guard isSuccess else { return }
                self?.navigationController?.popViewController(animated: true)
            }
        }
        webAuthenticationSession?.presentationContextProvider = self
        webAuthenticationSession?.start()
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
}
