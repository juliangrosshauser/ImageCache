//
//  ImageCacheTests.swift
//  ImageCacheTests
//
//  Created by Julian Grosshauser on 26/06/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import XCTest
import ImageCache

let imageCacheIdentifier = "TestImageCache"
let imageCache = ImageCache(identifier: imageCacheIdentifier)
let imageCacheFileManager = NSFileManager()
let expectationTimeout = 0.05

class ImageCacheTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    func testDiskCachePathGetsCorrectlySet() {
        let bundleIdentifier = NSBundle.mainBundle().bundleIdentifier ?? "DiskCache"

        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        let diskCachePath = paths.first!.stringByAppendingPathComponent("\(bundleIdentifier).\(imageCacheIdentifier)")

        XCTAssertEqual(diskCachePath, imageCache.diskCachePath, "diskCachePath wasn't correctly set")
    }
}
