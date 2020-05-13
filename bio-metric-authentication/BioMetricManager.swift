//
//  BioMetricManager.swift
//  bio-metric-authentication
//
//  Created by Yoeun Samrith on 5/10/20.
//  Copyright © 2020 Yoeun Samrith. All rights reserved.
//

import Foundation
import LocalAuthentication

class BioMetricManager {
    
    static let shared = BioMetricManager()
    
    private let context = LAContext()
    
    let authenticationReason = "using Bio-Metric to authenticate user"
    let evaluationPolcy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
    
    func isBioMetricFeatureAvailable() -> Bool {
        return context.canEvaluatePolicy(evaluationPolcy, error: nil)
    }
    
    var bioMetricType: LABiometryType {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        return context.biometryType
    }
    
    func shouldAuthenticate(callback: @escaping (_ success: Bool, _ message: String) -> Void) {
        let context = LAContext()
        context.evaluatePolicy(evaluationPolcy,
                               localizedReason: authenticationReason,
                               reply: { (success, error) in
                                
                                var message = "Success"
                                
                                if let error = error  {
                                    switch error {
                                    case LAError.userFallback:
                                        message = "should handle action when user press Enter Password"
                                        
                                    default :
                                        message = error.localizedDescription
                                    }
                                }
                                
                                DispatchQueue.main.async {
                                    callback(success, message)
                                }
        })
    }
    
}
