//
//  cameraViewController.swift
//  MySampleApp
//
//  Created by David Wang on 11/30/16.
//  Testing commit
//

import UIKit
import AVFoundation

class cameraViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCaptureStillImageOutput()
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    
    @IBOutlet var imageview: UIView!
   

    @IBAction func takePhoto(sender: AnyObject) {
        if let videoConnection = sessionOutput.connectionWithMediaType(AVMediaTypeVideo){
            sessionOutput.captureStillImageAsynchronouslyFromConnection(videoConnection,
            completionHandler: {
            buffer, error in
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                UIImageWriteToSavedPhotosAlbum(UIImage(data: imageData)!, nil, nil, nil)
            })
        }
        
        }
    
    @IBAction func chooseExisting(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        //defines the source of images -- device's photo album, or camera
        imagePicker.sourceType = .SavedPhotosAlbum
        //checking if .Camera type is available -- it's not on iOS Simulator
        //so we don't use it there -- instead, we will see a list of photos in saved photos album
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            //if available, change source type to Camera
            imagePicker.sourceType = .Camera
            //camera can be either .Front or .Rear
            imagePicker.cameraDevice = .Front
            //do we want to capture photos or videos
            imagePicker.cameraCaptureMode = .Photo
        }}
    

     override func viewWillAppear(animated: Bool) {
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for device in devices {
            if device.position == AVCaptureDevicePosition.Back{
                do{
                    let input = try AVCaptureDeviceInput(device: device as! AVCaptureDevice)
                    if captureSession.canAddInput(input){
                        captureSession.addInput(input)
                        sessionOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
                        
                        if captureSession.canAddOutput(sessionOutput){
                            captureSession.addOutput(sessionOutput)
                            captureSession.startRunning()
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                            imageview.layer.addSublayer(previewLayer)
                            
                            previewLayer.position = CGPoint(x: self.imageview.frame.width/2, y: self.imageview.frame.height/2)
                            previewLayer.bounds = imageview.frame
                        }
                    }
                }
                catch{
                    print("Error")
                }
                
            }
        }}
        // Setup your camera here...
        
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
