//
//  CropProfileImageViewController.swift
//  Elo
//
//  Created by Jed Kutai on 12/16/23.
//

import SwiftUI
import TOCropViewController

struct CropProfileImageViewController: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> TOCropViewController {
        let cropViewController = TOCropViewController(croppingStyle: .default, image: image!)
        
        // Enable aspect ratio lock and set it to 1:1
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.resetAspectRatioEnabled = false
        cropViewController.aspectRatioPreset = .presetSquare
        
        cropViewController.cancelButtonHidden = true
        
        cropViewController.delegate = context.coordinator
        return cropViewController
    }

    func updateUIViewController(_ uiViewController: TOCropViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, TOCropViewControllerDelegate {
        let parent: CropProfileImageViewController

        init(_ parent: CropProfileImageViewController) {
            self.parent = parent
        }

        func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
            parent.image = image
            parent.presentationMode.wrappedValue.dismiss()
        }

        func cropViewControllerDidCancel(_ cropViewController: TOCropViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

