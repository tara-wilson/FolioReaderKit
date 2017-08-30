//
//  FolioReaderFontsMenu.swift
//  FolioReaderKit
//
//  Created by Heberti Almeida on 27/08/15.
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import UIKit

public enum FolioReaderFont: Int {
    case andada = 0
    case lato
    case lora
    case raleway

    public static func folioReaderFont(fontName: String) -> FolioReaderFont? {
        var font: FolioReaderFont?
        switch fontName {
        case "andada": font = .andada
        case "lato": font = .lato
        case "lora": font = .lora
        case "raleway": font = .raleway
        default: break
        }
        return font
    }

    public var cssIdentifier: String {
        switch self {
        case .andada: return "andada"
        case .lato: return "lato"
        case .lora: return "lora"
        case .raleway: return "raleway"
        }
    }
}

public enum FolioReaderFontSize: Int {
    case xs = 0
    case s
    case m
    case l
    case xl

    public static func folioReaderFontSize(fontSizeStringRepresentation: String) -> FolioReaderFontSize? {
        var fontSize: FolioReaderFontSize?
        switch fontSizeStringRepresentation {
        case "textSizeOne": fontSize = .xs
        case "textSizeTwo": fontSize = .s
        case "textSizeThree": fontSize = .m
        case "textSizeFour": fontSize = .l
        case "textSizeFive": fontSize = .xl
        default: break
        }
        return fontSize
    }

    public var cssIdentifier: String {
        switch self {
        case .xs: return "textSizeOne"
        case .s: return "textSizeTwo"
        case .m: return "textSizeThree"
        case .l: return "textSizeFour"
        case .xl: return "textSizeFive"
        }
    }
}
