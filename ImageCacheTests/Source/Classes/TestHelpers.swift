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
