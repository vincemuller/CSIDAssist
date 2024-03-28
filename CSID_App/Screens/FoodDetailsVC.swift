//
//  CSIDFoodDetailsVC.swift
//  CSID_App
//
//  Created by Vince Muller on 9/27/23.
//

import UIKit

protocol FavoriteArtefactsDelegate {
    func updateFavoritesCollectionView()
}

class CSIDFoodDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    var passedData:             USDAFoodDetails!
    private var nutrientData:           USDANutrientData!
    private let viewModel = FoodDetailsViewModel()
    
    var delegate: FavoriteArtefactsDelegate?
    private var favoritesVC = FavoritesVC()
    
    private let titleLabel              = CALabel(size: 20, weight: .bold, numOfLines: 3)
    
    private var favCheck: Bool          = false
    private let favIcon                 = FavoriteIconImageView(frame: .zero)
    
    private let brandCategoryLabel      = CALabel(size: 12, weight: .semibold, numOfLines: 1)
    
    private let topContainer            = FoodDetailsContainer()
    private let brandOwnerLabel         = CALabel(size: 12, weight: .semibold, numOfLines: 1)
    private let brandNameLabel          = CALabel(size: 12, weight: .semibold, numOfLines: 1)
    
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
    
    private var collectionView: UICollectionView!
    private var cardsColors: [UIColor]  = [UIColor.systemOrange,UIColor.systemTeal]
    private var cardsDetails: [String]  = ["Ingredients", "Sugars"]
    
    
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
        configureCollectionView()
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
        view.addSubview(topContainer)
        view.addSubview(portionContainer)

        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: brandCategoryLabel.bottomAnchor, constant: 10),
            topContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            topContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            topContainer.heightAnchor.constraint(equalToConstant: 50),
            
            portionContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 10),
            portionContainer.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor),
            portionContainer.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 245),
            portionContainer.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureTopLabels() {
        topContainer.addSubview(brandOwnerLabel)
        topContainer.addSubview(brandNameLabel)
        portionContainer.addSubview(portionLabel)
        
        brandOwnerLabel.text    = "Brand Owner: \(passedData.brandOwner?.capitalized ?? "N/A")"
        brandNameLabel.text     = "Brand Name: \(passedData.brandName?.capitalized ?? "N/A")"
        portionLabel.text       = "Serving Size:  \(passedData.servingSize)\(passedData.servingSizeUnit)"
        
        NSLayoutConstraint.activate([
            brandOwnerLabel.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 7),
            brandOwnerLabel.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 7),
            
            brandNameLabel.topAnchor.constraint(equalTo: brandOwnerLabel.bottomAnchor, constant: 7),
            brandNameLabel.leadingAnchor.constraint(equalTo: brandOwnerLabel.leadingAnchor),
            
            portionLabel.centerYAnchor.constraint(equalTo: portionContainer.centerYAnchor),
            portionLabel.leadingAnchor.constraint(equalTo: brandOwnerLabel.leadingAnchor)
        ])
    }
    
    private func configureCustomPortion() {
        view.addSubview(customPortionTextField)
        
        customPortionTextField.delegate = self
        
        customPortionTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            customPortionTextField.topAnchor.constraint(equalTo: portionContainer.topAnchor),
            customPortionTextField.leadingAnchor.constraint(equalTo: portionContainer.trailingAnchor, constant: 10),
            customPortionTextField.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
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
            carbsContainer.topAnchor.constraint(equalTo: portionContainer.bottomAnchor, constant: 10),
            carbsContainer.leadingAnchor.constraint(equalTo: sugarStarchContainer.trailingAnchor, constant: 10),
            carbsContainer.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
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
        
        netCarbsData.text               = "\(nutrientData.netCarbs)g"
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
    
    private func configureCollectionView() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UIHelper.createOverLappingFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reuseID)
        collectionView.register(SugarCardCollectionViewCell.self, forCellWithReuseIdentifier: SugarCardCollectionViewCell.reuseID)

        collectionView.delegate         = self
        collectionView.dataSource       = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: sugarStarchContainer.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10 )
        ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let returnCell: UICollectionViewCell
        
        if cardsDetails[indexPath.row] == "Ingredients" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseID, for: indexPath) as! CardCollectionViewCell
            cell.cardLabel.text         = cardsDetails[indexPath.row]
            cell.cardDescription.text   = (passedData.ingredients != "" ? passedData.ingredients : "No ingredient data available at this time")
            returnCell = cell
        } else if cardsDetails[indexPath.row] == "Sugars"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SugarCardCollectionViewCell.reuseID, for: indexPath) as! SugarCardCollectionViewCell
            cell.cardLabel.text         = cardsDetails[indexPath.row]
            cell.sucroseIngr.text       = viewModel.getSucroseSugars(productIngredients: passedData.ingredients.lowercased())
            cell.otherIngr.text         = viewModel.getOtherSugars(productIngredients: passedData.ingredients.lowercased())
            returnCell = cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseID, for: indexPath) as! CardCollectionViewCell
            
            cell.cardDescription.text                   = nil
            cell.cardLabel.text         = cardsDetails[indexPath.row]
            returnCell = cell
        }
        
        returnCell.layer.shadowColor = (indexPath.row==0 ? UIColor.clear.cgColor : UIColor.black.cgColor)
        returnCell.backgroundColor        = cardsColors[indexPath.row]
        
        return returnCell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            return
        }
        let element      = cardsColors.remove(at: indexPath.row)
        let elementLabel = cardsDetails.remove(at: indexPath.row)
        cardsDetails.insert(elementLabel, at: indexPath.row+1)
        cardsColors.insert(element, at: (indexPath.row+1))
        
        collectionView.reloadData()
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
            netCarbsData.text       = "\(nutrientData.netCarbs)g"
            totalStarchData.text    = "\(nutrientData.totalStarches)g"
            totalSugarsData.text    = "\(nutrientData.totalSugars)g"
            return
        }
        
        let adjustor = viewModel.getAdjustor(servingSize: passedData.servingSize, customPortion: customPortionTextField.text ?? "1")
    
        let adjustedNutrientData = viewModel.customPortionAdjustment(nutrientData: nutrientData, adjustor: adjustor)
        
        totalCarbsData.text     = "\(adjustedNutrientData.carbs)g"
        netCarbsData.text       = "\(adjustedNutrientData.netCarbs)g"
        totalStarchData.text    = "\(adjustedNutrientData.totalStarches)g"
        totalSugarsData.text    = "\(adjustedNutrientData.totalSugars)g"
            
        }
    
}
