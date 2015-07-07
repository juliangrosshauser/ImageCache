//
//  CachingImageTests.swift
//  ImageCacheTests
//
//  Created by Julian Grosshauser on 06/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import XCTest
import ImageCache
import DiskCache

class CachingImageTests: XCTestCase {

    override func setUp() {
        super.setUp()

        clearAllCachedImages()
    }

    func testCachingImageOnDiskCallsCompletionHandlerWithSuccess() {
        let key = "TestCachingData"
        let image = testImageWithName("Square", fileExtension: "png")

        let completionExpectation = expectationWithDescription("completionHandler called")

        let completionHandler: Result<Void> -> Void = { result in
            if case .Failure(let error) = result {
                XCTFail("Caching image failed: \(error)")
            }

            completionExpectation.fulfill()
        }

        do {
            try imageCache.cacheImage(image, forKey: key, onDisk: true, completionHandler: completionHandler)
        } catch {
            XCTFail("Caching image failed: \(error)")
        }

        waitForExpectationsWithTimeout(expectationTimeout, handler: nil)
    }
}
