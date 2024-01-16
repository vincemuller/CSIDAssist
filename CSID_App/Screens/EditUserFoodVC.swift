//
//  EditUserFoodVC.swift
//  CSID_App
//
//  Created by Vince Muller on 1/1/24.
//

import UIKit
import CloudKit

protocol EditUserFoodDelegate {
    func updateUserFoodDetails(foodDetails: YourFoodItem)
    func removeUserFood()
}

class EditUserFoodVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var yourFoodData: [YourFoodItem] = []
    var passedData: YourFoodItem!
    var passedVC: UserFoodDetails!
    let scrollView  = UIScrollView()
    let contentView = UIView()
    
    var delegate: EditUserFoodDelegate?
    
    let deleteIcon              = UIImageView()
    
    var config                  = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22))
    var addNewSymbol: UIImage?
    let tapGesture              = UITapGestureRecognizer()
    
    let fdLabel                 = NewFoodLabel(text: "Food Description")
    let fdTextField             = NewFoodTextField(placeholder: "Grilled salmon, Mcdonald's, apple...")
    
    let psLabel                 = NewFoodLabel(text: "Portion Size")
    let psTextField             = NewFoodTextField(placeholder: "1.0 slice, 25g, 1 cup...")
    
    let ingredientsLabel        = NewFoodLabel(text: "Ingredients")
    let ingredientsTextField    = MultiLineTextField()
    
    let nutritionLabel          = NewFoodLabel(text: "Nutrition Details")
    let totalCarbsTextField     = NewFoodTextField(placeholder: "Total carbs")
    let totalFiberTextField     = NewFoodTextField(placeholder: "Total fiber")
    let totalSugarsTextField    = NewFoodTextField(placeholder: "Total sugars")
    let addedSugarsTextField    = NewFoodTextField(placeholder: "Added sugars")
    
    let ctaButton               = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureScrollView()
        configureFd()
        configurePs()
        configureIngredients()
        configureNutrition()
        configureDeleteIcon()
        configureCTAButton()
        
        createDismissKeyboardTapGesture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewFoodVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewFoodVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints    = false
        contentView.translatesAutoresizingMaskIntoConstraints   = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
    
    func configureFd() {
        contentView.addSubview(fdLabel)
        contentView.addSubview(fdTextField)
        
        fdTextField.delegate = self
        fdTextField.text     = passedData.description
        
        NSLayoutConstraint.activate([
            fdLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            fdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            fdTextField.topAnchor.constraint(equalTo: fdLabel.bottomAnchor, constant: 10),
            fdTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fdTextField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.90),
            fdTextField.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    func configureDeleteIcon() {
        view.addSubview(deleteIcon)
        
        addNewSymbol           = UIImage(systemName: "trash", withConfiguration: config)
        deleteIcon.image       = addNewSymbol
        deleteIcon.tintColor   = .systemRed
        
        tapGesture.addTarget(self, action: #selector(handleDeleteTapped))
        tapGesture.isEnabled            = true
        tapGesture.numberOfTapsRequired = 1

        deleteIcon.translatesAutoresizingMaskIntoConstraints = false
        
        deleteIcon.isUserInteractionEnabled    = true
        deleteIcon.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            deleteIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            deleteIcon.trailingAnchor.constraint(equalTo: fdTextField.trailingAnchor)
        ])
    }
    
    func configurePs() {
        contentView.addSubview(psLabel)
        contentView.addSubview(psTextField)
        
        psTextField.delegate = self
        psTextField.text     = passedData.portionSize
        
        NSLayoutConstraint.activate([
            psLabel.topAnchor.constraint(equalTo: fdTextField.bottomAnchor, constant: 15),
            psLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            psTextField.topAnchor.constraint(equalTo: psLabel.bottomAnchor, constant: 10),
            psTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            psTextField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.90),
            psTextField.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    
    func configureIngredients() {
        contentView.addSubview(ingredientsLabel)
        contentView.addSubview(ingredientsTextField)
        
        ingredientsTextField.delegate = self
        ingredientsTextField.text     = passedData.ingredients
        
        NSLayoutConstraint.activate([
            ingredientsLabel.topAnchor.constraint(equalTo: psTextField.bottomAnchor, constant: 15),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            ingredientsTextField.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 10),
            ingredientsTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ingredientsTextField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.90),
            ingredientsTextField.heightAnchor.constraint(equalToConstant: 150)
            
        ])
    }
    
    func configureNutrition() {
        contentView.addSubview(nutritionLabel)
        contentView.addSubview(totalCarbsTextField)
        contentView.addSubview(totalFiberTextField)
        contentView.addSubview(totalSugarsTextField)
        contentView.addSubview(addedSugarsTextField)
        
        totalCarbsTextField.delegate    = self
        totalCarbsTextField.text        = passedData.totalCarbs.description
        
        totalFiberTextField.delegate    = self
        totalFiberTextField.text        = passedData.totalFiber.description
        
        totalSugarsTextField.delegate   = self
        totalSugarsTextField.text       = passedData.totalSugars.description
        
        addedSugarsTextField.delegate   = self
        addedSugarsTextField.text       = passedData.addedSugars.description
        
        totalCarbsTextField.keyboardType    = .numberPad
        totalFiberTextField.keyboardType    = .numberPad
        totalSugarsTextField.keyboardType   = .numberPad
        addedSugarsTextField.keyboardType   = .numberPad
        
        NSLayoutConstraint.activate([
            nutritionLabel.topAnchor.constraint(equalTo: ingredientsTextField.bottomAnchor, constant: 15),
            nutritionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            totalCarbsTextField.topAnchor.constraint(equalTo: nutritionLabel.bottomAnchor, constant: 10),
            totalCarbsTextField.leadingAnchor.constraint(equalTo: nutritionLabel.leadingAnchor),
            totalCarbsTextField.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.85)/2),
            totalCarbsTextField.heightAnchor.constraint(equalToConstant: 40),
            
            totalFiberTextField.topAnchor.constraint(equalTo: nutritionLabel.bottomAnchor, constant: 10),
            totalFiberTextField.trailingAnchor.constraint(equalTo: ingredientsTextField.trailingAnchor),
            totalFiberTextField.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.85)/2),
            totalFiberTextField.heightAnchor.constraint(equalToConstant: 40),
            
            totalSugarsTextField.topAnchor.constraint(equalTo: totalCarbsTextField.bottomAnchor, constant: 10),
            totalSugarsTextField.leadingAnchor.constraint(equalTo: nutritionLabel.leadingAnchor),
            totalSugarsTextField.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.85)/2),
            totalSugarsTextField.heightAnchor.constraint(equalToConstant: 40),
            
            addedSugarsTextField.topAnchor.constraint(equalTo: totalCarbsTextField.bottomAnchor, constant: 10),
            addedSugarsTextField.trailingAnchor.constraint(equalTo: ingredientsTextField.trailingAnchor),
            addedSugarsTextField.widthAnchor.constraint(equalToConstant: (view.frame.width * 0.85)/2),
            addedSugarsTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func configureCTAButton() {
        contentView.addSubview(ctaButton)
        
        ctaButton.translatesAutoresizingMaskIntoConstraints = false
        ctaButton.backgroundColor = .systemGreen
        ctaButton.setTitle("Update Food", for: .normal)
        ctaButton.layer.cornerRadius = 10
        ctaButton.addTarget(self, action: #selector(updateFood), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            ctaButton.topAnchor.constraint(equalTo: addedSugarsTextField.bottomAnchor, constant: 30),
            ctaButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ctaButton.widthAnchor.constraint(equalToConstant: 200),
            ctaButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func updateFood() {
        guard let description   = fdTextField.text, description != "" else {return}
        guard let portionSize   = psTextField.text, portionSize != "" else {return}
        let carbs               = Float(totalCarbsTextField.text!) ?? 0
        let fiber               = Float(totalFiberTextField.text!) ?? 0
        let sugars              = Float(totalSugarsTextField.text!) ?? 0
        let addedSugars         = Float(addedSugarsTextField.text!) ?? 0
        
        guard userID != "" else {
            self.presentGFAlertOnMain(title: CAAlertTitle.unableToUpdate.rawValue, message: CAAlertMessage.generaliCloudError.rawValue, buttonTitle: "Ok")
            resetFields()
            return
        }
        passedData = YourFoodItem(recordID: passedData.recordID, category: "Your Foods", description: description, portionSize: portionSize, ingredients: ingredientsTextField.text, totalCarbs: carbs, totalFiber: fiber, totalSugars: sugars, addedSugars: addedSugars)
        
        ckUserFoodRecordUpdate(userID: userID.description, category: "Your Food", description: description, ingredients: ingredientsTextField.text, portionSize: portionSize, totalCarbs: carbs, totalFiber: fiber, totalSugars: sugars, addedSugars: addedSugars)
        
        self.dismiss(animated: true) {
            self.delegate?.updateUserFoodDetails(foodDetails: self.passedData)
        }
    }
    
    func resetFields() {
        let contentInsets2 = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let contentInsets = CGPoint(x: 0, y: 0)
        
        // reset back the content inset to zero after keyboard is gone
        scrollView.setContentOffset(contentInsets, animated: true)
        scrollView.scrollIndicatorInsets = contentInsets2
        contentView.endEditing(true)
    }
    
    func ckUserFoodRecordUpdate(userID: String, category: String, description: String, ingredients: String, portionSize: String, totalCarbs: Float, totalFiber: Float, totalSugars: Float, addedSugars: Float) {
        let container = CKContainer.default()
        let database = container.privateCloudDatabase
        
        database.fetch(withRecordID: passedData.recordID) { record, error in
            if let record = record, error == nil {

                record.setValuesForKeys([
                    "userID": userID,
                    "category": category,
                    "description": description,
                    "ingredients": ingredients,
                    "portionSize": portionSize,
                    "totalCarbs": totalCarbs,
                    "totalFiber": totalFiber,
                    "totalSugars": totalSugars,
                    "addedSugars": addedSugars
                ]
                )
                database.save(record) { _, error in
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets2 = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let contentInsets = CGPoint(x: 0, y: 0)
        
        // reset back the content inset to zero after keyboard is gone
        scrollView.setContentOffset(contentInsets, animated: true)
        scrollView.scrollIndicatorInsets = contentInsets2
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(contentView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleDeleteTapped(_ gesture: UITapGestureRecognizer) {
        ckRecordDeletion(id: passedData.recordID)
        }
    
    func ckRecordDeletion(id: CKRecord.ID) {
        let container = CKContainer.default()
        let database = container.privateCloudDatabase
        
        database.delete(withRecordID: id) { id, error in
            if let error = error {
                self.presentGFAlertOnMain(title: "Unable to Remove Food", message: error.localizedDescription, buttonTitle: "Ok")
                return
            }
        }
        self.dismiss(animated: true) {
            self.delegate?.removeUserFood()
        }
    }
    
}

