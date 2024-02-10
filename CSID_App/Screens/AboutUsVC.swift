//
//  AboutUsVC.swift
//  CSID_App
//
//  Created by Vince Muller on 1/21/24.
//

import UIKit

class AboutUsVC: UIViewController {
    
    let scrollView      = UIScrollView()
    let contentView     = UIView()
    let familyPic       = UIImageView()
    let bodyLabel       = UILabel()
    let contactUsButton = UIButton()
    
    var navBarHeight: CGFloat?
    var tabBarHeight: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarHeight = self.navigationController?.navigationBar.frame.size.height ?? 100
        tabBarHeight = self.tabBarController?.tabBar.frame.size.height ?? 84

        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureFamilyPic()
        configureBodyLabel()
        configureButton()
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints    = false
        contentView.translatesAutoresizingMaskIntoConstraints   = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight!),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalToConstant: view.frame.width),
            contentView.heightAnchor.constraint(equalToConstant: view.frame.height)
            
        ])
    }
    
    func configureFamilyPic() {
        view.addSubview(familyPic)
        
        familyPic.translatesAutoresizingMaskIntoConstraints = false
        
        familyPic.image                 = UIImage(named: "familyPic")
        familyPic.layer.cornerRadius    = 90
        familyPic.clipsToBounds         = true
        
        NSLayoutConstraint.activate([
            familyPic.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            familyPic.topAnchor.constraint(equalTo: contentView.topAnchor),
            familyPic.heightAnchor.constraint(equalToConstant: 180),
            familyPic.widthAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    func configureBodyLabel() {
        contentView.addSubview(bodyLabel)
        
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bodyLabel.font          = UIFont(name: "Baskerville-Italic", size: 18)
        bodyLabel.numberOfLines = 30
        bodyLabel.sizeToFit()
        bodyLabel.lineBreakMode = .byWordWrapping
        bodyLabel.text          = "Thank you so much for downloading our application. We hope you find it helpful! A little about us: Our daughter was diagnosed with CSIDs at 9 months old, and like many of you, we found it difficult to navigate foods, ingredients, starches, and sugars. We built this app so it's easier to see the following:\n\n     -Net carbs\n     -Total starches\n     -Total sugars\n     -Ingredients that contain sucrose\n     -Other sugars that aren't sucrose\n\nWe have many more ideas for this app, so we look forward to further enhancing the value it brings to you and your family. If you have any ideas, requests, or have found an issue please don’t hesitate to contact us."
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: familyPic.bottomAnchor, constant: 15),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
    
    func configureButton() {
        contentView.addSubview(contactUsButton)
        
        contactUsButton.translatesAutoresizingMaskIntoConstraints   = false
        contactUsButton.backgroundColor                             = .systemOrange
        contactUsButton.setTitle("Contact Us", for: .normal)
        contactUsButton.layer.cornerRadius                          = 10
        contactUsButton.addTarget(self, action: #selector(emailHyperlink), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            contactUsButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 20),
            contactUsButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contactUsButton.widthAnchor.constraint(equalToConstant: 200),
            contactUsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func emailHyperlink() {
        let email = "csidassist@gmail.com"
        if let url = URL(string: "mailto:\(email)?subject=Issue, Question, Feedback, or Request") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }

}
