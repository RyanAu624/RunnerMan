//
//  Video.swift
//  RunnerMan
//
//  Created by Hin on 27/4/2022.
//

import Foundation
import AVFoundation

class Videocapture: NSObject{
    let capturess = AVCaptureSession()
    let output = AVCaptureVideoDataOutput()
    
    override init(){
        super.init()
        guard let capture = AVCaptureDevice.default(for: .video),
                let input = try? AVCaptureDeviceInput(device: capture) else {return}
        capturess.sessionPreset = AVCaptureSession.Preset.high
        capturess.addInput(input)
        
        capturess.addOutput(output)
        output.alwaysDiscardsLateVideoFrames = true
    }

    func start(){
        capturess.startRunning()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoDispatchQueue"))
    }
}

extension Videocapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let videoData = sampleBuffer
        print(videoData)
    }
}
