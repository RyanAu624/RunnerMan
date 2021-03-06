//
//  VideoViewController.swift
//  RunnerMan
//
//  Created by RyanAu on 3/5/2022.
//

import UIKit
import AVFoundation
import CoreVideo
import ReplayKit
import MLKit

class VideoViewController: UIViewController {
    private var isUsingFrontCamera = false
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private lazy var captureSession = AVCaptureSession()
    private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
    private var lastFrame: CMSampleBuffer?
    
    private let recorder = RPScreenRecorder.shared()
    
    private lazy var previewOverlayView: UIImageView = {

      precondition(isViewLoaded)
      let previewOverlayView = UIImageView(frame: .zero)
      previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
      previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
      return previewOverlayView
    }()

    private lazy var annotationOverlayView: UIView = {
      precondition(isViewLoaded)
      let annotationOverlayView = UIView(frame: .zero)
      annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
      return annotationOverlayView
    }()

    /// Initialized when one of the pose detector rows are chosen. Reset to `nil` when neither are.
    private var poseDetector: PoseDetector? = nil

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var fpsLabel: UILabel!
    @IBOutlet weak var elblabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    
    /// FPS calculation
    var lastFrameStartTime: TimeInterval = 0
    var averageFpsCounter: Int = 0
    var averageFpsSum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let options = PoseDetectorOptions()
        options.detectorMode = .stream
        poseDetector = PoseDetector.poseDetector(options: options)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        setUpPreviewOverlayView()
        setUpAnnotationOverlayView()
        setUpCaptureSessionOutput()
        setUpCaptureSessionInput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordButton.layer.cornerRadius = recordButton.frame.width / 2
        recordButton.layer.masksToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        
      startSession()
    }

    override func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)

      stopSession()
      stopRecording()
    }

    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()

      previewLayer.frame = cameraView.frame
    }
    
    @IBAction func switchCamera(_ sender: Any) {
      isUsingFrontCamera = !isUsingFrontCamera
      removeDetectionAnnotations()
      setUpCaptureSessionInput()
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        recordButton.isSelected = !recordButton.isSelected
//        shouldSetVideoOutputDelegate(recordButton.isSelected)
        if recordButton.isSelected {
            self.recordButton.layer.cornerRadius = 6
            startRecording()
        } else {
            self.recordButton.layer.cornerRadius = recordButton.frame.width / 2
            self.recordButton.layer.masksToBounds = true
            stopRecording()
        }
    }
    

    private func detectPose(in image: VisionImage, width: CGFloat, height: CGFloat) {
      if let poseDetector = self.poseDetector {
        var poses: [Pose]
        do {
          poses = try poseDetector.results(in: image)
        } catch let error {
          print("Failed to detect poses with error: \(error.localizedDescription).")
          return
        }
        DispatchQueue.main.sync {
          self.updatePreviewOverlayView()
          self.removeDetectionAnnotations()
          self.calcFps()
        }
        guard !poses.isEmpty else {
          print("Pose detector returned no results.")
          return
        }
        DispatchQueue.main.sync {
          // Pose detected. Currently, only single person detection is supported.
          poses.forEach { pose in
            for (startLandmarkType, endLandmarkTypesArray) in UIUtilities.poseConnections() {
              let startLandmark = pose.landmark(ofType: startLandmarkType)
              for endLandmarkType in endLandmarkTypesArray {
                let endLandmark = pose.landmark(ofType: endLandmarkType)
                let startLandmarkPoint = normalizedPoint(
                  fromVisionPoint: startLandmark.position, width: width, height: height)
                let endLandmarkPoint = normalizedPoint(
                  fromVisionPoint: endLandmark.position, width: width, height: height)
                UIUtilities.addLineSegment(
                  fromPoint: startLandmarkPoint,
                  toPoint: endLandmarkPoint,
                  inView: self.annotationOverlayView,
                  color: UIColor.green,
                  width: Constant.lineWidth
                )
                  
              }
            }
              let angle = getangle(Landmark1: pose.landmark(ofType: .rightKnee), Landmark2: pose.landmark(ofType: .rightHip), Landmark3: pose.landmark(ofType: .leftKnee))
              let elbowsangle = elbowsangle(Landmark1: pose.landmark(ofType: .leftWrist), Landmark2: pose.landmark(ofType: .leftElbow), Landmark3: pose.landmark(ofType: .leftShoulder))
              elangle(angle: elbowsangle)
              anglelabel(angle: angle)
        
//            for landmark in pose.landmarks {
//              let landmarkPoint = normalizedPoint(
//                fromVisionPoint: landmark.position, width: width, height: height)
//              UIUtilities.addCircle(
//                atPoint: landmarkPoint,
//                to: self.annotationOverlayView,
//                color: UIColor.red,
//                radius: Constant.smallDotRadius
//              )
//            }
          }
        }
      }
    }

    // MARK: - Private
    private func setUpCaptureSessionOutput() {
      sessionQueue.async {
        self.captureSession.beginConfiguration()
        // When performing latency tests to determine ideal capture settings,
        // run the app in 'release' mode to get accurate performance metrics
        self.captureSession.sessionPreset = AVCaptureSession.Preset.medium

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [
          (kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA,
        ]
        output.alwaysDiscardsLateVideoFrames = true
        let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
        output.setSampleBufferDelegate(self, queue: outputQueue)
        guard self.captureSession.canAddOutput(output) else {
          print("Failed to add capture session output.")
          return
        }
        self.captureSession.addOutput(output)
        self.captureSession.commitConfiguration()
      }
    }
    
    func elangle(angle: CGFloat){
        if angle > 90 && 110 > angle {
            self.elblabel.textColor = UIColor.green
            self.elblabel.text = ("Elbow: \(String(format: "%.2f", angle))")
        } else if angle > 110 && 130 > angle || angle > 70 && 90 > angle{
            self.elblabel.textColor = UIColor.yellow
            self.elblabel.text = ("Elbow: \(String(format: "%.2f", angle))")
        } else if angle > 130 || 70 > angle {
            self.elblabel.textColor = UIColor.red
            self.elblabel.text = ("Elbow: \(String(format: "%.2f", angle))")
        } else {
            self.elblabel.text = "Elbow: "
        }
    }
    
    func anglelabel(angle: CGFloat){
        if angle > 58 && 66 > angle {
            self.fpsLabel.textColor = UIColor.green
            self.fpsLabel.text = ("Angel: \(String(format: "%.2f", angle))")
        } else if angle > 66 && 76 > angle || angle > 48 && 58 > angle{
            self.fpsLabel.textColor = UIColor.yellow
            self.fpsLabel.text = ("Angel: \(String(format: "%.2f", angle))")
        } else if angle > 76 || 48 > angle {
            self.fpsLabel.textColor = UIColor.red
            self.fpsLabel.text = ("Angel: \(String(format: "%.2f", angle))")
        } else {
            self.fpsLabel.text = "Angel: "
        }
    }
    
    private func getangle(Landmark1 : PoseLandmark, Landmark2 : PoseLandmark, Landmark3 : PoseLandmark) -> CGFloat {
        let radians: CGFloat = atan2(Landmark3.position.y - Landmark2.position.y, Landmark3.position.x - Landmark2.position.x) - atan2(Landmark1.position.y - Landmark2.position.y, Landmark1.position.x - Landmark2.position.x)
        var degree = radians * 180.0 / .pi
        degree = abs(degree)
        if degree > 180.0 {
            degree = 360.0 - degree
        }
        return degree
        
    }
    
    private func elbowsangle(Landmark1 : PoseLandmark, Landmark2 : PoseLandmark, Landmark3 : PoseLandmark) -> CGFloat {
        let radians: CGFloat = atan2(Landmark3.position.y - Landmark2.position.y, Landmark3.position.x - Landmark2.position.x) - atan2(Landmark1.position.y - Landmark2.position.y, Landmark1.position.x - Landmark2.position.x)
        var degree = radians * 180.0 / .pi
        degree = abs(degree)
        if degree > 180.0 {
            degree = 360.0 - degree
        }
        return degree
        
    }

    private func setUpCaptureSessionInput() {
      sessionQueue.async {
        let cameraPosition: AVCaptureDevice.Position = self.isUsingFrontCamera ? .front : .back
        guard let device = self.captureDevice(forPosition: cameraPosition) else {
          print("Failed to get capture device for camera position: \(cameraPosition)")
          return
        }
        do {
              self.captureSession.beginConfiguration()
              let currentInputs = self.captureSession.inputs
              for input in currentInputs {
                self.captureSession.removeInput(input)
              }

              let input = try AVCaptureDeviceInput(device: device)
              guard self.captureSession.canAddInput(input) else {
                print("Failed to add capture session input.")
                return
              }
              self.captureSession.addInput(input)
              self.captureSession.commitConfiguration()
        } catch {
          print("Failed to create capture device input: \(error.localizedDescription)")
        }
      }
    }

    private func startSession() {
      sessionQueue.async {
        self.captureSession.startRunning()
      }
    }

    private func stopSession() {
      sessionQueue.async {
        self.captureSession.stopRunning()
      }
    }

    private func setUpPreviewOverlayView() {
      cameraView.addSubview(previewOverlayView)
      NSLayoutConstraint.activate([
        previewOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
        previewOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
        previewOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
        previewOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
      ])
    }

    private func setUpAnnotationOverlayView() {
      cameraView.addSubview(annotationOverlayView)
      NSLayoutConstraint.activate([
        annotationOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
        annotationOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
        annotationOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
        annotationOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
      ])
    }

    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
      if #available(iOS 10.0, *) {
        let discoverySession = AVCaptureDevice.DiscoverySession(
          deviceTypes: [.builtInWideAngleCamera],
          mediaType: .video,
          position: .unspecified
        )
        return discoverySession.devices.first { $0.position == position }
      }
      return nil
    }

    private func removeDetectionAnnotations() {
      for annotationView in annotationOverlayView.subviews {
        annotationView.removeFromSuperview()
      }
    }

    private func updatePreviewOverlayView() {
      guard let lastFrame = lastFrame,
        let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
      else {
        return
      }
      let ciImage = CIImage(cvPixelBuffer: imageBuffer)
      let context = CIContext(options: nil)
      guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
        return
      }
      let rotatedImage = UIImage(cgImage: cgImage, scale: Constant.originalScale, orientation: .right)
      if isUsingFrontCamera {
        guard let rotatedCGImage = rotatedImage.cgImage else {
          return
        }
        let mirroredImage = UIImage(
          cgImage: rotatedCGImage, scale: Constant.originalScale, orientation: .leftMirrored)
        previewOverlayView.image = mirroredImage
      } else {
        previewOverlayView.image = rotatedImage
      }
    }
    
    private func calcFps() {
        let currentFrameTime = Date().timeIntervalSince1970
        let deltaTime = currentFrameTime - lastFrameStartTime
        let currentFps = 1 / deltaTime
        
        averageFpsCounter += 1
        averageFpsSum += Int(currentFps)

        lastFrameStartTime = currentFrameTime
    }

    private func convertedPoints(
      from points: [NSValue]?,
      width: CGFloat,
      height: CGFloat
    ) -> [NSValue]? {
      return points?.map {
        let cgPointValue = $0.cgPointValue
        let normalizedPoint = CGPoint(x: cgPointValue.x / width, y: cgPointValue.y / height)
        let cgPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
        let value = NSValue(cgPoint: cgPoint)
        return value
      }
    }

    private func normalizedPoint(
      fromVisionPoint point: VisionPoint,
      width: CGFloat,
      height: CGFloat
    ) -> CGPoint {
      let cgPoint = CGPoint(x: point.x, y: point.y)
      var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
      normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
      return normalizedPoint
    }
    
    
    private func startRecording() {
        recorder.startRecording { error in
            if let error = error {
                print(error)
            }
        }
        print("Start Recording")
    }
    
    private func stopRecording() {
        recorder.stopRecording { previewViewController, error in
            if let error = error {
                print(error)
            }
            if let previewViewController = previewViewController {
                previewViewController.previewControllerDelegate = self
                self.present(previewViewController, animated: true, completion: nil)
            }
        }
        print("Stop Recording")
    }
    
}

// MARK: RPPreviewViewControllerDelegate
extension VideoViewController: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: AVCaptureVideoDataOutputSampleBufferDelegate
extension VideoViewController: AVCaptureVideoDataOutputSampleBufferDelegate {

  func captureOutput(
    _ output: AVCaptureOutput,
    didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
    guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
      print("Failed to get image buffer from sample buffer.")
      return
    }

    lastFrame = sampleBuffer
    let visionImage = VisionImage(buffer: sampleBuffer)
    let orientation = UIUtilities.imageOrientation(
      fromDevicePosition: isUsingFrontCamera ? .front : .back
    )

    visionImage.orientation = orientation
    let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
    let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
    detectPose(in: visionImage, width: imageWidth, height: imageHeight)
  }
}

// MARK: - Constants
private enum Constant {
  static let videoDataOutputQueueLabel = "com.google.mlkit.visiondetector.VideoDataOutputQueue"
  static let sessionQueueLabel = "com.google.mlkit.visiondetector.SessionQueue"
  static let smallDotRadius: CGFloat = 8.0
  static let lineWidth: CGFloat = 3.0
  static let originalScale: CGFloat = 1.0
}

