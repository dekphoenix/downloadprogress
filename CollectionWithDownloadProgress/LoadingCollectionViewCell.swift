//
//  LoadingCollectionViewCell.swift
//  CollectionWithDownloadProgress
//
//  Created by BURIN TECHAMA on 2/15/2560 BE.
//  Copyright © 2560 benmore. All rights reserved.
//

import UIKit
import Alamofire

protocol LoadingCollectionViewCellDelegate: class {
    func didTapDownloadBook(bookID:String,downloadURL:URL)
    func openWebView(bookId:String)
}

class LoadingCollectionViewCell: UICollectionViewCell {
    
    weak var delegate:LoadingCollectionViewCellDelegate?
    
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var bookID:String?
    
    func setBook(bookID:String) {
        self.bookID = bookID
        self.nameLabel.text = "Harry Potter \(bookID).pdf"
        if UserDefaults.standard.integer(forKey: "HP\(bookID).pdf") == kStatusSuccess {
            self.loadingLabel.text = "Open"
            self.isUserInteractionEnabled = true
        }else if UserDefaults.standard.integer(forKey: "HP\(bookID).pdf") == kStatusPreparing {
            self.loadingLabel.text = "Preparing"
            self.isUserInteractionEnabled = false
        }else{
            self.loadingLabel.text = "Download"
            self.isUserInteractionEnabled = true
        }
    }
    
    func downloadBook(bookID:String,downloadURLString:String) {
        //set up UI
        self.loadingLabel.text = "Preparing"
        UserDefaults.standard.set(kStatusPreparing, forKey: "HP\(bookID).pdf")
        self.isUserInteractionEnabled = false
        if let url = URL(string: downloadURLString) {
            self.delegate?.didTapDownloadBook(bookID: bookID, downloadURL: url)
        }
    }
    @IBAction func selectBook(_ sender: Any) {
        if UserDefaults.standard.integer(forKey: "HP\(bookID!).pdf") == kStatusSuccess {
            self.delegate?.openWebView(bookId: bookID!)
        }else if (UserDefaults.standard.integer(forKey: "HP\(bookID!).pdf") == kStatusNotDownload){
            let urlString = "http://www.narutoroyal.com/HP\(bookID!).pdf"
            downloadBook(bookID: bookID!, downloadURLString: urlString)
        }
    }
}
