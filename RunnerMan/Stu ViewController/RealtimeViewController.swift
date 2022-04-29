//
//  RealtimeViewController.swift
//  RunnerMan
//
//  Created by Hin on 27/4/2022.
//

import UIKit
import AVFoundation

class RealtimeViewController: UIViewController {

    let video = Videocapture()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupvideo()
        // Do any additional setup after loading the view.
    }
    

    private func setupvideo(){
        video.start()
        previewLayer = AVCaptureVideoPreviewLayer(session: video.capturess)
        guard let previewLayer = previewLayer else {return}
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
