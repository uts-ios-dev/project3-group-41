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
    }
  
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }

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

    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
  
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
  
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
  
    @IBAction func cameraButton(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto" {
            let previewVC = segue.destination as! PreviewViewController
            previewVC.predictedObject = PredictedObject(image: image!)
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
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
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // Or to rotate and lock
    AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Don't forget to reset when view is being removed
    AppUtility.lockOrientation(.all)
  }
}

extension MainViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            image = UIImage(data: imageData)
            performSegue(withIdentifier: "showPhoto", sender: nil)
        }
    }
}