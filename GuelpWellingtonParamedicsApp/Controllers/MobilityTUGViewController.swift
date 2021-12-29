//
//  InteractiveFormViewController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-12.
//

import UIKit

class MobilityTUGViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    private let viewModel = ViewModel()
    private var error: OpenNewError?
    private var formModel: AssessmentForm?
    private var submitRequestStatusCode: Int?
    private var answerForQuestion1 = ""
    private var questionList = [Question]()
    private var question1YesCellWasTapped = false
    private var question1NoCellWasTapped = false
    private var formMetaData = [FormMetaData]()
    private var questionResults = [SubmitQuestion]()
    private var totalScore = 0
    private var patientId = String()
    private var paramedics = String()
    private var createdOn = String()
    private var isFormFilled = false
    var userFullName: String?
    var token: String?
    var form: FormModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = form?.id, let fullName = userFullName {
            viewModel.getAssessmentFormById(formId: id, fullName: fullName)
        }
        
        if let title = form?.title {
            self.title = title
        }
        
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        tableViewCellRegister()

        // updating data from view model
        viewModel.errorStore.bind {[weak self] error in
            guard let error = error else { return }
            self?.error = error
        }
        
        viewModel.assessmentFormStore.bind {[weak self] form in
            guard
                let form = form
            else {
                return
            }
            
            self?.formModel = form
                        
            // first question of "Can the patient walk without assistance: [Yes, No]"
            let firstQuestion = TableViewUtilities.findOutAQuestion(sections: form.sections, sectionName: QuestionInfor.noSection, expectedQuestions: QuestionInfor.expectedQuestion1)
            
            guard let firstQuestion = firstQuestion else {
                return
            }
            
            // add elements to question list variable
            self?.questionList.append(firstQuestion)
            
            // set value for form's patient Id, paramedics, and date
            self?.formMetaData = TableViewUtilities.generateFormMetaData(form)
            
            self?.myTableView.reloadData()
        }
        
        viewModel.submittingAnswerResultStore.bind {[weak self] submitRequestStatusCode in
            guard let statusCode = submitRequestStatusCode else {
                return
            }
            
            self?.submitRequestStatusCode = statusCode
            
            if statusCode == 200, let self = self, let formModel = self.formModel  {
                DispatchQueue.main.async {
                    let message = "\(formModel.title) has been successfully submitted"
                    let actionTitle = "OK"
                    AlertUtilities.showAlert1(self: self, tableView: self.myTableView, title: AlertUtilities.title2, message: message, actionTitle: actionTitle, action: self.afterDoneSubmittingAction)
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func afterDoneSubmittingAction() {
        // reset data after submitting successfully
        guard let formModel = formModel else {
            return
        }

        self.formMetaData = TableViewUtilities.generateFormMetaData(formModel)
        self.questionResults = []
        self.formModel?.sections[0].questions.indices.forEach {
            self.formModel?.sections[0].questions[$0].answer = nil
        }
        
        self.myTableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableViewCellRegister() {
        self.myTableView.register(UINib(nibName: "BlankCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.blankCell.rawValue)
        self.myTableView.register(UINib(nibName: "FormMetadataCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.formMetadataCell.rawValue)
        self.myTableView.register(UINib(nibName: "YesNoQuestionCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.yesNoQuestionCell.rawValue)
        self.myTableView.register(UINib(nibName: "MultipleChoiceQuestionCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.multipleChoiceQuestionCell.rawValue)
        self.myTableView.register(UINib(nibName: "MultipleChoiceWithInputQuestionCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.multipleChoiceWithInputQuestionCell.rawValue)
        self.myTableView.register(UINib(nibName: "FillUpQuestionCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.fillUpQuestionCell.rawValue)
        self.myTableView.register(UINib(nibName: "FormSubmitCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.formSubmitCell.rawValue)
    }
    
}

extension MobilityTUGViewController: UITableViewDelegate {
    
}

extension MobilityTUGViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mminimumQuestionNumber = 2
        if questionList.count >= mminimumQuestionNumber {
            return questionList.count + 2 // + 2 for metadata form and submit cells
        } else {
            return questionList.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.formMetadataCell.rawValue, for: indexPath) as! FormMetadataCell
        
            cell.data = formMetaData
            cell.delegate = self
            
            return cell
        case 1:
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.yesNoQuestionCell.rawValue, for: indexPath) as! YesNoQuestionCell

            guard let firstQuestion = questionList.first else {
                return cell
            }
            cell.index = indexPath.row
            cell.data = firstQuestion
            cell.delegate = self
            
            return cell
        case 2:
            if answerForQuestion1 == "No" {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.multipleChoiceQuestionCell.rawValue, for: indexPath) as! MultipleChoiceQuestionCell

                let secondQuestion = questionList[1]
                cell.data = secondQuestion
                cell.delegate = self
          
                return cell
            } else if answerForQuestion1 == "Yes" {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.yesNoQuestionCell.rawValue, for: indexPath) as! YesNoQuestionCell

                let secondQuestion = questionList[1]
                cell.data = secondQuestion
                cell.index = indexPath.row
                cell.delegate = self
                
                return cell
            }
        case 3:
            if answerForQuestion1 == "Yes" {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.multipleChoiceWithInputQuestionCell.rawValue, for: indexPath) as! MultipleChoiceWithInputQuestionCell
                guard questionList.count >= 3 else { return cell }
                let thirdQuestion = questionList[2]
                cell.data = thirdQuestion
                cell.delegate = self

                return cell
            } else {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.formSubmitCell.rawValue, for: indexPath) as! FormSubmitCell
                
                cell.delegate = self
                
                questionList.forEach {
                    if $0.answer != nil {
                        isFormFilled = true
                    } else {
                        isFormFilled = false
                    }
                }
                
                if isFormFilled {
                    cell.submitButton.backgroundColor = .systemBlue
                    cell.submitButton.isUserInteractionEnabled = true
                } else {
                    cell.submitButton.backgroundColor = .systemBlue.withAlphaComponent(0.6)
                    cell.submitButton.isUserInteractionEnabled = false
                }

                return cell
            }
        case 4:
            if answerForQuestion1 == "Yes" {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.fillUpQuestionCell.rawValue, for: indexPath) as! FillUpQuestionCell
                
                guard questionList.count >= 4 else { return cell }
                
                let fourthQuestion = questionList[3]
                
                if let description = fourthQuestion.content.description {
                    cell.descriptionTextView.attributedText = description.htmlToAttributedString
                }
                
                cell.descriptionTextView.font = .systemFont(ofSize: 17)
                cell.scoreTextField.text = fourthQuestion.answer
                cell.titleLabel.text = fourthQuestion.title
                cell.delegate = self
                
                return cell
            } else {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.formSubmitCell.rawValue, for: indexPath) as! FormSubmitCell
                cell.delegate = self

                return cell
            }
        case 5:
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.formSubmitCell.rawValue, for: indexPath) as! FormSubmitCell
            cell.delegate = self
 
            questionList.forEach {
                if $0.answer != nil {
                    isFormFilled = true
                } else {
                    isFormFilled = false
                }
            }
            
            if isFormFilled {
                cell.submitButton.backgroundColor = .systemBlue
                cell.submitButton.isUserInteractionEnabled = true
            } else {
                cell.submitButton.backgroundColor = .systemBlue.withAlphaComponent(0.6)
                cell.submitButton.isUserInteractionEnabled = false
            }
            return cell
        default:
            return myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.blankCell.rawValue, for: indexPath) as! BlankCell
        }
        
        return myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.blankCell.rawValue, for: indexPath) as! BlankCell
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            myTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {

        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            myTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension MobilityTUGViewController: YesNoQuestionCellDelegate {
    
    func theYesCellWasTapped(_ answer: String, _ index: Int) {
        if index == 1 && !question1YesCellWasTapped {

            answerForQuestion1 = answer

            // add selected answer to question 1
            for (index, _) in questionList.enumerated() {
                if index == 0 {
                    questionList[0].answer = answerForQuestion1
                }
            }

            // remove all elements from question list excepting first element
            if questionList.count > 1 {
                questionList.removeSubrange(1..<questionList.endIndex)
            }

            // second question of "Does the patient use an assistive device
            // to aid in walking:"
            let secondQuestion = TableViewUtilities.findOutAQuestion(sections: formModel!.sections, sectionName: QuestionInfor.noSection, expectedQuestions: QuestionInfor.expectedQuestion2)
            
            // the third question of "please select the assistive device"
            let thirdQuestion = TableViewUtilities.findOutAQuestion(sections: formModel!.sections, sectionName: QuestionInfor.noSection, expectedQuestions: QuestionInfor.expectedQuestion4)
            
            // the fourth question of "Timed up and go test"
            let fourthQuestion = TableViewUtilities.findOutAQuestion(sections: formModel!.sections, sectionName: QuestionInfor.noSection, expectedQuestions: QuestionInfor.expectedQuestion5)

            if let secondQuestion = secondQuestion,
                let thirdQuestion = thirdQuestion,
                let fourthQuestion = fourthQuestion
            {
                questionList.append(secondQuestion)
                questionList.append(thirdQuestion)
                questionList.append(fourthQuestion)
                
                myTableView.reloadData()
            }
            
            question1YesCellWasTapped = true
            question1NoCellWasTapped = false
        } else if index == 2 {
            // for Does the patient use an assistive device to aid in walking question
            questionList[1].answer = answer
            myTableView.reloadData()
        }
    }
    
    func theNoCellWasTapped(_ answer: String, _ index: Int) {
        
        if index == 1 && !question1NoCellWasTapped {
            
            answerForQuestion1 = answer

            // add selected answer to question 1
            for (index, _) in questionList.enumerated() {
                if index == 0 {
                    questionList[0].answer = answerForQuestion1
                }
            }

            // remove all elements from question list excepting first element
            if questionList.count > 1 {
                questionList.removeSubrange(1..<questionList.endIndex)
            }

            // the second question of "can the patient: [a,b,c,d]"
            let secondQuestion = TableViewUtilities.findOutAQuestion(sections: formModel!.sections, sectionName: QuestionInfor.noSection, expectedQuestions: QuestionInfor.expectedQuestion3)


            if  let secondQuestion = secondQuestion
            {
                questionList.append(secondQuestion)
            
                myTableView.reloadData()
            }
            
            question1NoCellWasTapped = true
            question1YesCellWasTapped = false
        }  else if index == 2 {
            // for Does the patient use an assistive device to aid in walking question
            questionList[1].answer = answer
            myTableView.reloadData()
        }
    }
}

extension MobilityTUGViewController:
        FormSubmitCellDelegate,
        FormMetadataCellDelegate,
        MultipleChoiceWithInputQuestionCellDelegate,
        MultipleChoiceQuestionCellDelegate,
        FillUpQuestionCellDelegate
{
    
    // for getting data from the FormMetadataCell
    func passingPatientIdToParentVC(_ text: String, _ cell: LabelAndInputCell) {
        for (index, value) in formMetaData.enumerated() {
            patientId = text
            
            // check patient id length
            if patientId.count != 6 {
                cell.invalidPatientIdText.isHidden = false
                return
            } else {
                cell.invalidPatientIdText.isHidden = true
            }
            
            if value.title == "Patient Id" {
                formMetaData[index].value = patientId
                myTableView.reloadData()
            }
        }
    }
    
    // for Can the patient [x, y, z,...] question
    func getAnswerFromMultipleChoiceQuestion(_ answer: String) {
        if answer != "" {
            questionList[1].answer = answer
            myTableView.reloadData()
        }
    }
    
    // for Please select the assistive device question
    func getAnswerFromMultipleChoiceWithInputQuestion(_ answer: String) {
        if answer != "" {
            questionList[2].answer = answer
            myTableView.reloadData()
        }
    }
    
    // for Please select the assistive device question with input choice
    func getAnswerFromMultipleChoiceWithInputQuestion1(_ answer: String) {
        if answer != "" {
            questionList[2].answer = answer
            myTableView.reloadData()
        }
    }
    
    // for Timed Up and Go Test1 question
    func getAnswerFromFillUpQuestionCell(answer: String) {
        questionList[3].answer = answer
        myTableView.reloadData()
    }
    
    func submitBtnPressed() {
        if patientId == "" {
            AlertUtilities.showAlert2(self: self, title: AlertUtilities.title1, message: AlertUtilities.message1, actionTitle: "OK", textColor: UIColor.red)
        }
        
        guard let token = token else { return }
        
        formMetaData.forEach {
            if $0.title == "Paramedics", let value = $0.value {
                paramedics = value
            }

            if $0.title == "Date time", let value = $0.value {
                createdOn = value
            }
        }
        
        
        questionList.forEach {
            if let answer = $0.answer {
                let element = SubmitQuestion(questionId: $0.id, answer: answer)
                questionResults.append(element)
            }
        }
        
        // for finding questions that were not used
        // by compare two arrays: formModel?.sections[0].questions vs questionList
        var ids = [Int]()
        
        questionList.forEach { x in
            ids.append(x.id)
        }
        
        var hashA = [Int: Bool]()
        
        ids.forEach {
            hashA[$0] = true
        }
        
        var other_ids = [Int]()
        
        
        formModel?.sections[0].questions.forEach {
            //section[0]: because this form section has only one section that named "NO_SECTION"
            if hashA[$0.id] != true {
                other_ids.append($0.id)
            }
        }
        
        other_ids.forEach {
            // create new submit question with empty answer
            let question = SubmitQuestion(questionId: $0, answer: "")
            // add new question to question results
            questionResults.append(question)
        }
        
        let submitData = SubmitModel(patientID: patientId, totalScore: totalScore, interactiveFormId: formModel!.id, assessmentDate: createdOn, questionResults: questionResults)
        
        viewModel.submitFormAnswerToAPI(submitData: submitData, token: token)
    }
}
