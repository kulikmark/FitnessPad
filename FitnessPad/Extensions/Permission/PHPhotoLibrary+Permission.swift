//
//  PHPhotoLibrary+Permission.swift
//  FitnessPad
//
//  Created by Марк Кулик on 13.01.2025.
//

import SwiftUI
import PhotosUI

extension PHPhotoLibrary {
    static func checkPermission(completion: @escaping (Bool, PHAuthorizationStatus) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            completion(true, status)
        case .denied, .restricted:
            completion(false, status)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    completion(newStatus == .authorized || newStatus == .limited, newStatus)
                }
            }
        @unknown default:
            completion(false, status)
        }
    }
}
