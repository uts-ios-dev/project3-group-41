import UIKit
import AVFoundation

class MainViewController: UIViewController {
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
  
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var image: UIImage?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setFPS()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        navigationController?.isNavigationBarHidden = true
    }
    
    // https://www.youtube.com/watch?v=7TqXrMnfJy8&ab_channel=Zero2Launch
    // Following 5 functions is to setup a custom camera view
    // #1: Set up capture session
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    // #2: Set the device to take photo
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices

        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
    
    // #3: Set up input device and output photo format
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
                captureSession.addInput(captureDeviceInput)
                photoOutput = AVCapturePhotoOutput()
                photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
                captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    // #4: Set up a layer for photo preview
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    // #5: Run the capture session
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    // https://stackoverflow.com/questions/49199595/set-avcapture-to-60-fps-ios-swift-4
    // Set FPS of the camera to 60 FPS
    func setFPS() {
        captureSession = AVCaptureSession()
        for vFormat in backCamera!.formats {
            var ranges = vFormat.videoSupportedFrameRateRanges as [AVFrameRateRange]
            let frameRates = ranges[0]
            if frameRates.maxFrameRate > 30 {
                do {
                    try backCamera!.lockForConfiguration()
                    backCamera!.activeFormat = vFormat
                    backCamera!.activeVideoMinFrameDuration = CMTimeMake(1, 60)
                    backCamera!.activeVideoMaxFrameDuration = CMTimeMake(1, 60)
                    backCamera!.unlockForConfiguration()
                } catch {
                    print("Error on frame rate")
                }
            }
        }
    }
    
    // Action of camera button
    @IBAction func cameraButton(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    // Transfer predictedObject to PreviewViewController via segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto" {
            let previewVC = segue.destination as! PreviewViewController
            previewVC.predictedObject = PredictedObject(image: image!)
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Hide status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // https://stackoverflow.com/questions/28938660/how-to-lock-orientation-of-one-view-controller-to-portrait-mode-only-in-swift
    // App Utility to lock screen orientation
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
    // Force orientation to portrait
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }

    @IBAction func unwindToMainVC(segue: UIStoryboardSegue) { }
}

// Transfer taken photo to PreviewViewController
extension MainViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "showPhoto", sender: nil)
        }
    }
}
