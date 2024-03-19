//
//  AddNewFoodVC.swift
//  CSID_App
//
//  Created by Vince Muller on 9/14/23.
//

import UIKit
import CloudKit

class AddNewFoodVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var yourFoodData: [UserFoodItem] = []
    let scrollView  = UIScrollView()
    let contentView = UIView()
    
    let fdLabel                 = NewFoodLabel(text: "Food Description")
    let fdTextField             = NewFoodTextField(placeholder: "Grilled salmon, Mcdonald's, apple...")
    
    let psLabel                 = NewFoodLabel(text: "Portion Size")
    let psTextField             = NewFoodTextField(placeholder: "1.0 slice, 25g, 1 cup...")
    
    let ingredientsLabel        = NewFoodLabel(text: "Ingredients/Recipe")
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
        configureCTAButton()
        
        createDismissKeyboardTapGesture()

        NotificationCenter.default.addObserver(self, selector: #selector(AddNewFoodVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(AddNewFoodVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserFoods()
    }
    
    func getUserFoods() {
        PersistenceManager.retrieveUserFoods { result in
            switch result {
            case .success(let userFoods):
                print("user foods: \(String(describing: userFoods))")
            case .failure(let error):
                print(error)
                return
            }
        }
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
        
        NSLayoutConstraint.activate([
            fdLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            fdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            fdTextField.topAnchor.constraint(equalTo: fdLabel.bottomAnchor, constant: 10),
            fdTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fdTextField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.90),
            fdTextField.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
    
    func configurePs() {
        contentView.addSubview(psLabel)
        contentView.addSubview(psTextField)
        
        psTextField.delegate = self
        
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
        
        NSLayoutConstraint.activate([
            ingredientsLabel.topAnchor.constraint(equalTo: psTextField.bottomAnchor, constant: 15),
            ingredientsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            
            ingredientsTextField.topAnchor.constraint(equalTo: ingredientsLabel.bottomAnchor, constant: 10),
            ingredientsTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ingredientsTextField.widthAnchor.constraint(equalToConstant: view.frame.width * 0.90),
            ingredientsTextField.heightAnchor.constraint(equalToConstant: 120)
            
        ])
    }
    
    func configureNutrition() {
        contentView.addSubview(nutritionLabel)
        contentView.addSubview(totalCarbsTextField)
        contentView.addSubview(totalFiberTextField)
        contentView.addSubview(totalSugarsTextField)
        contentView.addSubview(addedSugarsTextField)
            
        totalCarbsTextField.delegate    = self
        totalFiberTextField.delegate    = self
        totalSugarsTextField.delegate   = self
        addedSugarsTextField.delegate   = self
        
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
        ctaButton.setTitle("Add New Food", for: .normal)
        ctaButton.layer.cornerRadius = 10
        ctaButton.addTarget(self, action: #selector(createNewFood), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            ctaButton.topAnchor.constraint(equalTo: addedSugarsTextField.bottomAnchor, constant: 30),
            ctaButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            ctaButton.widthAnchor.constraint(equalToConstant: 200),
            ctaButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func createNewFood() {
        guard let description   = fdTextField.text, description != "" else {return}
        guard let portionSize   = psTextField.text, portionSize != "" else {return}
        let carbs               = Float(totalCarbsTextField.text!) ?? 0
        let fiber               = Float(totalFiberTextField.text!) ?? 0
        let sugars              = Float(totalSugarsTextField.text!) ?? 0
        let addedSugars         = Float(addedSugarsTextField.text!) ?? 0
        
        let newUserFood = UserFoodItem(category: "Your Foods", description: description, portionSize: portionSize, ingredients: ingredientsTextField.text, totalCarbs: carbs, totalFiber: fiber, totalSugars: sugars, addedSugars: addedSugars)
        PersistenceManager.updateUserFoodWith(userFood: newUserFood, actionType: .create) { [weak self] error in
            guard let self = self else {return }
    
            guard let error = error else {
                self.presentGFAlertOnMain(title: "Food Created!", message: "You have successfully created and added \(newUserFood.description) to your foods", buttonTitle: "Ok")
                self.tabBarController?.selectedIndex = 0
                return
            }
            self.presentGFAlertOnMain(title: "\(error)", message: "Your food did not get added, please try again!", buttonTitle: "Ok")
        }
        resetFields()
    }
    
    func resetFields() {
        fdTextField.text            = ""
        psTextField.text            = ""
        ingredientsTextField.text   = ""
        totalCarbsTextField.text    = ""
        totalFiberTextField.text    = ""
        totalSugarsTextField.text   = ""
        addedSugarsTextField.text   = ""
        
        let contentInsets2 = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let contentInsets = CGPoint(x: 0, y: -100)
        
        // reset back the content inset to zero after keyboard is gone
        scrollView.setContentOffset(contentInsets, animated: true)
        scrollView.scrollIndicatorInsets = contentInsets2
        contentView.endEditing(true)
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
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
          // if keyboard size is not available for some reason, dont do anything
          return
        }
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -keyboardSize.height, right: 0.0)
        
        
        // reset back the content inset to zero after keyboard is gone
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
      }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(contentView.endEditing))
        view.addGestureRecognizer(tap)
    }

}
