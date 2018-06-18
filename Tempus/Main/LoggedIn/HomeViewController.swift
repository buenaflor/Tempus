//
//  HomeViewController.swift
//  Tempus
//
//  Created by Giancarlo Buenaflor on 14.06.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

enum HomeOptions {
    case polls
    case statistics
    case settings
}

extension HomeOptions {
    
    var text: String {
        switch self {
        case .polls:
            return "Polls"
        case .statistics:
            return "Statistics"
        case .settings:
            return "Settings"
        }
    }
    
    static let all: [HomeOptions] = [ .polls, .statistics, .settings ]
}

class HomeViewController: BaseViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(UICollectionViewCell.self)
        cv.bounces = false
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let customNavigationView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Temp.mainDarker
        return view
    }()
    
    private let pollsButton: UIButton = {
        let btn = TempusButton(title: "Polls", titleColor: .white, backgroundColor: .clear, font: .TempRegular)
        return btn
    }()
    
    private let statisticsButton: TempusButton = {
        let btn = TempusButton(title: "Statistics", titleColor: .lightGray, backgroundColor: .clear, font: .TempRegular)
        return btn
    }()
    
    private let settingsButton: UIButton = {
        let btn = TempusButton(title: "Settings", titleColor: .lightGray, backgroundColor: .clear, font: .TempRegular)
        return btn
    }()
    
    private let indicatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var navigationStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [ pollsButton, statisticsButton, settingsButton ])
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        return sv
    }()
    
    private let homeOptions = HomeOptions.all
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        setStatusBarColor(UIColor.Temp.mainDarker)
        
        view.add(subview: customNavigationView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.15)
            ]}
        
        customNavigationView.add(subview: navigationStackView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.35)
            ]}
        
        
        
        view.add(subview: collectionView) { (v, p) in [
            v.topAnchor.constraint(equalTo: customNavigationView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(UICollectionViewCell.self, for: indexPath)
        let option = homeOptions[indexPath.row]
        
        switch option {
        case .polls:
            cell.backgroundColor = .red
        case .statistics:
            cell.backgroundColor = .blue
        case .settings:
            cell.backgroundColor = .green
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
