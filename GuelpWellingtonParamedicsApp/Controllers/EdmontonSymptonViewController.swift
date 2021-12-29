//
//  EdmontonSymptonViewController.swift
//  GuelpWellingtonParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-13.
//

import UIKit

class EdmontonSymptonViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    private let viewModel = ViewModel()
    private var error: OpenNewError?
    public var formModel: AssessmentForm?
    public var formMetaData = [FormMetaData]()
    public var questionResults = [SubmitQuestion]()
    private var submitRequestStatusCode: Int?
    private var totalScore = 0
    private var patientId = String()
    private var paramedics = String()
    private var createdOn = String()
    private var numberOfRow = 0
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
        self.myTableView.register(UINib(nibName: "RateCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.rateCell.rawValue)
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


extension EdmontonSymptonViewController: UITableViewDelegate {
    
}


extension EdmontonSymptonViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = formModel?.sections.first?.questions.count {
            numberOfRow = count + 2
            return numberOfRow
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.formMetadataCell.rawValue, for: indexPath) as! FormMetadataCell
            cell.mainView.backgroundColor = .clear
            cell.data = formMetaData
            cell.delegate = self
            
            return cell
        } else {
            guard let count = formModel?.sections.first?.questions.count else {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.rateCell.rawValue, for: indexPath) as! MainCell
                return cell
            }
            
            let lastRowIndex = count + 1 // count from 0
            
            if indexPath.row != lastRowIndex {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.rateCell.rawValue, for: indexPath) as! RateCell
                
                guard let questions = formModel?.sections.first?.questions else {
                    return cell
                }
                
                cell.delegate = self
                
                let question = questions[indexPath.row - 1]
                cell.titleLabel.text = question.title
                cell.questionId = question.id
                
                if indexPath.row == questions.count {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: myTableView.frame.width)
                } else {
                    cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }
                
                return cell
            } else {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.formSubmitCell.rawValue, for: indexPath) as! FormSubmitCell
                cell.mainView.backgroundColor = .clear
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: myTableView.frame.width)
                cell.delegate = self
                cell.submitButton.isUserInteractionEnabled = true
                cell.submitButton.backgroundColor = .systemBlue
                cell.selectionStyle = .none
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = "Please slide to choose the number that best describes how you feel NOW:"
        let v = TableViewUtilities.addTextToHeaderSection(text: headerTitle, tableView: myTableView, xOffset: 20.0, yOffset: 5.0, labelHeight: 50.0, size: 17.0)
        return v
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}

extension EdmontonSymptonViewController:
            RateCellProtocol,
            FormMetadataCellDelegate,
            FormSubmitCellDelegate {
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
    
    func getSelectedLevel(level: String, questionId: Int) {
        guard let formModel = formModel else {
            return
        }
        
        if let index = formModel.sections[0].questions.firstIndex(where: {$0.id == questionId}) {
            self.formModel?.sections[0].questions[index].answer = level
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
            formModel.sections[0].questions.forEach {
                let item = SubmitQuestion(questionId: $0.id, answer: $0.answer ?? "0")
                questionResults.append(item)
            }
        }
        
        let submitData = SubmitModel(patientID: patientId, totalScore: totalScore, interactiveFormId: formModel.id, assessmentDate: createdOn, questionResults: questionResults)
        
        viewModel.submitFormAnswerToAPI(submitData: submitData, token: token)
    }
}
