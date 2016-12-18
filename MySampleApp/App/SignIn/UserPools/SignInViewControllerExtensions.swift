//
//  SignInViewControllerExtensions.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.5
//
//

import Foundation
import AWSCognitoIdentityProvider
import AWSMobileHubHelper

// Extension containing methods which call different operations on Cognito User Pools (Sign In, Sign Up, Forgot Password)
extension SignInViewController {
    
    func handleCustomSignIn() {
        // set the interactive auth delegate to self, since this view controller handles the login process for user pools
        AWSCognitoUserPoolsSignInProvider.sharedInstance().setInteractiveAuthDelegate(self)
        self.handleLoginWithSignInProvider(AWSCognitoUserPoolsSignInProvider.sharedInstance())
    }
    
    func handleUserPoolSignUp () {
        let storyboard = UIStoryboard(name: "UserPools", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SignUp")
            self.presentViewController(viewController, animated:true, completion:nil);
    }
    
    func handleUserPoolForgotPassword () {
        let storyboard = UIStoryboard(name: "UserPools", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ForgotPassword")
            self.presentViewController(viewController, animated:true, completion:nil);
    }
}

// Extension to adopt the `AWSCognitoIdentityInteractiveAuthenticationDelegate` protocol
extension SignInViewController: AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    // this function handles the UI setup for initial login screen, in our case, since we are already on the login screen, we just return the View Controller instance
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        return self
    }
    
    // prepare and setup the ViewController that manages the Multi-Factor Authentication
    func startMultiFactorAuthentication() -> AWSCognitoIdentityMultiFactorAuthentication {
        let storyboard = UIStoryboard(name: "UserPools", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MFA")
        dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(viewController, animated:true, completion:nil);
        })
        return viewController as! AWSCognitoIdentityMultiFactorAuthentication
    }
}

// Extension to adopt the `AWSCognitoIdentityPasswordAuthentication` protocol
extension SignInViewController: AWSCognitoIdentityPasswordAuthentication {
    
    func getPasswordAuthenticationDetails(authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource) {
        self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
    }
    
    func didCompletePasswordAuthenticationStepWithError(error: NSError?) {
        if let error = error {
            dispatch_async(dispatch_get_main_queue(), {
                UIAlertView(title: error.userInfo["__type"] as? String,
                    message: error.userInfo["message"] as? String,
                    delegate: nil,
                    cancelButtonTitle: "Ok").show()
            })
        }
    }
}

// Extension to adopt the `AWSCognitoUserPoolsSignInHandler` protocol
extension SignInViewController: AWSCognitoUserPoolsSignInHandler {
    func handleUserPoolSignInFlowStart() {
        // check if both username and password fields are provided
        guard let username = self.customUserIdField.text where !username.isEmpty,
            let password = self.customPasswordField.text where !password.isEmpty else {
                dispatch_async(dispatch_get_main_queue(), {
                    UIAlertView(title: "Missing UserName / Password",
                        message: "Please enter a valid user name / password.",
                        delegate: nil,
                        cancelButtonTitle: "Ok").show()
                })
                return
        }
        // set the task completion result as an object of AWSCognitoIdentityPasswordAuthenticationDetails with username and password that the app user provides
        self.passwordAuthenticationCompletion?.setResult(AWSCognitoIdentityPasswordAuthenticationDetails(username: username, password: password))
    }
}
