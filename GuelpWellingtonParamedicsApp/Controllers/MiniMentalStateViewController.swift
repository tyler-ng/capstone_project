//
//  MiniMentalStateViewController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-17.
//

import UIKit

class MiniMentalStateViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    
    private let viewModel = ViewModel()
    private var error: OpenNewError?
    private var formModel: AssessmentForm?
    private var formMetaData = [FormMetaData]()
    private var numberOfQuestionSections = 0
    public var questionResults = [SubmitQuestion]()
    private var submitRequestStatusCode: Int?
    private var totalScore = 0
    private var patientId = String()
    private var paramedics = String()
    private var createdOn = String()
    var userFullName: String?
    var token: String?
    var form: FormModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let id = form?.id, let fullName = userFullName {
            viewModel.getAssessmentFormById(formId: id, fullName: fullName)
        }
        
        // set title for navigation
        if let title = form?.title {
            self.title = title
        }
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        tableViewCellRegister()
        
        viewModel.errorStore.bind {[weak self] error in
            guard let error = error else {
                return
            }
            
            self?.error = error
        }
        
        viewModel.assessmentFormStore.bind {[weak self] form in
            guard let form = form else {
                return
            }
            
            self?.formModel = form
            self?.formMetaData = TableViewUtilities.generateFormMetaData2(form)
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
    }
    
    func tableViewCellRegister() {
        self.myTableView.register(UINib(nibName: "FormMetadataCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.formMetadataCell.rawValue)
        myTableView.register(UINib(nibName: "FirstTypeCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.firstTypeCell.rawValue)
        myTableView.register(UINib(nibName: "SecondTypeCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.secondTypeCell.rawValue)
        myTableView.register(UINib(nibName: "ThirdTypeCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.thirdTypeCell.rawValue)
        myTableView.register(UINib(nibName: "FormSubmitCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.formSubmitCell.rawValue)
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
}

extension MiniMentalStateViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = formModel?.sections.count {
            numberOfQuestionSections = count + 2
            return numberOfQuestionSections
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { // for formMetaData cell
           return 1
        } else if section == numberOfQuestionSections - 1 { // last section for formSubmit cell
            return 1
        } else { // for a section that might contain all the questions
            return formModel?.sections[section - 1].questions.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.formMetadataCell.rawValue, for: indexPath) as! FormMetadataCell
            cell.mainView.backgroundColor = .clear
            cell.data = formMetaData
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: myTableView.frame.width)
            cell.delegate = self
            
            return cell
        } else if indexPath.section == numberOfQuestionSections - 1 {
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.formSubmitCell.rawValue, for: indexPath) as! FormSubmitCell
            cell.mainView.backgroundColor = .clear
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: myTableView.frame.width)
            cell.delegate = self
            cell.submitButton.isUserInteractionEnabled = true
            cell.submitButton.backgroundColor = .systemBlue
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.firstTypeCell.rawValue, for: indexPath) as! FirstTypeCell
            
            guard let questions = formModel?.sections[indexPath.section - 1].questions else {
                return cell
            }
            
            let question = questions[indexPath.row]
            let questionTitle = question.title
            let titleElement1 = "Name of 3 common object"
            let titleElement2 = "Spell \"world\" backwards"
            
            if questionTitle.contains(titleElement1) {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.secondTypeCell.rawValue, for: indexPath) as! SecondTypeCell
                cell.max_score = question.content.max_score
                
                if indexPath.row == questions.count - 1 {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: myTableView.frame.width)
                }
                cell.questionId = question.id
                cell.indexPath = indexPath
                cell.delegate = self
                cell.scoreTextField.text = question.answer
                
                return cell
            } else if questionTitle.contains(titleElement2) {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.thirdTypeCell.rawValue, for: indexPath) as! ThirdTypeCell
                cell.max_score = question.content.max_score
                
                // clear separate line of a last row
                if indexPath.row == questions.count - 1 {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: myTableView.frame.width)
                }
                cell.questionId = question.id
                cell.indexPath = indexPath
                cell.delegate = self
                cell.scoreTextField.text = question.answer
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.firstTypeCell.rawValue, for: indexPath) as! FirstTypeCell
                cell.max_score = question.content.max_score
                cell.titleLabel.text = question.title
                
                if indexPath.row == questions.count - 1 {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: myTableView.frame.width)
                }
                cell.questionId = question.id
                cell.indexPath = indexPath
                cell.delegate = self
                cell.scoreTextField.text = question.answer
                
                return cell
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 && section != numberOfQuestionSections - 1 {
            guard let headerTitle = formModel?.sections[section - 1].name else {
                return nil
            }
            let v = TableViewUtilities.addTextToHeaderSection(text: headerTitle, tableView: myTableView, xOffset: 20.0, yOffset: 5.0, labelHeight: 30.0, size: 15.0)
            return v
        } else {
            return nil
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 && section != numberOfQuestionSections - 1 {
            return 40
        } else {
            return 0
        }
        
    }
    
}


extension MiniMentalStateViewController: UITableViewDelegate {
    
}


extension MiniMentalStateViewController: FormSubmitCellDelegate, FormMetadataCellDelegate, CellDelegate {
    func getScoreValue(score: String, questionId: Int, indexPath: IndexPath) {
        guard let formModel = formModel else {
            return
        }
        let section = indexPath.section - 1
        if let index = formModel.sections[section].questions.firstIndex(where: {$0.id == questionId}) {
            self.formModel?.sections[section].questions[index].answer = score
        }
        myTableView.reloadData()
    }
    
    func passingPatientIdToParentVC(_ text: String, _ cell: LabelAndInputCell) {
        for (index, value) in formMetaData.enumerated() {
            self.patientId = text
            
            // check patient id length
            if patientId.count != 6 {
                cell.invalidPatientIdText.isHidden = false
                return
            } else {
                cell.invalidPatientIdText.isHidden = true
            }
            
            if value.title == "Patient Id" {
                formMetaData[index].value = text
                myTableView.reloadData()
            }
        }
    }
    
    func submitBtnPressed() {
        guard let formModel = formModel, let token = token else {
            return
        }
        
        if patientId == "" {
            AlertUtilities.showAlert2(self: self, title: AlertUtilities.title1, message: AlertUtilities.message1, actionTitle: "OK", textColor: UIColor.red)
        }
        
        formMetaData.forEach {
            if $0.title == "Paramedics", let value = $0.value {
                self.paramedics = value
            }
            
            if $0.title == "Date time", let value = $0.value {
                createdOn = value
            }
        }
        
        if questionResults.count == 0 {
            formModel.sections.forEach {
                $0.questions.forEach {
                    let item = SubmitQuestion(questionId: $0.id, answer: $0.answer ?? "")
                    questionResults.append(item)
                }
            }
        }
        
        let submitData = SubmitModel(patientID: patientId, totalScore: totalScore, interactiveFormId: formModel.id, assessmentDate: createdOn, questionResults: questionResults)
        
        viewModel.submitFormAnswerToAPI(submitData: submitData, token: token)
        
    }
    
    
}

