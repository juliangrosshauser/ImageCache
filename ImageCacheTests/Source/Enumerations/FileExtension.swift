//
//  FileExtension.swift
//  ImageCacheTests
//
//  Created by Julian Grosshauser on 08/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

/**
Contains all possible file extensions of test images.
*/
public enum FileExtension: String, CustomStringConvertible {

    case JPG = "jpg"
    case PNG = "png"

    //MARK: CustomStringConvertible

    public var description: String {
        return self.rawValue
    }
}
