//
//  ImagePicker.swift
//  AmplifyPredictionsSampleApp
//
//  Created by Stone, Nicki on 11/5/19.
//  Copyright © 2019 AWS. All rights reserved.
//
import SwiftUI
import Combine
import UIKit

final class ImagePicker : ObservableObject {

    static let shared : ImagePicker = ImagePicker()

    private init() {}  //force using the singleton: ImagePicker.shared

    let view = ImagePicker.View()
    let coordinator = ImagePicker.Coordinator()

    // Bindable Object part
    let willChange = PassthroughSubject<UIImage?, Never>()
    
    let willUpdate = PassthroughSubject<URL?, Never>()

    @Published var image: UIImage? = nil {
        didSet {
            if image != nil {
                willChange.send(image)
            }
        }
    }
    
    @Published var imageUrl: URL? = nil {
        didSet {
            if imageUrl != nil {
                willUpdate.send(imageUrl)
            }
        }
    }
    
 
}


extension ImagePicker {

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        // UIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
            print(imageURL)
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
           
            //to send to Identify
            ImagePicker.shared.imageUrl = imageURL
            //for display of the image
            ImagePicker.shared.image = uiImage
            picker.dismiss(animated:true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated:true)
        }
    }


    struct View: UIViewControllerRepresentable {

        func makeCoordinator() -> Coordinator {
            ImagePicker.shared.coordinator
        }

        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker.View>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController,
                                    context: UIViewControllerRepresentableContext<ImagePicker.View>) {

        }

    }

}

