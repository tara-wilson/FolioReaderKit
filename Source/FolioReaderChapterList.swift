//
//  FolioReaderChapterList.swift
//  FolioReaderKit
//
//  Created by Heberti Almeida on 15/04/15.
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import UIKit

/// Table Of Contents delegate
@objc public protocol FolioReaderChapterListDelegate: class {
    /**
     Notifies when the user selected some item on menu.
     */
    func chapterList(_ chapterList: FolioReaderChapterList, didSelectRowAtIndexPath indexPath: IndexPath, withTocReference reference: FRTocReference)
    
    /**
     Notifies when chapter list did totally dismissed.
     */
    func chapterList(didDismissedChapterList chapterList: FolioReaderChapterList)
}

public class FolioReaderChapterList: UITableViewController {
    
    public var delegate: FolioReaderChapterListDelegate?
    public var tocItems = [FRTocReference]()
    fileprivate var book: FRBook
    fileprivate var readerConfig: FolioReaderConfig
    fileprivate var folioReader: FolioReader
    
    init(folioReader: FolioReader, readerConfig: FolioReaderConfig, book: FRBook, delegate: FolioReaderChapterListDelegate?) {
        self.readerConfig = readerConfig
        self.folioReader = folioReader
        self.delegate = delegate
        self.book = book
        
        super.init(style: UITableViewStyle.plain)
        self.tocItems = self.book.flatTableOfContents
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not supported")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.tableView.register(FolioReaderChapterListCell.self, forCellReuseIdentifier: kReuseCellIdentifier)
        self.tableView.separatorInset = UIEdgeInsets.zero
        self.tableView.backgroundColor = self.folioReader.isNight(self.readerConfig.nightModeMenuBackground, self.readerConfig.menuBackgroundColor)
        self.tableView.separatorColor = self.folioReader.isNight(self.readerConfig.nightModeSeparatorColor, self.readerConfig.menuSeparatorColor)
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 50
        
        // Create TOC list
        
    }
    
    // MARK: - Table view data source
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tocItems.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseCellIdentifier, for: indexPath) as! FolioReaderChapterListCell
        
        cell.setup(withConfiguration: self.readerConfig)
        let tocReference = tocItems[(indexPath as NSIndexPath).row]
        let isSection = tocReference.children.count > 0
        
        cell.indexLabel?.text = tocReference.title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Add audio duration for Media Ovelay
        if let resource = tocReference.resource {
            if let mediaOverlay = resource.mediaOverlay {
                let duration = self.book.durationFor("#"+mediaOverlay)
                
                if let durationFormatted = (duration != nil ? duration : "")?.clockTimeToMinutesString() {
                    let text = cell.indexLabel?.text ?? ""
                    cell.indexLabel?.text = text + (duration != nil ? (" - " + durationFormatted) : "")
                }
            }
        }
        
        // Mark current reading chapter
        if
            let currentPageNumber = self.folioReader.readerCenter?.currentPageNumber,
            let reference = self.book.spine.spineReferences[safe: currentPageNumber - 1],
            (tocReference.resource != nil) {
            let resource = reference.resource
            cell.indexLabel?.textColor = (tocReference.resource == resource ? self.readerConfig.tintColor : self.readerConfig.menuTextColor)
        }
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.contentView.backgroundColor = isSection ? UIColor(white: 0.7, alpha: 0.1) : UIColor.clear
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    // MARK: - Table view delegate
    public func didSelect(indexPath: IndexPath) {
        let tocReference = tocItems[(indexPath as NSIndexPath).row]
        delegate?.chapterList(self, didSelectRowAtIndexPath: indexPath, withTocReference: tocReference)
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tocReference = tocItems[(indexPath as NSIndexPath).row]
        delegate?.chapterList(self, didSelectRowAtIndexPath: indexPath, withTocReference: tocReference)
        
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss { 
            self.delegate?.chapterList(didDismissedChapterList: self)
        }
    }
}

class FolioReaderChapterListCell: UITableViewCell {
    var indexLabel: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.indexLabel = UILabel()
    }
    
    func setup(withConfiguration readerConfig: FolioReaderConfig) {
        
        self.indexLabel?.lineBreakMode = .byWordWrapping
        self.indexLabel?.numberOfLines = 0
        self.indexLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.indexLabel?.font = UIFont(name: "Avenir-Light", size: 17)
        self.indexLabel?.textColor = readerConfig.menuTextColor
        
        if let label = self.indexLabel {
            self.contentView.addSubview(label)
            
            // Configure cell contraints
            var constraints = [NSLayoutConstraint]()
            let views = ["label": label]
            
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[label]-15-|", options: [], metrics: nil, views: views).forEach {
                constraints.append($0 as NSLayoutConstraint)
            }
            
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-16-[label]-16-|", options: [], metrics: nil, views: views).forEach {
                constraints.append($0 as NSLayoutConstraint)
            }
            
            self.contentView.addConstraints(constraints)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // As the `setup` is called at each reuse, make sure the label is added only once to the view hierarchy.
        self.indexLabel?.removeFromSuperview()
    }
}
