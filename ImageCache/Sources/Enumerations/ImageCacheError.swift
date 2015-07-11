//
//  ImageCacheError.swift
//  ImageCache
//
//  Created by Julian Grosshauser on 28/06/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

/**
Contains all `ErrorType`s `ImageCache` can throw
*/
public enum ImageCacheError: ErrorType {

    case EmptyKey
    case ImageDataError
    case CacheMiss
}
