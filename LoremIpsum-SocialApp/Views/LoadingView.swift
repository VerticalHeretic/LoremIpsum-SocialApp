//
//  LoadingView.swift
//  LoremIpsum-SocialApp
//
//  Created by Lukasz Stachnik on 24/11/2020.
//  Copyright © 2020 Warss. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func commonInit() {
        let viewFromXib = Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
    }
}
