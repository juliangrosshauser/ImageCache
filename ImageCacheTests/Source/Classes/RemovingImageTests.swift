//
//  RemovingImageTests.swift
//  ImageCacheTests
//
//  Created by Julian Grosshauser on 13/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import XCTest
import ImageCache
import DiskCache

class RemovingImageTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        clearAllCachedImages()
    }
    
    func testRemoveAllImagesFromDiskRemovesDiskCacheDirectory() {
        let key = "TestRemovingAllImages"
        let image = testImageWithName("Square", fileExtension: .PNG)
        
        createImageInDiskCache(image, forKey: key)
        
        let completionExpectation = expectationWithDescription("completionHandler called")
        
        let completionHandler: Result<Void> -> Void = { result in
            if case .Failure(let error) = result {
                XCTFail("Removing all images failed: \(error)")
            }
            
            completionExpectation.fulfill()
        }
        
        imageCache.removeAllImagesFromDisk(true, completionHandler: completionHandler)
        
        waitForExpectationsWithTimeout(expectationTimeout, handler: nil)
        
        XCTAssertFalse(imageCacheFileManager.fileExistsAtPath(imageCache.diskCachePath), "Disk cache directory shouldn't exist anymore")
    }
    
    func testRemoveImageForKeyFromDiskRemovesCachedImage() {
        let key = "TestRemovingImage"
        let image = testImageWithName("Square", fileExtension: .PNG)
        
        createImageInDiskCache(image, forKey: key)
        
        let completionExpectation = expectationWithDescription("completionHandler called")
        
        let completionHandler: Result<Void> -> Void = { result in
            if case .Failure(let error) = result {
                XCTFail("Removing cached image failed: \(error)")
            }
            
            completionExpectation.fulfill()
        }
        
        do {
            try imageCache.removeImageForKey(key, fromDisk: true, completionHandler: completionHandler)
        } catch {
            XCTFail("Removing cached image failed: \(error)")
        }
        
        waitForExpectationsWithTimeout(expectationTimeout, handler: nil)
        
        XCTAssertFalse(cachedImageExistsOnDiskForKey(key), "Cached image shouldn't exist anymore")
    }
    }
}
