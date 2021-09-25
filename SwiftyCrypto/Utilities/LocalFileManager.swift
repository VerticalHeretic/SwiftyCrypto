//
//  LocalFileManager.swift
//  LocalFileManager
//
//  Created by Łukasz Stachnik on 10/09/2021.
//

import Foundation
import SwiftUI

final class LocalFileManager : ImageSavingManager {
   
    static let instance = LocalFileManager()
    
    private init() { }
    
    /**
        Saves given image in given paths in LocalFiles.
        - Parameters:
            - image: Image to save in UIImage format
            - imageName: Name for the image to save as
            - folderName: Folder in which to save the image
     */
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        //create folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else {
            Info.error("Could not get data from image")
                return
            }
        
        //save image to path
        do {
            try data.write(to: url)
        } catch let error {
            Info.error("Error saving image. ImageName: \(imageName). \(error)")
        }
    }
    
    /// Deletes Image with given **imageName** and **folderName**
    func deleteImage(imageName: String, folderName: String) -> Bool {
        
        guard let url = getURLForImage(imageName: imageName, folderName: folderName) else {
            Info.error("Could not get URL for the image")
            return false
        }
        
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(atPath: url.path)
                return true
            }
            catch let error {
                Info.error("Error deleting file at path: \(url.path). \(error)")
            }
        }
        
        return false
    }
    
    /// Gets UIImage for given **imageName** and **folderName**, if there is no such file it will return nil.
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path) else {
                  return nil
              }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                Info.error("Error creating directory. Folder name: \(folderName). \(error)")
            }
            
        }
    }
    
    /**
        Creates URL for folder with given name
     
        - Parameter folderName: Name of the folder we want the url for
        - Returns: Folder ULR like this  ~/Library/Caches/folderName
     */
    private func getURLForFolder(folderName: String) -> URL? {
        
        // We are saving the images to the caches directory while we can download them anyway so there is no big deal.
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return url.appendingPathComponent(folderName)
    }
    
    /**
        Creates URL for image with givenName and folderName
        - Parameters:
            - imageName: Name of the image we want the url for
            - folderName: Name of the folder we want the url for
        - Returns: File ulr like this ~/Library/Caches/folderName/imageName.png
     */
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        
        return folderURL.appendingPathComponent(imageName + ".png")
    }
    
    
}
