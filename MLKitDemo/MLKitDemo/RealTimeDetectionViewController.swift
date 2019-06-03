//
//  RealTimeDetectionViewController.swift
//  MLKitDemo
//
//  Created by Ekachai Limpisoot on 2/6/2562 BE.
//  Copyright © 2562 Ekachai Limpisoot. All rights reserved.
//

import UIKit
import AVKit
import Firebase

class RealTimeDetectionViewController: UIViewController {

    var session = AVCaptureSession()
    lazy var vision = Vision.vision()
    var isDetecting = false
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var outputView: UIVisualEffectView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outputView.layer.cornerRadius = 15.0
        startLiveVideo()
        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         stopLiveVideo()
    }

    override func viewDidLayoutSubviews() {
        imageView.layer.sublayers?[0].frame = imageView.bounds
    }
    func startLiveVideo(){
        session.sessionPreset = .hd1920x1080
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: .default))
        deviceOutput.connection(with: .video)?.videoOrientation = .portrait
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.videoGravity = .resizeAspectFill
        imageLayer.frame = imageView.bounds
        imageView.layer.addSublayer(imageLayer)
        session.startRunning()
        
    }

    func stopLiveVideo(){
        session.stopRunning()
        session = AVCaptureSession()
    }
}

extension RealTimeDetectionViewController : AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if(!isDetecting){
            isDetecting = true
     
            let onDeviceTextRecognizer = vision.onDeviceTextRecognizer()
            
            // Define the metadata for the image.
            let imageMetadata = VisionImageMetadata()
            let orientation = UIUtilities.imageOrientation(fromDevicePosition: .back)
            let visionOrientation = UIUtilities.visionImageOrientation(from: orientation)
            imageMetadata.orientation = visionOrientation
            
            // Initialize a VisionImage object with the given UIImage.
            let visionImage = VisionImage(buffer: sampleBuffer)
            visionImage.metadata = imageMetadata
            
            
            onDeviceTextRecognizer.process(visionImage) { text, error in
                
                guard error == nil , let text = text else {
                    self.resultLabel.textColor = UIColor.red
                    self.resultLabel.text = error?.localizedDescription
                    self.isDetecting = false
                    return
                }
                print(text.text)
                self.resultLabel.textColor = UIColor.white
                self.resultLabel.text = "\(text.text)\n"
                self.isDetecting = false

            }
        }
    }
}
