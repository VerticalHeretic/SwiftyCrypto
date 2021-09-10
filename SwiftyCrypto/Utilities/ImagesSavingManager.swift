//
//  ImagesSavingManager.swift
//  ImagesSavingManager
//
//  Created by Łukasz Stachnik on 10/09/2021.
//

import Foundation
import SwiftUI

protocol ImageSavingManager {
    func saveImage(image: UIImage, imageName: String, folderName: String)
    func getImage(imageName: String, folderName: String) -> UIImage?
    func deleteImage(imageName: String, folderName: String) -> Bool
}
