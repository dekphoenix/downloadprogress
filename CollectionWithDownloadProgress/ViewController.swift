//
//  ViewController.swift
//  CollectionWithDownloadProgress
//
//  Created by BURIN TECHAMA on 2/15/2560 BE.
//  Copyright © 2560 benmore. All rights reserved.
//

import UIKit
import Alamofire

let kStatusNotDownload = 0
let kStatusPreparing = 1
let kStatusSuccess = 2

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var bookData:[String] = ["1","2","3","4","5","6","7"]

    @IBOutlet weak var collectionBook: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBAction func backTab(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath) as? LoadingCollectionViewCell {
            
            cell.setBook(bookID: bookData[indexPath.row])
            cell.backgroundColor = UIColor.lightGray
            cell.delegate = self
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) as? LoadingCollectionViewCell {
//            if UserDefaults.standard.integer(forKey: "HP\(bookData[indexPath.row]).pdf") == kStatusSuccess {
//                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
//                    vc.setupData(bookID: cell.bookID!)
//                    self.present(vc, animated: true, completion: nil)
//                }
//            }else if (UserDefaults.standard.integer(forKey: "HP\(bookData[indexPath.row]).pdf") == kStatusNotDownload){
//                let urlString = "http://www.narutoroyal.com/HP\(bookData[indexPath.row]).pdf"
//                cell.downloadBook(bookID: bookData[indexPath.row], downloadURLString: urlString)
//            }
//        }
    }
    
    func updateCellProgress(bookID: String,progress:Double) {
        let visibleCell = collectionBook.visibleCells as! [LoadingCollectionViewCell]
        for cell in visibleCell {
            if cell.bookID == bookID {
                print("Download Progress: \(progress*100)")
                cell.loadingLabel.text = String(format: "%.2f", progress*100)
            }
        }
    }
    
    func updateCellStatus(bookID: String) {
        let visibleCell = collectionBook.visibleCells as! [LoadingCollectionViewCell]
        for cell in visibleCell {
            if cell.bookID == bookID {
                cell.loadingLabel.text = "Open"
                cell.isUserInteractionEnabled = true
            }
        }
    }
    
}


extension ViewController : LoadingCollectionViewCellDelegate {
    
    func didTapDownloadBook(bookID: String, downloadURL: URL) {
        Alamofire.request(downloadURL).downloadProgress(closure: { (progress) in
            self.updateCellProgress(bookID: bookID,progress: progress.fractionCompleted)
            
        }).responseData { (response) in
            if let data = response.result.value {
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileURL = documentsURL.appendingPathComponent("HP\(bookID).pdf")
                do {
                    try data.write(to:fileURL, options: .atomic)
                    UserDefaults.standard.set(kStatusSuccess, forKey: "HP\(bookID).pdf")
                    self.updateCellStatus(bookID: bookID)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func openWebView(bookId: String){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            vc.setupData(bookID: bookId)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}


