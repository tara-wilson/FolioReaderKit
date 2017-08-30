//
//  FolioReaderWebView.swift
//  FolioReaderKit
//
//  Created by Hans Seiffert on 21.09.16.
//  Copyright (c) 2016 Folio Reader. All rights reserved.
//

import UIKit

/// The custom WebView used in each page
open class FolioReaderWebView: UIWebView {
    var isColors = false
    var isShare = false
    var isOneWord = false

    fileprivate weak var readerContainer: FolioReaderContainer?

    fileprivate var readerConfig: FolioReaderConfig {
        guard let readerContainer = readerContainer else { return FolioReaderConfig() }
        return readerContainer.readerConfig
    }

    fileprivate var book: FRBook {
        guard let readerContainer = readerContainer else { return FRBook() }
        return readerContainer.book
    }

    fileprivate var folioReader: FolioReader {
        guard let readerContainer = readerContainer else { return FolioReader() }
        return self.readerContainer!.folioReader
    }

    override init(frame: CGRect) {
        fatalError("use init(frame:readerConfig:book:) instead.")
    }

    init(frame: CGRect, readerContainer: FolioReaderContainer) {
        self.readerContainer = readerContainer

        super.init(frame: frame)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

        // MARK: - Create and show menu

    func createMenu(options: Bool) {
        
    }
    
    open func setMenuVisible(_ menuVisible: Bool, animated: Bool = true, andRect rect: CGRect = CGRect.zero) {

    }
    
    // MARK: - Java Script Bridge
    
    @discardableResult func js(_ script: String) -> String? {
        let callback = self.stringByEvaluatingJavaScript(from: script)
        if callback!.isEmpty { return nil }
        return callback
    }
    
    // MARK: WebView
    
    func clearTextSelection() {
        // Forces text selection clearing
        // @NOTE: this doesn't seem to always work
        
        self.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = true
    }
    
    func setupScrollDirection() {
        switch self.readerConfig.scrollDirection {
        case .vertical, .defaultVertical, .horizontalWithVerticalContent:
            scrollView.isPagingEnabled = false
            paginationMode = .unpaginated
            scrollView.bounces = true
            break
        case .horizontal:
            scrollView.isPagingEnabled = true
            paginationMode = .leftToRight
            paginationBreakingMode = .page
            scrollView.bounces = false
            break
        }
    }
}
