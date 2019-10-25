//
//  ViewController.swift


import UIKit
import CoreNFC

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate, UITextFieldDelegate{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var messageLabel: UILabel!   //NFC label
    @IBOutlet weak var scanButton: UIButton!
    var nfcSession: NFCNDEFReaderSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.scanPressed(scanButton)    //Start the nfc session as soon as the view controller loads
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //NFC scan related
    @IBAction func scanPressed(_ sender: Any) {
        if NFCNDEFReaderSession.readingAvailable {
            print("NFCNDEFReaderSession readingAvailable")
        }

        nfcSession = NFCNDEFReaderSession.init(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        nfcSession?.alertMessage = "You can hold you NFC-tag to the back-top of your iPhone"
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("The session was invalidated: \(error)")
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        print("New NFC Tag detected:")
        
        var result = ""
        for payload in messages[0].records {
            result += String.init(data: payload.payload.advanced(by: 3), encoding: .utf8)!
        }
        
        for message in messages {
            for record in message.records {
                print("Type name format: \(record.typeNameFormat)")
                print("Payload: \(record.payload)")
                print("Type: \(record.type)")
                print("Identifier: \(record.identifier)")
                let backToString = String(data: record.identifier, encoding: String.Encoding.utf8)!
                print(backToString)
            }
        }
        
        DispatchQueue.main.sync {
            print(result)
            self.messageLabel.text = result
            self.messageLabel.textColor = UIColor.black
        }
    }
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        print("The session became active")
    }
    
}

