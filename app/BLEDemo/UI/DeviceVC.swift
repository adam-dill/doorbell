import UIKit
import UserNotifications
import AVFoundation


class DeviceVC: UIViewController {
    private var audioPlayer = AVAudioPlayer()
    
    enum ViewState: Int {
        case disconnected
        case connected
        case ready
    }
    
    var device: BTDevice? {
        didSet {
            navigationItem.title = device?.name ?? "Device"
            device?.delegate = self
        }
    }
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var serialLabel: UILabel!
    
    var viewState: ViewState = .disconnected {
        didSet {
            switch viewState {
            case .disconnected:
                statusLabel.text = "Disconnected"
                disconnectButton.isEnabled = false
                serialLabel.isHidden = true
                valueLabel.isHidden = true
            case .connected:
                statusLabel.text = "Probing..."
                disconnectButton.isEnabled = true
                serialLabel.isHidden = true
                valueLabel.isHidden = true
            case .ready:
                statusLabel.text = "Ready"
                disconnectButton.isEnabled = true
                serialLabel.isHidden = false
                serialLabel.text = device?.serial ?? "reading..."
            }
        }
    }
    
    deinit {
        device?.disconnect()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewState = .disconnected
    }

    @IBAction func disconnectAction() {
        device?.disconnect()
    }
}

extension DeviceVC: BTDeviceDelegate {
    
    
    func deviceSerialChanged(value: String) {
        serialLabel.text = value
    }
    
    func deviceConnected() {
        viewState = .connected
    }
    
    func deviceDisconnected() {
        viewState = .disconnected
    }
    
    func deviceReady() {
        viewState = .ready
    }
    
    func deviceValueChanged(value: Bool) {
        let pathToSound = Bundle.main.path(forResource: "doorbell", ofType: "mp3")
        let url = URL(fileURLWithPath: pathToSound!)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
        } catch {
            print("Error playing audio")
        }
    }
    
}
