//
//  FRBook.swift
//  FolioReaderKit
//
//  Created by Heberti Almeida on 09/04/15.
//  Extended by Kevin Jantzer on 12/30/15
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import UIKit

open class FRBook: NSObject {
    var resources = FRResources()
    var metadata = FRMetadata()
    var spine = FRSpine()
    var tableOfContents: [FRTocReference]!
    var flatTableOfContents: [FRTocReference]!
    var opfResource: FRResource!
    var tocResource: FRResource?
    var coverImage: FRResource?
    var version: Double?
    var uniqueIdentifier: String?
    var name: String?

    func title() -> String? {
        return metadata.titles.first
    }

    func authorName() -> String? {
        return metadata.creators.first?.name
    }

    // MARK: - Media Overlay Metadata
    // http://www.idpf.org/epub/301/spec/epub-mediaoverlays.html#sec-package-metadata

    func duration() -> String? {
        return metadata.findMetaByProperty("media:duration");
    }

    // @NOTE: should "#" be automatically prefixed with the ID?
    func durationFor(_ ID: String) -> String? {
        return metadata.findMetaByProperty("media:duration", refinedBy: ID)
    }


    func activeClass() -> String {
        guard let className = metadata.findMetaByProperty("media:active-class") else {
            return "epub-media-overlay-active"
        }
        return className
    }

    func playbackActiveClass() -> String {
        guard let className = metadata.findMetaByProperty("media:playback-active-class") else {
            return "epub-media-overlay-playing"
        }
        return className
    }
    
}
