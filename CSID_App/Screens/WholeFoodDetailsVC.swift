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
    var nutrientData:           WholeFoodNutrientData!
    
    private let viewModel = WholeFoodDetailsViewModel()
    
    var delegate: WholeFoodFavoriteArtefactsDelegate?
    private var favoritesVC = FavoritesVC()
    
    private let titleLabel              = CALabel(size: 20, weight: .bold, numOfLines: 3)
    
    private var favCheck: Bool          = false
    private let favIcon                 = FavoriteIconImageView(frame: .zero)
    
    private let brandCategoryLabel      = CALabel(size: 12, weight: .semibold, numOfLines: 1)
    
    private let portionContainer        = FoodDetailsContainer()
    private let portionLabel            = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    
    private let customPortionTextField  = CAPortionTextField(placeholder: "Custom Serving")
    
    private let carbsContainer          = FoodDetailsContainer()
    private let carbsSeparatorLine      = SeparatorLine()
    private var totalCarbsData          = CALabel(size: 20, weight: .bold, numOfLines: 1)
    private let totalCarbsLabel         = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    private let netCarbsData            = CALabel(size: 20, weight: .bold, numOfLines: 1)
    private let netCarbsLabel           = CALabel(size: 14, weight: .semibold, numOfLines: 1)

    private let sugarStarchContainer    = FoodDetailsContainer()
    private let totalSugarsCircle       = ChartCircleView(borderColor: UIColor.systemTeal.cgColor, backgroundColor: .clear)
    private let totalStarchCircle       = ChartCircleView(borderColor: UIColor.systemOrange.cgColor, backgroundColor: .clear)
    private let totalSugarsData         = CALabel(size: 20, weight: .bold, numOfLines: 1)
    private let totalStarchData         = CALabel(size: 20, weight: .bold, numOfLines: 1)
    private let totalSugarsLabel        = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    private let totalStarchLabel        = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    
    private let sugarDetailsContainer   = FoodDetailsContainer()
    private let sucroseCircle           = ChartCircleView(borderColor: UIColor.systemBlue.cgColor, backgroundColor: .clear)
    private let fructoseCircle          = ChartCircleView(borderColor: UIColor.systemRed.cgColor, backgroundColor: .clear)
    private let glucoseCircle           = ChartCircleView(borderColor: UIColor.systemGreen.cgColor, backgroundColor: .clear)
    private let lactoseCircle           = ChartCircleView(borderColor: UIColor.systemPurple.cgColor, backgroundColor: .clear)
    private let maltoseCircle           = ChartCircleView(borderColor: UIColor.systemYellow.cgColor, backgroundColor: .clear)
    private let sucroseLabel            = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    private let fructoseLabel           = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    private let glucoseLabel            = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    private let lactoseLabel            = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    private let maltoseLabel            = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    private let sucroseData             = CALabel(size: 20, weight: .bold, numOfLines: 1)
    private let fructoseData            = CALabel(size: 20, weight: .bold, numOfLines: 1)
    private let glucoseData             = CALabel(size: 20, weight: .bold, numOfLines: 1)
    private let lactoseData             = CALabel(size: 20, weight: .bold, numOfLines: 1)
    private let maltoseData             = CALabel(size: 20, weight: .bold, numOfLines: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        getNutrientData()
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
        configureFavIcon()
    }
    
    private func getNutrientData() {
        nutrientData = viewModel.getNutrientData(fdicID: passedData.fdicID)
    }
    
    private func setupToolBar() {
        let bar = UIToolbar()
        let doneBtn     = UIBarButtonItem(title: "Done", style: .plain, target: self.view, action: #selector(view.endEditing))
        let flexSpace   = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        customPortionTextField.inputAccessoryView = bar
    }
    
    private func configureTitleLabel() {
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

    
    private func configureFavIcon() {
        view.addSubview(favIcon)
        
        favCheck = viewModel.userFavoriteCheck(fdicID: passedData.fdicID)
        
        if favCheck==true {
            favIcon.updateFavs(favIconEnabled: favCheck)
        } else {
            favIcon.updateFavs(favIconEnabled: favCheck)
        }
        
        favIcon.tapGesture.addTarget(self, action: #selector(handleFavoriteTapped))
        favIcon.addGestureRecognizer(favIcon.tapGesture)
        
        NSLayoutConstraint.activate([
            favIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favIcon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5)
        ])
    }
    
    private func configureTopContainers() {
        view.addSubview(portionContainer)

        NSLayoutConstraint.activate([
            portionContainer.topAnchor.constraint(equalTo: brandCategoryLabel.bottomAnchor, constant: 10),
            portionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            portionContainer.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 245),
            portionContainer.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureTopLabels() {
        portionContainer.addSubview(portionLabel)
        portionLabel.text       = "Serving Size:  \(passedData.servingSize)\(passedData.servingSizeUnit)"
        
        NSLayoutConstraint.activate([
            portionLabel.centerYAnchor.constraint(equalTo: portionContainer.centerYAnchor),
            portionLabel.leadingAnchor.constraint(equalTo: portionContainer.leadingAnchor, constant: 10)
        ])
    }
    
    private func configureCustomPortion() {
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
    
    private func configureSugarStarchContainer() {
        view.addSubview(sugarStarchContainer)
        
        NSLayoutConstraint.activate([
            sugarStarchContainer.topAnchor.constraint(equalTo: portionContainer.bottomAnchor, constant: 10),
            sugarStarchContainer.leadingAnchor.constraint(equalTo: portionContainer.leadingAnchor),
            sugarStarchContainer.trailingAnchor.constraint(equalTo: portionContainer.trailingAnchor),
            sugarStarchContainer.heightAnchor.constraint(equalToConstant: 125),
        ])
    }
    
    private func configureSugarStarchLabels() {
        sugarStarchContainer.addSubview(totalSugarsCircle)
        sugarStarchContainer.addSubview(totalStarchCircle)
        totalStarchCircle.addSubview(totalStarchData)
        totalSugarsCircle.addSubview(totalSugarsData)
        sugarStarchContainer.addSubview(totalSugarsLabel)
        sugarStarchContainer.addSubview(totalStarchLabel)
        
        totalStarchCircle.layer.borderWidth   = 3
        totalSugarsCircle.layer.borderWidth   = 3
        
        totalSugarsData.text    = "\(nutrientData.totalSugars)g"
        totalStarchData.text    = "\(nutrientData.totalStarches)g"
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
    
    private func configureCarbsContainer() {
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
    
    private func configureCarbsLabels() {
        carbsContainer.addSubview(totalCarbsData)
        carbsContainer.addSubview(netCarbsData)
        carbsContainer.addSubview(totalCarbsLabel)
        carbsContainer.addSubview(netCarbsLabel)

        totalCarbsData.text             = "\(nutrientData.carbs)g"
        totalCarbsData.textAlignment    = .center
        totalCarbsLabel.text            = "Total Carbs"
        totalCarbsLabel.textAlignment   = .center
        
        netCarbsData.text               = "\(nutrientData.carbs)g"
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
    
    private func configureSugarDetailsContainer() {
        view.addSubview(sugarDetailsContainer)
        
        NSLayoutConstraint.activate([
            sugarDetailsContainer.topAnchor.constraint(equalTo: sugarStarchContainer.bottomAnchor, constant: 10),
            sugarDetailsContainer.leadingAnchor.constraint(equalTo: sugarStarchContainer.leadingAnchor),
            sugarDetailsContainer.trailingAnchor.constraint(equalTo: carbsContainer.trailingAnchor),
            sugarDetailsContainer.heightAnchor.constraint(equalToConstant: 260)
        ])
    }
    
    private func configureSugarDetailsCircles() {
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
    
    private func configureSugarDetailsLabels() {
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
    
    private func configureSugarDetailsData() {
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
        if favCheck == false {
            favCheck.toggle()
            favIcon.updateFavs(favIconEnabled: favCheck)
            PersistenceManager.updateWith(favorite: passedData, actionType: .add) { [weak self] error in
                guard let self = self else {return }
        
                guard let error = error else {
                    self.presentGFAlertOnMain(title: CAAlertTitle.foodFavorited.rawValue, message: CAAlertMessage.foodFavorited.rawValue, buttonTitle: "Ok")
                    return
                }
                print(error)
                self.presentGFAlertOnMain(title: CAAlertTitle.unableToFavorite.rawValue, message: CAAlertMessage.unableToFavorite.rawValue, buttonTitle: "Ok")
            }
        } else {
            favCheck.toggle()
            favIcon.updateFavs(favIconEnabled: favCheck)
            PersistenceManager.updateWith(favorite: passedData, actionType: .remove) { [weak self] error in
                guard let self = self else {return }
        
                guard let error = error else {
                    self.presentGFAlertOnMain(title: CAAlertTitle.favoriteRemoved.rawValue, message: CAAlertMessage.favoriteRemoved.rawValue, buttonTitle: "Ok")
                    return
                }
                print(error)
                self.presentGFAlertOnMain(title: CAAlertTitle.favoriteNotRemoved.rawValue, message: CAAlertMessage.favoriteNotRemoved.rawValue, buttonTitle: "Ok")
            }
            delegate?.updateFavoritesCollectionView()
        }
    }
    
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing))
        carbsContainer.addGestureRecognizer(tap)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let customPortionText = customPortionTextField.text, customPortionText.count != 0 else {
            totalCarbsData.text     = "\(nutrientData.carbs)g"
            netCarbsData.text       = "\(nutrientData.carbs)g"
            totalStarchData.text    = "\(nutrientData.totalStarches)g"
            totalSugarsData.text    = "\(nutrientData.totalSugars)g"
            sucroseData.text        = "\(nutrientData.sucrose)g"
            fructoseData.text       = "\(nutrientData.fructose)g"
            glucoseData.text        = "\(nutrientData.glucose)g"
            lactoseData.text        = "\(nutrientData.lactose)g"
            maltoseData.text        = "\(nutrientData.maltose)g"
            return
        }
        
        let adjustor = viewModel.getAdjustor(servingSize: passedData.servingSize, customPortion: customPortionTextField.text ?? "1")
        
        let adjustedNutrientData = viewModel.customPortionAdjustment(nutrientData: nutrientData, adjustor: adjustor)
        
        totalCarbsData.text     = "\(adjustedNutrientData.carbs)g"
        netCarbsData.text       = "\(adjustedNutrientData.carbs)g"
        totalStarchData.text    = "\(adjustedNutrientData.totalStarches)g"
        totalSugarsData.text    = "\(adjustedNutrientData.totalSugars)g"
        sucroseData.text        = "\(adjustedNutrientData.sucrose)g"
        fructoseData.text       = "\(adjustedNutrientData.fructose)g"
        glucoseData.text        = "\(adjustedNutrientData.glucose)g"
        lactoseData.text        = "\(adjustedNutrientData.lactose)g"
        maltoseData.text        = "\(adjustedNutrientData.maltose)g"
    }
    
}
