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
