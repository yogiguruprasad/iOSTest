//
//  FriendDetailsViewController.swift
//  iOSTest
//
//  Created by Diksha on 11/09/21.
//

import UIKit
import Messages
import MessageUI

class FriendDetailsViewController: UIViewController {
    @IBOutlet weak var potraitImage:UIImageView!
    @IBOutlet weak var fullNameLabel:UILabel!
    @IBOutlet weak var addressLabel:UILabel!
    @IBOutlet weak var stateLabel:UILabel!
    @IBOutlet weak var emailLabel:UILabel!
    @IBOutlet weak var phoneLabel:UILabel!
    var friend:Friend?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        updateUI()
        emailLabel.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.openEMailClient))
        emailLabel.addGestureRecognizer(gesture)
    }
    @objc func openEMailClient() {
        let recipientEmail = friend?.email ?? ""
                    let subject = "Multi client email support"
                    let body = "This code supports sending email via multiple different email apps on iOS! :)"
                    
                    // Show default mail composer
                    if MFMailComposeViewController.canSendMail() {
                        let mail = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        mail.setToRecipients([recipientEmail])
                        mail.setSubject(subject)
                        mail.setMessageBody(body, isHTML: false)
                        
                        present(mail, animated: true)
                    
                    // Show third party email composer if default Mail app is not present
                    } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
                        UIApplication.shared.open(emailUrl)
                    }
    }
    func updateUI() {
        self.potraitImage.downloaded(from: friend?.picture?.large ?? "")
        self.fullNameLabel.text = friend?.name?.fullName
        self.addressLabel.text = (friend?.location?.street?.number?.description ?? "") + (friend?.location?.street?.name ?? "")
        self.emailLabel.text = friend?.email
        self.phoneLabel.text = friend?.cell
        self.stateLabel.text = friend!.location!.city!  + "," + friend!.location!.state! + "," + friend!.location!.country!
    }
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
                let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                
                let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
                let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
                let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
                let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
                let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
                
                if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
                    return gmailUrl
                } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
                    return outlookUrl
                } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
                    return yahooMail
                } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
                    return sparkUrl
                }
                
                return defaultUrl
            }
}
extension FriendDetailsViewController:MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
                controller.dismiss(animated: true)
            }
}
