//
//  ViewController.swift
//  iOSTest
//
//  Created by Diksha on 04/09/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var friendsCollection:UICollectionView!
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var viewModel = FriendsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        //layout.itemSize = CGSize(width: screenWidth-20, height: screenWidth)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        friendsCollection.collectionViewLayout = layout
        viewModel.getFriendsList(callback: Callback(onSuccess: { response in
            print(response)
            DispatchQueue.main.async {
                self.friendsCollection.reloadData()
            }
        }, onFailure: { error in
            print(error)
        }))

    }
    

}

extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.friendDataModel?.results?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsCollectionViewCell", for: indexPath) as! FriendsCollectionViewCell
        cell.friend = viewModel.friendDataModel?.results?[indexPath.item]
        cell.addShadow()
        cell.backgroundColor = UIColor.white
        cell.contentView.backgroundColor = .white
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sizeArea = CGSize()
        if (UIScreen.main.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
                    print("It's iPad")
                    if self.view.frame.size.width < self.view.frame.size.height {
                        print("It's Portrait iPad")
                        
                        let spacing = self.view.frame.size.width - 25
                        let itemWidth = spacing / 4
                        let itemHeight = itemWidth
                        sizeArea = CGSize(width: itemWidth, height: itemHeight)
                    } else {
                        print("It's Landscape iPad")
                        
                        let spacing = self.view.frame.size.width - 50
                        let itemWidth = spacing / 3
                        let itemHeight = itemWidth
                        sizeArea = CGSize(width: itemWidth, height: itemHeight)
                    }
                } else if (UIScreen.main.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone) {
                    print("It's iPhone")
                    if self.view.frame.size.width < self.view.frame.size.height {
                        print("It's Portrait iPhone")
                        
                        let spacing = self.view.frame.size.width - 15
                        let itemWidth = spacing / 2
                        let itemHeight = itemWidth
                        sizeArea = CGSize(width: itemWidth, height: itemHeight)
                    } else {
                        print("It's Portrait iPhone")
                        
                        let spacing = self.view.frame.size.width - 20
                        let itemWidth = spacing / 3
                        let itemHeight = itemWidth
                        sizeArea = CGSize(width: itemWidth, height: itemHeight)
                    }
                }
        return sizeArea//CGSize(width: screenWidth/2-20, height: (screenWidth/2-20))
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FriendDetailsViewController") as! FriendDetailsViewController
        vc.friend = viewModel.friendDataModel?.results?[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
