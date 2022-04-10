//
//  Error-CloudKitMessages.swift
//  ProjectAssistant
//
//  Created by Juan Diego Ocampo on 7/04/22.
//

import CloudKit
import Foundation

extension Error {
    func getCloudKitError() -> CloudError {
        guard let error = self as? CKError else {
            return "An unknown error occurred: \(self.localizedDescription)"
        }

        switch error.code {
        case .badContainer, .badDatabase, .invalidArguments:
            return "A fatal error occurred: \(error.localizedDescription)"
        case .networkFailure, .networkUnavailable, .serverResponseLost, .serviceUnavailable:
            return "There was a problem communicating with iCloud. Please check your network connection and try again."
        case .notAuthenticated:
            return "There was a problem with your iCloud account. Please check that you're logged in to iCloud."
        case .requestRateLimited:
            return "You've hit iCloud's rate limit. Please wait a moment then try again."
        case .quotaExceeded:
            return "You've exceeded your iCloud quota. Please clear up some space then try again."
        default:
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
