//
//  RetrievingImageTests.swift
//  ImageCacheTests
//
//  Created by Julian Grosshauser on 12/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import XCTest
import ImageCache
import DiskCache

class RetrievingImageTests: XCTestCase {

    override func setUp() {
        super.setUp()

        clearAllCachedImages()
    }

    func testRetrievingImageCallsCompletionHandlerWithSuccessAndExpectedImage() {
        let key = "TestRetrievingImage"
        let expectedImage = testImageWithName("Square", fileExtension: .PNG)

        createImageInDiskCache(expectedImage, forKey: key)

        let completionExpectation = expectationWithDescription("completionHandler called")

        let completionHandler: Result<UIImage> -> Void = { result in
            switch result {
            case .Success(let image):
                if let expectedImageData = UIImagePNGRepresentation(expectedImage), imageData = UIImagePNGRepresentation(image) {
                    XCTAssertEqual(expectedImageData, imageData, "Retrieved image isn't equal to expected image")

                    completionExpectation.fulfill()
                } else {
                    XCTFail("Creating image data failed")
                }
            case .Failure(let error):
                XCTFail("Retrieving image failed: \(error)")
            }
        }

        do {
            try imageCache.retrieveImageForKey(key, completionHandler: completionHandler)
        } catch {
            XCTFail("Retrieving image failed: \(error)")
        }

        waitForExpectationsWithTimeout(expectationTimeout, handler: nil)
    }
}
