//
//  CellIdentifiers.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-12.
//

import Foundation

// table view cell identifier
public enum cellIdentifiers: String {
    case blankCell = "blankCellIdentifier"
    case assessmentFolderItemCell = "assessmentFolderCellIdentifier"
    case assessmentItemCell = "assessmentItemCellIdentifier"
    case interactiveFormCell = "interactiveFormCellIdentifier"
    case yesNoQuestionCell = "yesOrNoQuestionCellIdentifier"
    case multipleChoiceQuestionCell = "multipleChoiceQuestionCellIdentifier"
    case formMetadataCell = "formMetadataCellIdentifier"
    case multipleChoiceWithInputQuestionCell = "multipleChoiceWithInputQuestionCellIdentifier"
    case fillUpQuestionCell = "fillUpQuestionCellIdentifier"
    case LabelAndCheckRadioCell = "labelAndCheckRadioCellIdentifier"
    case labelAndInputCell = "labelAndInputCellIdentifier"
    case formSubmitCell = "formSubmitCellIdentifier"
    case choiceWithInputCell = "choiceWithInputCellIdentifier"
    case questionTitleCell = "questionTitleCellIdentifier"
    case mainCell = "mainCellIdentifier"
    case definitionCell = "definitionCellIdentifier"
    case riskFactorCell = "riskFactorCellIdentifier"
    case rateCell = "rateCellIdentifier"
    case withdrawalCell = "withdrawalCellIdentifier"
    case resourceCell = "resourceCellIdentifier"
    case contactInforCell = "contactInforCellIdentifier"
    case websiteURLCell = "WebsiteURLCellIdentifier"
    case firstTypeCell = "firstTypeCell"
    case secondTypeCell = "secondTypeCell"
    case thirdTypeCell = "thirdTypeCell"
    case textViewCell = "textViewCell"
    case contactCell1 = "contactCell1Identifier"
    case contactCell2 = "contactCell2Identifier"
}

// storyboard view controller identifier
public enum viewIdentifiers: String {
    case assessmentFolderVC = "AssessmentFolderVC"
    case assessmentsVC = "AssessmentsVC"
    case mobilityTUGVC = "MobilityTUGVC"
    case clientRiskFallVC = "ClientRiskFallVC"
    case edmontonSymptonVC = "EdmontonSymptonVC"
    case alcoholWithdrawalVC = "AlcoholWithdrawalVC"
    case miniMentalStateVC = "MiniMentalStateVC"
    case subContactVC = "SubContactVC"
    case contactDetailsVC = "ContactDetailsVC"
}
