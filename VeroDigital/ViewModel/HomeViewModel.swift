//
//  HomeViewModel.swift
//  VeroDigitalApp
//
//  Created by İbrahim Güler on 1.04.2023.
//

import SwiftUI

class HomeViewModel : ObservableObject {

    @Published var qrCode = UIImage()
    @Published var isShowingScanner = false
    @Published var showDetailView: Bool = false
    @Published var searchActivated: Bool = false
    @Published var animateCurrentMission: Bool = false
    @Published var animateContent: Bool = false
    @Published var offsetAnimation: Bool = false
    
    @Published var selectedMission: Missions?

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    // Used to generate QR code text.
    func getQRCode() {
        let str = "\(selectedMission?.task ?? "")\n\(selectedMission?.title ?? "")\n\(selectedMission?.descriptions ?? "")\n\(selectedMission?.sort ?? "")\n\(selectedMission?.wageType ?? "")\n\(selectedMission?.businessUnitKey ?? "")\n\(selectedMission?.businessUnit ?? "")\n\(selectedMission?.parentTaskID ?? "")\n\(selectedMission?.preplanningBoardQuickSelect ?? "")\n\(selectedMission?.colorCode ?? "")\n\(selectedMission?.workingTime ?? "")\n\(selectedMission?.isAvailableInTimeTrackingKioskMode ?? false)"
        qrCode = generateQRCode(from: str)
    }
    
    // Used to generate QR Code from text.
    private func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
