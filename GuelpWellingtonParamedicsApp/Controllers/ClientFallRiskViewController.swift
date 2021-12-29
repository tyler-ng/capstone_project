//
//  ClientFallRiskViewController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-08.
//

import UIKit

class ClientFallRiskViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    private let viewModel = ViewModel()
    private var error: OpenNewError?
    private var formModel: AssessmentForm?
    private var submitRequestStatusCode: Int?
    private var formMetaData = [FormMetaData]()
    private var questionResults = [SubmitQuestion]()
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
        
        // set title navigation head
        if let title = form?.title {
            self.title = title
        }
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        tableViewCellRegister()
        
        // updating data from view model
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
        self.myTableView.register(UINib(nibName: "MainCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.mainCell.rawValue)
        self.myTableView.register(UINib(nibName: "FormSubmitCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.formSubmitCell.rawValue)
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

extension ClientFallRiskViewController: UITableViewDelegate {
}

extension ClientFallRiskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = formModel?.sections.first?.questions.count {
            return count + 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
        }
        if indexPath.row == 0 {
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.formMetadataCell.rawValue, for: indexPath) as! FormMetadataCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            cell.delegate = self
            cell.data = formMetaData
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers.mainCell.rawValue, for: indexPath) as! MainCell
            guard let count = formModel?.sections.first?.questions.count else {
                return cell
            }
            
            let lastRowIndex = count + 1 // count from 0
            
            if indexPath.row != lastRowIndex {
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
                cell.delegate = self
                guard let questions = formModel?.sections.first?.questions else { return cell }
                
                let question = questions[indexPath.row - 1]
                cell.data = question
                cell.indexPathForCell = indexPath
                
                return cell
            } else {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.formSubmitCell.rawValue, for: indexPath) as! FormSubmitCell
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
                cell.submitButton.isUserInteractionEnabled = true
                cell.submitButton.backgroundColor = .systemBlue
                cell.delegate = self
                
                return cell
            }
        }
       
    }
}

extension ClientFallRiskViewController:
        MainCellDelegate,
        FormSubmitCellDelegate,
        FormMetadataCellDelegate {
    
    func getCircleValueFromCell(value: String, questionId: Int, indexPathForMainCell: IndexPath) {
        // update answer for question
        guard let formModel = formModel else {
            return
        }
        
        if let index = formModel.sections[0].questions.firstIndex(where: {$0.id == questionId}) {
            let numberOfItems = formModel.sections[0].questions[index].content.items.count
            if numberOfItems == 1 {
                
                if let _ = self.formModel?.sections[0].questions[index].answer {
                    self.formModel?.sections[0].questions[index].answer = nil
                } else {
                    self.formModel?.sections[0].questions[index].answer = value
                }
                
            } else {
                self.formModel?.sections[0].questions[index].answer = value
            }
            
            let indexPath = IndexPath(item: indexPathForMainCell.row, section: indexPathForMainCell.section)
            myTableView.reloadRows(at: [indexPath], with: .none)
        }
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
                paramedics = value
            }
            
            if $0.title == "Date time", let value = $0.value {
                createdOn = value
            }
        }
        
        if questionResults.count == 0 {
            formModel.sections[0].questions.forEach {
                let item = SubmitQuestion(questionId: $0.id, answer: $0.answer ?? "")
                questionResults.append(item)
            }
        }
        
        let submitData = SubmitModel(patientID: patientId, totalScore: totalScore, interactiveFormId: formModel.id, assessmentDate: createdOn, questionResults: questionResults)
        
        viewModel.submitFormAnswerToAPI(submitData: submitData, token: token)
    }
}
