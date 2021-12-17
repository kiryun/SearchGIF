//
//  ContentCell.swift
//  SearchGIF
//
//  Created by Wimes on 2021/12/16.
//

import UIKit
import RxSwift

class ContentCell: UICollectionViewCell {
    
    let disposeBag = DisposeBag()
    
    let imageView = UIImageView()
    
    override init(frame: CGRect){
        super.init(frame: frame)
        print("@@ init")
        
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(imageURL: String){
        print(imageURL)
        
        Observable.just(imageURL)
            .compactMap{URL(string: $0) }
            .map{ try Data(contentsOf: $0) }
            .map{ UIImage(data: $0) }
            .bind(to: self.imageView.rx.image)
            .disposed(by: self.disposeBag)
    }
    
    func setupUI(){
        self.imageView.backgroundColor = .gray
        self.imageView.contentMode = .scaleToFill
        
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(self.contentView)
        }
    }
}
