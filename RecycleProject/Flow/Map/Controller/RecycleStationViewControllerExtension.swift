//
//	RecycleStationViewControllerExtension.swift
// 	RecycleProject
//

import UIKit
import MessageUI
import MapKit
import CoreData

//MARK: - Work with Collection View
extension RecycleStationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = currentRecycleStation.recycleCodes.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MaterialCell", for: indexPath) as? MaterialCollectionViewCell else { return UICollectionViewCell() }
        cell.recycleImageView.image = #imageLiteral(resourceName: "recycleSymbol")
        
        let recycleCode = currentRecycleStation.recycleCodes[indexPath.row]
        if recycleCode > 100 {
            FirebaseService.getSpecialMaterialName(code: recycleCode) { name in
                cell.materialNameLabel.text = name
            }
        } else {
            cell.materialNameLabel.text = getMateialTypeName(with: recycleCode)
        }
        
        switch recycleCode {
        case 0:
            cell.recycleCodeLabel.text = nil
        case ..<10:
            cell.recycleCodeLabel.text = "0\(recycleCode)"
        case 100...:
            cell.recycleCodeLabel.text = nil
        default:
            cell.recycleCodeLabel.text = String(recycleCode)
        }
        
        return cell
    }
    
    private func getMateialTypeName(with code: Int) -> String? {
        let fetchRequest: NSFetchRequest<Material> = Material.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "code == %@", NSNumber(value: code))
        do {
            let result = try CoreDataService.shared.context.fetch(fetchRequest)
            return result.first?.shortName
        } catch {
            return nil
        }
    }
}

//MARK: - Work with MapKit
extension RecycleStationViewController {
    func createRoute(to coordinate: CLLocationCoordinate2D, named name: String) {
        
        let yandexMapsURL = URL(string: "yandexmaps://build_route_on_map/?lat_from=XXXXX&lon_from=XXXXX&lat_to=\(coordinate.latitude)&lon_to=\(coordinate.longitude)")
        
        if let url = yandexMapsURL, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.name = name
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
}

//MARK: - Work with MessageUI
extension RecycleStationViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        var recipientEmail = ""
        FirebaseService.getSupportingEmail { [weak self] result in
            guard let self = self,
                let email = result else { return }
            recipientEmail = email
            
            var subject = "Обращение в службу поддержки"
            if let region = UserDefaults.standard.getRegion()?.name {
                subject += ": \(region)"
            }
            let body = "Проблема с пунктом приёма по адресу \(self.currentStationAddress):"
            
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([recipientEmail])
                mail.setSubject(subject)
                mail.setMessageBody(body, isHTML: false)
                
                self.present(mail, animated: true)
                
            } else if let emailUrl = self.createEmailUrl(to: recipientEmail, subject: subject, body: body) {
                UIApplication.shared.open(emailUrl)
            }
        }
    }
    
    func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
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
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
