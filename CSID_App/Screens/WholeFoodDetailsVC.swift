//
//  WholeFoodDetailsVC.swift
//  CSID_App
//
//  Created by Vince Muller on 9/27/23.
//

import UIKit

protocol WholeFoodFavoriteArtefactsDelegate {
    func updateFavoritesCollectionView()
}

class WholeFoodDetailsVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var passedData:             USDAFoodDetails!
    var userFavs:               [USDAFoodDetails]?
    var sugarTypes:             String = ""
    var passedPointer:          OpaquePointer?
    var nutrientData:           WholeFoodNutrientData!
    var recordID:               String?
    let findSugars = SucroseCheck()
    
    var delegate: WholeFoodFavoriteArtefactsDelegate?
    var favoritesVC = FavoritesVC()
    
    var sugarIngr: [String] = []
    var otherIngr: [String] = []
    
    let titleLabel              = CALabel(size: 20, weight: .bold, numOfLines: 3)
    
    let favIcon                 = UIImageView()
    var favIconEnabled: Bool    = false
    var config                  = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22))
    var addNewSymbol: UIImage?
    let tapGesture              = UITapGestureRecognizer()
    
    let brandCategoryLabel      = CALabel(size: 12, weight: .semibold, numOfLines: 1)
    
    let portionContainer        = FoodDetailsContainer()
    let portionLabel            = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    
    let customPortionTextField  = CAPortionTextField(placeholder: "Custom Serving")
    
    let carbsContainer          = FoodDetailsContainer()
    let carbsSeparatorLine      = SeparatorLine()
    var totalCarbsData          = CALabel(size: 20, weight: .bold, numOfLines: 1)
    let totalCarbsLabel         = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    let netCarbsData            = CALabel(size: 20, weight: .bold, numOfLines: 1)
    let netCarbsLabel           = CALabel(size: 14, weight: .semibold, numOfLines: 1)

    let sugarStarchContainer    = FoodDetailsContainer()
    let totalSugarsCircle       = ChartCircleView(borderColor: UIColor.systemTeal.cgColor, backgroundColor: .clear)
    let totalStarchCircle       = ChartCircleView(borderColor: UIColor.systemOrange.cgColor, backgroundColor: .clear)
    let totalSugarsData         = CALabel(size: 20, weight: .bold, numOfLines: 1)
    let totalStarchData         = CALabel(size: 20, weight: .bold, numOfLines: 1)
    let totalSugarsLabel        = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    let totalStarchLabel        = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    
    let sugarDetailsContainer   = FoodDetailsContainer()
    let sucroseCircle           = ChartCircleView(borderColor: UIColor.systemBlue.cgColor, backgroundColor: .clear)
    let fructoseCircle          = ChartCircleView(borderColor: UIColor.systemRed.cgColor, backgroundColor: .clear)
    let glucoseCircle           = ChartCircleView(borderColor: UIColor.systemGreen.cgColor, backgroundColor: .clear)
    let lactoseCircle           = ChartCircleView(borderColor: UIColor.systemPurple.cgColor, backgroundColor: .clear)
    let maltoseCircle           = ChartCircleView(borderColor: UIColor.systemYellow.cgColor, backgroundColor: .clear)
    let sucroseLabel            = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    let fructoseLabel           = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    let glucoseLabel            = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    let lactoseLabel            = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    let maltoseLabel            = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    let sucroseData             = CALabel(size: 20, weight: .bold, numOfLines: 1)
    let fructoseData            = CALabel(size: 20, weight: .bold, numOfLines: 1)
    let glucoseData             = CALabel(size: 20, weight: .bold, numOfLines: 1)
    let lactoseData             = CALabel(size: 20, weight: .bold, numOfLines: 1)
    let maltoseData             = CALabel(size: 20, weight: .bold, numOfLines: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nutrientData = CADatabaseQueryHelper.queryDatabaseWholeFoodNutrientData(fdicID: passedData.fdicID, databasePointer: passedPointer)
        
        view.backgroundColor = .systemBackground
        
        let uniqueIngredients = findSugars.makingIngredientsUnique(productIngredients: passedData.ingredients.lowercased())
        sugarIngr = findSugars.getSucroseIngredients(productIngredients: uniqueIngredients)
        otherIngr = findSugars.getOtherSugarIngredients(productIngredients: uniqueIngredients)
        
        configureTitleLabel()
        configureTopContainers()
        configureTopLabels()
        configureCustomPortion()
        configureSugarStarchContainer()
        configureSugarStarchLabels()
        configureCarbsContainer()
        configureCarbsLabels()
        configureSugarDetailsContainer()
        configureSugarDetailsCircles()
        configureSugarDetailsLabels()
        configureSugarDetailsData()
        setupToolBar()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("whole food details vc!")
        getUserFavs()
        configureFavIcon()
    }
    
    func setupToolBar() {
        let bar = UIToolbar()
        let doneBtn     = UIBarButtonItem(title: "Done", style: .plain, target: self.view, action: #selector(view.endEditing))
        let flexSpace   = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        customPortionTextField.inputAccessoryView = bar
    }
    
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        view.addSubview(brandCategoryLabel)
        
        titleLabel.text = passedData.description.capitalized
        brandCategoryLabel.text = "Category: \(passedData.brandedFoodCategory.capitalized)"
        
        brandCategoryLabel.textColor = .systemGray2
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            brandCategoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            brandCategoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
            
        ])
    }
    
    func getUserFavs() {
        userFavs = PersistenceManager.getUserFavs()
    }
    
    func configureFavIcon() {
        view.addSubview(favIcon)
        let favCheck = userFavs?.contains(where: { $0.fdicID == passedData.fdicID })
        
        if favCheck==true {
            favIconEnabled=true
        }
        
        addNewSymbol        = (favIconEnabled==false ? UIImage(systemName: "star", withConfiguration: config) : UIImage(systemName: "star.fill", withConfiguration: config))
        favIcon.image       = addNewSymbol
        favIcon.tintColor   = .systemGreen
        
        tapGesture.addTarget(self, action: #selector(handleFavoriteTapped))
        tapGesture.isEnabled            = true
        tapGesture.numberOfTapsRequired = 1

        favIcon.translatesAutoresizingMaskIntoConstraints = false
        
        favIcon.isUserInteractionEnabled    = true
        favIcon.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            favIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favIcon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5)
        ])
        
        
    }
    func configureTopContainers() {
        view.addSubview(portionContainer)

        NSLayoutConstraint.activate([
            portionContainer.topAnchor.constraint(equalTo: brandCategoryLabel.bottomAnchor, constant: 10),
            portionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            portionContainer.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 245),
            portionContainer.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureTopLabels() {
        portionContainer.addSubview(portionLabel)
        portionLabel.text       = "Serving Size:  \(passedData.servingSize)\(passedData.servingSizeUnit)"
        
        NSLayoutConstraint.activate([
            portionLabel.centerYAnchor.constraint(equalTo: portionContainer.centerYAnchor),
            portionLabel.leadingAnchor.constraint(equalTo: portionContainer.leadingAnchor, constant: 10)
        ])
    }
    
    func configureCustomPortion() {
        view.addSubview(customPortionTextField)
        
        customPortionTextField.delegate = self
        
        customPortionTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            customPortionTextField.topAnchor.constraint(equalTo: portionContainer.topAnchor),
            customPortionTextField.leadingAnchor.constraint(equalTo: portionContainer.trailingAnchor, constant: 10),
            customPortionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            customPortionTextField.bottomAnchor.constraint(equalTo: portionContainer.bottomAnchor)
        ])
    }
    
    func configureSugarStarchContainer() {
        view.addSubview(sugarStarchContainer)
        
        NSLayoutConstraint.activate([
            sugarStarchContainer.topAnchor.constraint(equalTo: portionContainer.bottomAnchor, constant: 10),
            sugarStarchContainer.leadingAnchor.constraint(equalTo: portionContainer.leadingAnchor),
            sugarStarchContainer.trailingAnchor.constraint(equalTo: portionContainer.trailingAnchor),
            sugarStarchContainer.heightAnchor.constraint(equalToConstant: 125),
        ])
    }
    
    func configureSugarStarchLabels() {
        sugarStarchContainer.addSubview(totalSugarsCircle)
        sugarStarchContainer.addSubview(totalStarchCircle)
        totalStarchCircle.addSubview(totalStarchData)
        totalSugarsCircle.addSubview(totalSugarsData)
        sugarStarchContainer.addSubview(totalSugarsLabel)
        sugarStarchContainer.addSubview(totalStarchLabel)
        
        totalStarchCircle.layer.borderWidth   = 3
        totalSugarsCircle.layer.borderWidth   = 3
        
        totalSugarsData.text    = (nutrientData.totalSugars != "N/A" ? (round(Float(nutrientData.totalSugars)!*10)/10.0).description : "N/A")
        totalStarchData.text    = (nutrientData.totalStarches != "N/A" ? (round(Float(nutrientData.totalStarches)!*10)/10.0).description : "N/A")
        totalSugarsLabel.text   = "Total Sugars"
        totalStarchLabel.text   = "Total Starches"
        
        NSLayoutConstraint.activate([
            totalSugarsCircle.centerYAnchor.constraint(equalTo: sugarStarchContainer.centerYAnchor, constant: -10),
            totalSugarsCircle.centerXAnchor.constraint(equalTo: sugarStarchContainer.centerXAnchor, constant: -55),
            totalSugarsCircle.widthAnchor.constraint(equalToConstant: 80),
            totalSugarsCircle.heightAnchor.constraint(equalToConstant: 80),
            
            totalStarchCircle.centerYAnchor.constraint(equalTo: sugarStarchContainer.centerYAnchor, constant: -10),
            totalStarchCircle.centerXAnchor.constraint(equalTo: sugarStarchContainer.centerXAnchor, constant: 55),
            totalStarchCircle.widthAnchor.constraint(equalToConstant: 80),
            totalStarchCircle.heightAnchor.constraint(equalToConstant: 80),
            
            totalStarchData.centerXAnchor.constraint(equalTo: totalStarchCircle.centerXAnchor),
            totalStarchData.centerYAnchor.constraint(equalTo: totalStarchCircle.centerYAnchor),
            
            totalSugarsData.centerXAnchor.constraint(equalTo: totalSugarsCircle.centerXAnchor),
            totalSugarsData.centerYAnchor.constraint(equalTo: totalSugarsCircle.centerYAnchor),
            
            totalSugarsLabel.centerXAnchor.constraint(equalTo: totalSugarsData.centerXAnchor),
            totalSugarsLabel.bottomAnchor.constraint(equalTo: sugarStarchContainer.bottomAnchor, constant: -7),
            
            totalStarchLabel.centerXAnchor.constraint(equalTo: totalStarchData.centerXAnchor),
            totalStarchLabel.bottomAnchor.constraint(equalTo: totalSugarsLabel.bottomAnchor)
            
        ])
        
        totalStarchCircle.layer.cornerRadius  = 40
        totalSugarsCircle.layer.cornerRadius  = 40
    }
    
    func configureCarbsContainer() {
        view.addSubview(carbsContainer)
        carbsContainer.addSubview(carbsSeparatorLine)
        
        NSLayoutConstraint.activate([
            carbsContainer.topAnchor.constraint(equalTo: sugarStarchContainer.topAnchor),
            carbsContainer.leadingAnchor.constraint(equalTo: sugarStarchContainer.trailingAnchor, constant: 10),
            carbsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            carbsContainer.heightAnchor.constraint(equalToConstant: 125),
            
            carbsSeparatorLine.centerYAnchor.constraint(equalTo: carbsContainer.centerYAnchor),
            carbsSeparatorLine.leadingAnchor.constraint(equalTo: carbsContainer.leadingAnchor, constant: 10),
            carbsSeparatorLine.trailingAnchor.constraint(equalTo: carbsContainer.trailingAnchor, constant: -10),
            carbsSeparatorLine.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    func configureCarbsLabels() {
        carbsContainer.addSubview(totalCarbsData)
        carbsContainer.addSubview(netCarbsData)
        carbsContainer.addSubview(totalCarbsLabel)
        carbsContainer.addSubview(netCarbsLabel)

        totalCarbsData.text             = (nutrientData.carbs != "N/A" ? (round(Float(nutrientData.carbs)!*10)/10.0).description : "N/A")
        totalCarbsData.textAlignment    = .center
        totalCarbsLabel.text            = "Total Carbs"
        totalCarbsLabel.textAlignment   = .center
        
        netCarbsData.text               = (nutrientData.carbs != "N/A" ? (round(Float(nutrientData.carbs)!*10)/10.0).description : "N/A")
        netCarbsData.textAlignment      = .center
        netCarbsLabel.text              = "Net Carbs"
        netCarbsLabel.textAlignment     = .center
        
        NSLayoutConstraint.activate([
            totalCarbsData.centerXAnchor.constraint(equalTo: carbsContainer.centerXAnchor),
            totalCarbsData.centerYAnchor.constraint(equalTo: carbsContainer.topAnchor, constant: 20),
            totalCarbsLabel.centerXAnchor.constraint(equalTo: carbsContainer.centerXAnchor),
            totalCarbsLabel.topAnchor.constraint(equalTo: totalCarbsData.bottomAnchor, constant: 3),
            
            netCarbsData.centerXAnchor.constraint(equalTo: carbsContainer.centerXAnchor),
            netCarbsData.centerYAnchor.constraint(equalTo: carbsContainer.bottomAnchor, constant: -40),
            netCarbsLabel.centerXAnchor.constraint(equalTo: carbsContainer.centerXAnchor),
            netCarbsLabel.topAnchor.constraint(equalTo: netCarbsData.bottomAnchor, constant: 3),
        ])
    }
    
    func configureSugarDetailsContainer() {
        view.addSubview(sugarDetailsContainer)
        
        NSLayoutConstraint.activate([
            sugarDetailsContainer.topAnchor.constraint(equalTo: sugarStarchContainer.bottomAnchor, constant: 10),
            sugarDetailsContainer.leadingAnchor.constraint(equalTo: sugarStarchContainer.leadingAnchor),
            sugarDetailsContainer.trailingAnchor.constraint(equalTo: carbsContainer.trailingAnchor),
            sugarDetailsContainer.heightAnchor.constraint(equalToConstant: 260)
        ])
    }
    
    func configureSugarDetailsCircles() {
        sugarDetailsContainer.addSubview(sucroseCircle)
        sugarDetailsContainer.addSubview(fructoseCircle)
        sugarDetailsContainer.addSubview(glucoseCircle)
        sugarDetailsContainer.addSubview(lactoseCircle)
        sugarDetailsContainer.addSubview(maltoseCircle)
        
        sucroseCircle.layer.borderWidth   = 3
        fructoseCircle.layer.borderWidth  = 3
        glucoseCircle.layer.borderWidth   = 3
        lactoseCircle.layer.borderWidth   = 3
        maltoseCircle.layer.borderWidth   = 3
        
        NSLayoutConstraint.activate([
            sucroseCircle.topAnchor.constraint(equalTo: sugarDetailsContainer.topAnchor, constant: 20),
            fructoseCircle.topAnchor.constraint(equalTo: sugarDetailsContainer.topAnchor, constant: 20),
            glucoseCircle.topAnchor.constraint(equalTo: sugarDetailsContainer.topAnchor, constant: 20),
            lactoseCircle.topAnchor.constraint(equalTo: sugarDetailsContainer.topAnchor, constant: 130),
            maltoseCircle.topAnchor.constraint(equalTo: sugarDetailsContainer.topAnchor, constant: 130),
            
            fructoseCircle.centerXAnchor.constraint(equalTo: sugarDetailsContainer.centerXAnchor),
            sucroseCircle.centerXAnchor.constraint(equalTo: sugarDetailsContainer.centerXAnchor, constant: -(view.frame.size.width - 20) / 3),
            glucoseCircle.centerXAnchor.constraint(equalTo: sugarDetailsContainer.centerXAnchor, constant: (view.frame.size.width - 20) / 3),
            lactoseCircle.centerXAnchor.constraint(equalTo: sugarDetailsContainer.centerXAnchor, constant: -((view.frame.size.width - 20) / 6)),
            maltoseCircle.centerXAnchor.constraint(equalTo: sugarDetailsContainer.centerXAnchor, constant: ((view.frame.size.width - 20) / 6)),
            
            sucroseCircle.widthAnchor.constraint(equalToConstant: 80),
            sucroseCircle.heightAnchor.constraint(equalToConstant: 80),
            fructoseCircle.widthAnchor.constraint(equalToConstant: 80),
            fructoseCircle.heightAnchor.constraint(equalToConstant: 80),
            glucoseCircle.widthAnchor.constraint(equalToConstant: 80),
            glucoseCircle.heightAnchor.constraint(equalToConstant: 80),
            lactoseCircle.widthAnchor.constraint(equalToConstant: 80),
            lactoseCircle.heightAnchor.constraint(equalToConstant: 80),
            maltoseCircle.widthAnchor.constraint(equalToConstant: 80),
            maltoseCircle.heightAnchor.constraint(equalToConstant: 80),
       ])
        
        sucroseCircle.layer.cornerRadius  = 40
        fructoseCircle.layer.cornerRadius = 40
        glucoseCircle.layer.cornerRadius  = 40
        lactoseCircle.layer.cornerRadius  = 40
        maltoseCircle.layer.cornerRadius  = 40
    }
    
    func configureSugarDetailsLabels() {
        sugarDetailsContainer.addSubview(sucroseLabel)
        sugarDetailsContainer.addSubview(fructoseLabel)
        sugarDetailsContainer.addSubview(glucoseLabel)
        sugarDetailsContainer.addSubview(lactoseLabel)
        sugarDetailsContainer.addSubview(maltoseLabel)
        
        sucroseLabel.text   = "Sucrose"
        fructoseLabel.text  = "Fructose"
        glucoseLabel.text   = "Glucose"
        lactoseLabel.text   = "Lactose"
        maltoseLabel.text   = "Maltose"
        
        NSLayoutConstraint.activate([
            sucroseLabel.centerXAnchor.constraint(equalTo: sucroseCircle.centerXAnchor),
            sucroseLabel.topAnchor.constraint(equalTo: sucroseCircle.bottomAnchor, constant: 7),
            
            fructoseLabel.centerXAnchor.constraint(equalTo: fructoseCircle.centerXAnchor),
            fructoseLabel.topAnchor.constraint(equalTo: fructoseCircle.bottomAnchor, constant: 7),
            
            glucoseLabel.centerXAnchor.constraint(equalTo: glucoseCircle.centerXAnchor),
            glucoseLabel.topAnchor.constraint(equalTo: glucoseCircle.bottomAnchor, constant: 7),
            
            lactoseLabel.centerXAnchor.constraint(equalTo: lactoseCircle.centerXAnchor),
            lactoseLabel.topAnchor.constraint(equalTo: lactoseCircle.bottomAnchor, constant: 7),
            
            maltoseLabel.centerXAnchor.constraint(equalTo: maltoseCircle.centerXAnchor),
            maltoseLabel.topAnchor.constraint(equalTo: maltoseCircle.bottomAnchor, constant: 7),
        ])
    }
    
    func configureSugarDetailsData() {
        sucroseCircle.addSubview(sucroseData)
        fructoseCircle.addSubview(fructoseData)
        glucoseCircle.addSubview(glucoseData)
        lactoseCircle.addSubview(lactoseData)
        maltoseCircle.addSubview(maltoseData)
        
        sucroseData.text   = "\(nutrientData.sucrose)g"
        fructoseData.text  = "\(nutrientData.fructose)g"
        glucoseData.text   = "\(nutrientData.glucose)g"
        lactoseData.text   = "\(nutrientData.lactose)g"
        maltoseData.text   = "\(nutrientData.maltose)g"
        
        NSLayoutConstraint.activate([
            sucroseData.centerXAnchor.constraint(equalTo: sucroseCircle.centerXAnchor),
            sucroseData.centerYAnchor.constraint(equalTo: sucroseCircle.centerYAnchor),
            
            fructoseData.centerXAnchor.constraint(equalTo: fructoseCircle.centerXAnchor),
            fructoseData.centerYAnchor.constraint(equalTo: fructoseCircle.centerYAnchor),
            
            glucoseData.centerXAnchor.constraint(equalTo: glucoseCircle.centerXAnchor),
            glucoseData.centerYAnchor.constraint(equalTo: glucoseCircle.centerYAnchor),
            
            lactoseData.centerXAnchor.constraint(equalTo: lactoseCircle.centerXAnchor),
            lactoseData.centerYAnchor.constraint(equalTo: lactoseCircle.centerYAnchor),
            
            maltoseData.centerXAnchor.constraint(equalTo: maltoseCircle.centerXAnchor),
            maltoseData.centerYAnchor.constraint(equalTo: maltoseCircle.centerYAnchor),
        ])
    }
    
    @objc func handleFavoriteTapped(_ gesture: UITapGestureRecognizer) {
        if favIconEnabled == false {
            addNewSymbol        = UIImage(systemName: "star.fill", withConfiguration: config)
            favIcon.image       = addNewSymbol
            favIconEnabled      = true
            PersistenceManager.updateWith(favorite: passedData, actionType: .add) { [weak self] error in
                guard let self = self else {return }
        
                guard let error = error else {
                    self.presentGFAlertOnMain(title: "Food Favorited", message: "You have successfully added \(passedData.description.capitalized) to your favorites", buttonTitle: "Ok")
                    return
                }
                self.presentGFAlertOnMain(title: "Something Went Wrong!", message: "Your food did not favorite, please try again!", buttonTitle: "Ok")
            }
        } else {
            addNewSymbol        = UIImage(systemName: "star", withConfiguration: config)
            favIcon.image       = addNewSymbol
            favIconEnabled      = false
            PersistenceManager.updateWith(favorite: passedData, actionType: .remove) { [weak self] error in
                guard let self = self else {return }
        
                guard let error = error else {
                    self.presentGFAlertOnMain(title: "Food Removed!", message: "You have successfully removed \(passedData.description.capitalized) from your favorites", buttonTitle: "Ok")
                    return
                }
                self.presentGFAlertOnMain(title: "Something Went Wrong!", message: "Your food did not favorite, please try again!", buttonTitle: "Ok")
            }
            delegate?.updateFavoritesCollectionView()
        }
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing))
        carbsContainer.addGestureRecognizer(tap)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let customPortionText = customPortionTextField.text, customPortionText.count != 0 else {
            totalCarbsData.text     = (nutrientData.carbs != "N/A" ? (round(Float(nutrientData.carbs)!*10)/10.0).description : "N/A")
            netCarbsData.text       = (nutrientData.carbs != "N/A" ? (round(Float(nutrientData.carbs)!*10)/10.0).description : "N/A")
            totalStarchData.text    = (nutrientData.totalStarches != "N/A" ? (round(Float(nutrientData.totalStarches)!*10)/10.0).description : "N/A")
            totalSugarsData.text    = (nutrientData.totalSugars != "N/A" ? (round(Float(nutrientData.totalSugars)!*10)/10.0).description : "N/A")
            return
        }
        
        let customPortion: Float   = Float(customPortionTextField.text ?? "1") ?? 1
        let adjustor:      Float   = customPortion/Float(passedData.servingSize)
        
        if nutrientData.carbs != "N/A" {
            let adjustedCarbs:  Float   = round(((Float(nutrientData.carbs)!*adjustor)*10)/10.0)
            totalCarbsData.text = adjustedCarbs.description
        }
        
        if nutrientData.carbs != "N/A" {
            let adjustedNetCarbs: Float = round(((Float(nutrientData.carbs)!*adjustor)*10)/10.0)
            netCarbsData.text   = adjustedNetCarbs.description
        }
            
        if nutrientData.totalStarches != "N/A" {
            let adjustedTotalStarches: Float = round(((Float(nutrientData.totalStarches)!*adjustor)*10)/10.0)
            totalStarchData.text    = adjustedTotalStarches.description
        }
        
        if nutrientData.totalSugars != "N/A" {
            let adjustedTotalSugars: Float = round(((Float(nutrientData.totalSugars)!*adjustor)*10)/10.0)
            totalSugarsData.text    = adjustedTotalSugars.description
        }

            
        }
    
}
