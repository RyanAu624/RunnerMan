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
    var pointlayer = CAShapeLayer()
    
    var isrunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupvideo()
        video.pred.delegate = self
        // Do any additional setup after loading the view.
    }
    

    private func setupvideo(){
        video.start()
        previewLayer = AVCaptureVideoPreviewLayer(session: video.capturess)
        guard let previewLayer = previewLayer else {return}
        
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        view.layer.addSublayer(pointlayer)
        pointlayer.frame = view.frame
        pointlayer.strokeColor = UIColor.orange.cgColor
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

extension RealtimeViewController: PredictDelegrate {
    func predictor(_ predictor: Predictor, didLableAction action: String, with confience: Double) {
        if action == "start" && confience > 0.5 && isrunning == false {
            print("detected")
            isrunning = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isrunning = false
            }
        }
    }
    
    func predictor(_ predictor: Predictor, didFindNewRecognizedPoint point: [CGPoint]) {
        guard let preview = previewLayer else {return}
        
        let convert = point.map {
            preview.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        
        let combinedPath = CGMutablePath()
        
        for point in convert {
            let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 10, height: 10))
            combinedPath.addPath(dotPath.cgPath)
        }
        pointlayer.path = combinedPath
        
        DispatchQueue.main.async {
            self.pointlayer.didChangeValue(for: \.path)
        }
    }
}
