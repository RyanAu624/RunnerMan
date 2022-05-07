//
//  Predictor.swift
//  RunnerMan
//
//  Created by Hin on 3/5/2022.
//

import Foundation
import Vision

typealias RunningAction = detectAction_1

protocol PredictDelegrate : AnyObject {
    func predictor(_ predictor: Predictor, didFindNewRecognizedPoint point:[CGPoint])
    func predictor(_ predictor: Predictor, didLableAction action:String, with confience: Double)
}

class Predictor {
    
    weak var delegate : PredictDelegrate?
    let size = 30
    var posewindow: [VNHumanBodyPoseObservation] = []
    
    init(){
        posewindow.reserveCapacity(size)
    }
    
    func estimation(sampleBuffer: CMSampleBuffer){
        let requesthandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)
        
        let request = VNDetectHumanBodyPoseRequest(completionHandler: bodyhandler(request:error:))
        
        do {
            try requesthandler.perform([request])
        } catch {
            print(error)
        }
    }
    
    func bodyhandler(request: VNRequest, error: Error?){
        guard let observation = request.results as? [VNHumanBodyPoseObservation] else {return}
        
        observation.forEach {
            processObservation($0)
        }
        
        if let result = observation.first {
            storeresult(result)
            labelType()
        }
        
    }
    
    func labelType(){
        guard let running = try? RunningAction(configuration: MLModelConfiguration()),
              let poseArray = prepareInput(observation: posewindow),
              let predictions = try? running.prediction(poses: poseArray) else {return}
        
        let label = predictions.label
        let confience = predictions.labelProbabilities[label] ?? 0
        
        delegate?.predictor(self, didLableAction: label, with: confience)
    }
    
    func prepareInput( observation: [VNHumanBodyPoseObservation])-> MLMultiArray? {
        let numAvilbleFrame = observation.count
        let observationNeeded = 30
        var multiArryBuffer = [MLMultiArray]()
        
        for frameIndex in 0..<min( numAvilbleFrame, observationNeeded){
            let pose = observation[frameIndex]
            do {
                let oneFrameMultiArray = try pose.keypointsMultiArray()
                multiArryBuffer.append(oneFrameMultiArray)
            }catch{
                continue
            }
        }
        if numAvilbleFrame < observationNeeded{
            for _ in 0 ..< (observationNeeded - numAvilbleFrame) {
                do{
                    let oneFrameMultiArray = try MLMultiArray(shape:[1,3,18], dataType: .double)
                    try resetMultiArray(predictionWindow: oneFrameMultiArray)
                    multiArryBuffer.append(oneFrameMultiArray)
                }catch{
                    continue
                }
            }
        }
        return MLMultiArray(concatenating: (multiArryBuffer), axis: 0, dataType: .float)
    }
    
    func resetMultiArray( predictionWindow: MLMultiArray, with value: Double = 0.0) throws {
        let pointer = try UnsafeMutableBufferPointer<Double>(predictionWindow)
        pointer.initialize(repeating: value)
    }
    
    func storeresult(_ observation: VNHumanBodyPoseObservation){
        if posewindow.count >= size {
            posewindow.removeFirst()
        }
    }
    
    func processObservation(_ observation: VNHumanBodyPoseObservation){
        do {
            let recogn = try observation.recognizedPoints(forGroupKey: .all)
            
            let display = recogn.map {
                CGPoint(x: $0.value.x, y: 1 - $0.value.y)
            }
            
            delegate?.predictor(self, didFindNewRecognizedPoint: display)
        } catch {
            print("error")
        }
    }
}
