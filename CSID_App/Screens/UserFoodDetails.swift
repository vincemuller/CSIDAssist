//
//  UserFoodDetails.swift
//  CSID_App
//
//  Created by Vince Muller on 12/31/23.
//

import UIKit
import CloudKit

protocol RemoveUserFoodDelegate {
    func removeUserFood()
}

protocol UpdateUserFoodDelegate {
    func updateUserFoods()
}

class UserFoodDetails: UIViewController, EditUserFoodDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    var passedData:             YourFoodItem!
    var sugarTypes:             String = ""
    
    let findSugars = SucroseCheck()
    
    var sugarIngr: [String] = []
    var otherIngr: [String] = []
    
    var removeDelegate: RemoveUserFoodDelegate?
    var updateDelegate: UpdateUserFoodDelegate?
    
    var foodItemRecordID:       CKRecord.ID?
    
    let titleLabel              = CALabel(size: 20, weight: .bold, numOfLines: 3)
    
    let editIcon                = UIImageView()

    var config                  = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22))
    var addNewSymbol: UIImage?
    let tapGesture              = UITapGestureRecognizer()
    
    let brandCategoryLabel      = CALabel(size: 12, weight: .semibold, numOfLines: 1)
    
    let portionContainer        = FoodDetailsContainer()
    let portionLabel            = CALabel(size: 14, weight: .semibold, numOfLines: 1)
    
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
    var cardsColors: [UIColor]      = [UIColor.systemOrange,UIColor.systemTeal]
    var cardsDetails: [String]      = ["Ingredients/Recipe", "Sugars"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        let uniqueIngredients = findSugars.makingIngredientsUnique(productIngredients: passedData.ingredients.lowercased())
        sugarIngr = findSugars.getSucroseIngredients(productIngredients: uniqueIngredients)
        otherIngr = findSugars.getOtherSugarIngredients(productIngredients: uniqueIngredients)
        
        configureTitleLabel()
        configurePortionContainers()
        configurePortionLabel()
        configureSugarStarchContainer()
        configureSugarStarchLabels()
        configureCarbsContainer()
        configureCarbsLabels()
        configureCollectionView()
        configureEditIcon()
    }
    
    
    func configureTitleLabel() {
        view.addSubview(titleLabel)
        view.addSubview(brandCategoryLabel)
        
        titleLabel.text = passedData.description.capitalized
        brandCategoryLabel.text = "Category: Your Foods"
        
        brandCategoryLabel.textColor = .systemGray2
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            brandCategoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            brandCategoryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor)
            
        ])
    }

    
    func configurePortionContainers() {
        view.addSubview(portionContainer)

        NSLayoutConstraint.activate([
            portionContainer.topAnchor.constraint(equalTo: brandCategoryLabel.bottomAnchor, constant: 10),
            portionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            portionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            portionContainer.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configurePortionLabel() {
        portionContainer.addSubview(portionLabel)
        
        portionLabel.text   = "Serving Size:  \(passedData.portionSize.lowercased())"
        
        NSLayoutConstraint.activate([
            portionLabel.centerYAnchor.constraint(equalTo: portionContainer.centerYAnchor),
            portionLabel.leadingAnchor.constraint(equalTo: portionContainer.leadingAnchor, constant: 7)
        ])
    }
    
    func configureSugarStarchContainer() {
        view.addSubview(sugarStarchContainer)
        
        
        NSLayoutConstraint.activate([
            sugarStarchContainer.topAnchor.constraint(equalTo: portionContainer.bottomAnchor, constant: 10),
            sugarStarchContainer.leadingAnchor.constraint(equalTo: portionContainer.leadingAnchor),
            sugarStarchContainer.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 245),
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
        
        totalSugarsData.text    = passedData.totalSugars.description
        totalStarchData.text    = (max((Float(passedData.totalCarbs-passedData.totalFiber-passedData.totalSugars)),0)).description
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
    
    func configureEditIcon() {
        view.addSubview(editIcon)
        
        addNewSymbol        = UIImage(systemName: "square.and.pencil", withConfiguration: config)
        editIcon.image       = addNewSymbol
        editIcon.tintColor   = .systemGray
        
        tapGesture.addTarget(self, action: #selector(handleEditTapped))
        tapGesture.isEnabled            = true
        tapGesture.numberOfTapsRequired = 1

        editIcon.translatesAutoresizingMaskIntoConstraints = false
        
        editIcon.isUserInteractionEnabled    = true
        editIcon.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            editIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            editIcon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5)
        ])
        
        
    }
    
    @objc func handleEditTapped(_ gesture: UITapGestureRecognizer) {
        let editUserFoodVC          = EditUserFoodVC()
        editUserFoodVC.delegate = self
        editUserFoodVC.passedData   = passedData
        self.present(editUserFoodVC, animated: true)
        }
    
    func configureCarbsContainer() {
        view.addSubview(carbsContainer)
        carbsContainer.addSubview(carbsSeparatorLine)
        
        NSLayoutConstraint.activate([
            carbsContainer.topAnchor.constraint(equalTo: portionContainer.bottomAnchor, constant: 10),
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

        totalCarbsData.text             = passedData.totalCarbs.description
        totalCarbsData.textAlignment    = .center
        totalCarbsLabel.text            = "Total Carbs"
        totalCarbsLabel.textAlignment   = .center
        
        netCarbsData.text               = (max((Float(passedData.totalCarbs-passedData.totalFiber)),0)).description
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
            collectionView.leadingAnchor.constraint(equalTo: portionContainer.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10 )
        ])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let returnCell: UICollectionViewCell

        if cardsDetails[indexPath.row] == "Ingredients/Recipe" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseID, for: indexPath) as! CardCollectionViewCell
            cell.cardLabel.text         = cardsDetails[indexPath.row]
            
            cell.cardDescription.text   = passedData.ingredients
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
            
            cell.cardDescription.text   = nil
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
    
    func updateUserFoodDetails(foodDetails: YourFoodItem) {
        passedData = foodDetails
        
        titleLabel.text         = passedData.description
        portionLabel.text       = "Serving Size:  \(passedData.portionSize.lowercased())"
        totalCarbsData.text     = passedData.totalCarbs.description
        netCarbsData.text       = (max((Float(passedData.totalCarbs-passedData.totalFiber)),0)).description
        totalSugarsData.text    = passedData.totalSugars.description
        totalStarchData.text    = (max((Float(passedData.totalCarbs-passedData.totalFiber-passedData.totalSugars)),0)).description
        
        sugarIngr = findSugars.getSucroseIngredients(productIngredients: passedData.ingredients.lowercased())
        otherIngr = findSugars.getOtherSugarIngredients(productIngredients: passedData.ingredients.lowercased())
        
        collectionView.reloadData()
        updateDelegate?.updateUserFoods()
        
        self.presentGFAlertOnMain(title: CAAlertTitle.foodUpdated.rawValue, message: CAAlertMessage.foodUpdated.rawValue, buttonTitle: "Ok")
        
    }
    
    func removeUserFood() {
        self.dismiss(animated: true) {
            self.removeDelegate?.removeUserFood()
        }
    }

}

