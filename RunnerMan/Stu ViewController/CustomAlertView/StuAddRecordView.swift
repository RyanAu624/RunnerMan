//
//  StuAddRecordView.swift
//  RunnerMan
//
//  Created by Long Hei Au on 10/4/2022.
//

import UIKit

class StuAddRecordView: UIView {
    
    static let instance = StuAddRecordView()
    
    var stuUid = ""
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var descriptionTF: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("StuAddRecordALview", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        parentView.frame = CGRect(x: 0, y: 0,
                                  width: UIScreen.main.bounds.width,
                                  height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    func showAlert(stuUid: String) {
        self.stuUid = stuUid
        
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
}
