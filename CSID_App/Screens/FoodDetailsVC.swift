//
//  CSIDFoodDetailsVC.swift
//  CSID_App
//
//  Created by Vince Muller on 9/27/23.
//

import UIKit
import CloudKit

protocol FavoriteArtefactsDelegate {
    func updateFavoritesCollectionView()
}

class CSIDFoodDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    var passedData:             USDAFoodDetails!
    var sugarTypes:             String = ""
    var passedPointer:          OpaquePointer?
    var nutrientData:           USDANutrientData!
    var recordID:               String?
    let findSugars = SucroseCheck()
    
    var delegate: FavoriteArtefactsDelegate?
    var favoritesVC = FavoritesVC()
    
    var sugarIngr: [String] = []
    var otherIngr: [String] = []
    
    var foodItemRecordID:       CKRecord.ID?
    
    let titleLabel              = CALabel(size: 20, weight: .bold, numOfLines: 3)
    
    let favIcon                 = UIImageView()
    var favIconEnabled: Bool    = false
    var config                  = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22))
    var addNewSymbol: UIImage?
    let tapGesture              = UITapGestureRecognizer()
    
    let brandCategoryLabel      = CALabel(size: 12, weight: .semibold, numOfLines: 1)
    
    let topContainer            = FoodDetailsContainer()
    let brandOwnerLabel         = CALabel(size: 12, weight: .semibold, numOfLines: 1)
    let brandNameLabel          = CALabel(size: 12, weight: .semibold, numOfLines: 1)
    
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
    
    var collectionView: UICollectionView!
    var cardsColors: [UIColor]  = [UIColor.systemOrange,UIColor.systemTeal]
    var cardsDetails: [String]  = ["Ingredients", "Sugars"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nutrientData = CADatabaseQueryHelper.queryDatabaseNutrientData(fdicID: passedData.fdicID, databasePointer: passedPointer)
        
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
        configureCollectionView()
        
        createDismissKeyboardTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureFavIcon()
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

    func query() async throws {
        let privateDB = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(format: "userID = %@", userID)
        let predicate2 = NSPredicate(format: "fdicID = \(passedData.fdicID)")
        let compPred = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "UserFavorites", predicate: compPred)
        let testResults = try await privateDB.records(matching: query)
        for t in testResults.matchResults {
            let a = try t.1.get()
            foodItemRecordID = a.recordID
        }
      //  let result = try testResults.matchResults[1].1.get()
    }
    
    func testingCKRecordCreation() {
        guard favIconEnabled == false else {return}
        let record = CKRecord(recordType: "UserFavorites")
        let container = CKContainer.default()
        let database = container.privateCloudDatabase

            record.setValuesForKeys([
                "fdicID": passedData.fdicID as Any,
                "userID": userID as Any,
            ]
            )

        database.save(record) { record, error in
            if let error = error {
                print("error, did not succeed!\(error)")
                return
            }
                print("Successful!")
                print(record?.recordID.recordName as Any)
        }
    }
    
    func ckRecordDeletion(id: CKRecord.ID) {
        let container = CKContainer.default()
        let database = container.privateCloudDatabase
        
        database.delete(withRecordID: id) { id, error in
            if let error = error {
                print("error, did not remove!\(error)")
                return
            }
                print("Successfully removed favorite \(String(describing: id))")
        }
    }

    
    func configureFavIcon() {
        view.addSubview(favIcon)
        let favCheck = userFavorites.contains(passedData.fdicID)
        print(passedData.fdicID)
        print(favCheck)
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
    
    func configureTopLabels() {
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
    
    func configureCustomPortion() {
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
    
    func configureCarbsLabels() {
        carbsContainer.addSubview(totalCarbsData)
        carbsContainer.addSubview(netCarbsData)
        carbsContainer.addSubview(totalCarbsLabel)
        carbsContainer.addSubview(netCarbsLabel)

        totalCarbsData.text             = (nutrientData.carbs != "N/A" ? (round(Float(nutrientData.carbs)!*10)/10.0).description : "N/A")
        totalCarbsData.textAlignment    = .center
        totalCarbsLabel.text            = "Total Carbs"
        totalCarbsLabel.textAlignment   = .center
        
        netCarbsData.text               = (nutrientData.netCarbs != "N/A" ? (round(Float(nutrientData.netCarbs)!*10)/10.0).description : "N/A")
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
    
    func configureCollectionView() {
        
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
            
            cell.cardDescription.text                   = passedData.ingredients
            returnCell = cell
        } else if cardsDetails[indexPath.row] == "Sugars"{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SugarCardCollectionViewCell.reuseID, for: indexPath) as! SugarCardCollectionViewCell
            cell.cardLabel.text         = cardsDetails[indexPath.row]
            sugarIngr = sugarIngr.map({$0.capitalized})
            otherIngr = otherIngr.map({$0.capitalized})
            let sI = sugarIngr.joined(separator: "  •")
            let oI = otherIngr.joined(separator: "  •")
            cell.sucroseIngr.text       = (sI.isEmpty ? "No sucrose detected. As always, check the ingredients" : "•\(sI)")
            cell.otherIngr.text         = (oI.isEmpty ? "No other sugars detected. As always, check the ingredients" : "•\(oI)")
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
        let element      = cardsColors.remove(at: indexPath.row)
        let elementLabel = cardsDetails.remove(at: indexPath.row)
        cardsDetails.insert(elementLabel, at: indexPath.row+1)
        cardsColors.insert(element, at: (indexPath.row+1))
        
        collectionView.reloadData()
    }
    
    @objc func handleFavoriteTapped(_ gesture: UITapGestureRecognizer) {
        if favIconEnabled == false {
            guard userID != "" else {
                presentGFAlertOnMain(title: CAAlertTitle.unableToFavorite.rawValue, message: CAAlertMessage.generaliCloudError.rawValue, buttonTitle: "Ok")
                return
            }
            testingCKRecordCreation()
            userFavorites.append(passedData.fdicID)
            addNewSymbol        = UIImage(systemName: "star.fill", withConfiguration: config)
            favIcon.image       = addNewSymbol
            favIconEnabled      = true
            self.presentGFAlertOnMain(title: "Food Favorited", message: "You have successfully added \(passedData.description.capitalized) to your favorites", buttonTitle: "Ok")
            delegate?.updateFavoritesCollectionView()
        } else {
            Task.init {
                do {
                    try await query()
                    guard foodItemRecordID != nil else {
                        presentGFAlertOnMain(title: CAAlertTitle.unableToRemove.rawValue, message: CAAlertMessage.unableToRemove.rawValue, buttonTitle: "Ok")
                        return
                        }
                    ckRecordDeletion(id: foodItemRecordID!)
                    userFavorites       = userFavorites.filter(){$0 != passedData.fdicID}
                    addNewSymbol        = UIImage(systemName: "star", withConfiguration: config)
                    favIcon.image       = addNewSymbol
                    favIconEnabled      = false
                    self.presentGFAlertOnMain(title: "Food Removed", message: "You have successfully removed \(passedData.description.capitalized) from your favorites", buttonTitle: "Ok")
                    delegate?.updateFavoritesCollectionView()
                } catch {
                    presentGFAlertOnMain(title: "Unable to Fetch", message: error.localizedDescription, buttonTitle: "Ok")
                }
            }
        }

    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing))
        topContainer.addGestureRecognizer(tap)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let customPortionText = customPortionTextField.text, customPortionText.count != 0 else {
            totalCarbsData.text     = (nutrientData.carbs != "N/A" ? (round(Float(nutrientData.carbs)!*10)/10.0).description : "N/A")
            netCarbsData.text       = (nutrientData.netCarbs != "N/A" ? (round(Float(nutrientData.netCarbs)!*10)/10.0).description : "N/A")
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
        
        if nutrientData.netCarbs != "N/A" {
            let adjustedNetCarbs: Float = round(((Float(nutrientData.netCarbs)!*adjustor)*10)/10.0)
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
