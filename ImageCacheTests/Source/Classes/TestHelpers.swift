//
//  TestHelpers.swift
//  ImageCacheTests
//
//  Created by Julian Grosshauser on 06/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import XCTest
import ImageCache

func clearAllCachedImages() {
    // clear memory cache
    imageCache.removeAllImagesFromDisk(false, completionHandler: nil)

    // clear disk cache
    do {
        if imageCacheFileManager.fileExistsAtPath(imageCache.diskCachePath) {
            try imageCacheFileManager.removeItemAtPath(imageCache.diskCachePath)
        }
    } catch {
        XCTFail("Error clearing disk cache: \(error)")
    }
}

func testImageWithName(name: String, fileExtension: FileExtension) -> UIImage {
    let resourceURL = NSBundle(forClass: ImageCacheTests.self).resourceURL!
    let testImagesDirectory = resourceURL.URLByAppendingPathComponent("TestImages", isDirectory: true)

    guard let testImagePath = testImagesDirectory.URLByAppendingPathComponent("\(name).\(fileExtension)").path else {
        XCTFail("Test image with name \(name) and file extension \(fileExtension) doesn't exist")

        // the following return statement will never be executed because of the above `XCTFail()`,
        // but the Swift compiler is only happy when the `guard` body isn't falling through
        return UIImage()
    }

    guard let testImage = UIImage(contentsOfFile: testImagePath) else {
        XCTFail("Test image with name \(name) and file extension \(fileExtension) can't be loaded")

        // the following return statement will never be executed because of the above `XCTFail()`,
        // but the Swift compiler is only happy when the `guard` body isn't falling through
        return UIImage()
    }

    return testImage
}

func cachedImageExistsOnDiskForKey(key: String) -> Bool {
    let filePath = imageCache.diskCachePath.stringByAppendingPathComponent(key)
    
    return imageCacheFileManager.fileExistsAtPath(filePath)
}

func cachedImageOnDiskForKey(key: String) throws -> UIImage {
    let filePath = imageCache.diskCachePath.stringByAppendingPathComponent(key)

    if let data = NSData(contentsOfFile: filePath) {
        if let image = UIImage(data: data, scale: UIScreen.mainScreen().scale) {
            return image
        } else {
            throw ImageCacheError.ImageDataError
        }
    } else {
        throw ImageCacheError.CacheMiss
    }
}

func createImageInDiskCache(image: UIImage, forKey key: String) {
    guard let imageData = UIImagePNGRepresentation(image) else {
        XCTFail("Can't create image data")

        // the following return statement will never be executed because of the above `XCTFail()`,
        // but the Swift compiler is only happy when the `guard` body isn't falling through
        return
    }

    if key.isEmpty {
        XCTFail("Can't create image in disk cache with empty key")
    }

    if !imageCacheFileManager.fileExistsAtPath(imageCache.diskCachePath) {
        do {
            try imageCacheFileManager.createDirectoryAtPath(imageCache.diskCachePath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            XCTFail("Creating cache directory failed: \(error)")
        }
    }

    let filePath = imageCache.diskCachePath.stringByAppendingPathComponent(key)

    XCTAssertTrue(imageCacheFileManager.createFileAtPath(filePath, contents: imageData, attributes: nil), "Creating image in disk cache failed")
}
