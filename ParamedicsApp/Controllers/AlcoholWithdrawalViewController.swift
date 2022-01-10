//
//  AlcoholWithdrawalViewController.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-11-13.
//

import UIKit

class AlcoholWithdrawalViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    private let viewModel = ViewModel()
    private var error: OpenNewError?
    private var formModel: AssessmentForm?
    public var formMetaData = [FormMetaData]()
    public var questionResults = [SubmitQuestion]()
    private var submitRequestStatusCode: Int?
    private var numberOfQuestionSection = 0
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
            
            if statusCode == 200, let self = self, let formModel = self.formModel {
                DispatchQueue.main.async {
                    let message = "\(formModel.title) has been successfully submitted"
                    let actionTitle = "OK"
                    AlertUtilities.showAlert1(self: self, tableView: self.myTableView, title: AlertUtilities.title2, message: message, actionTitle: actionTitle, action: self.afterDoneSubmittingAction)
                }
            }
        }
        
    }
    
    func tableViewCellRegister() {
        myTableView.register(UINib(nibName: "FormMetadataCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.formMetadataCell.rawValue)
        myTableView.register(UINib(nibName: "WithdrawalCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.withdrawalCell.rawValue)
        myTableView.register(UINib(nibName: "TextViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifiers.textViewCell.rawValue)
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

extension AlcoholWithdrawalViewController: UITableViewDelegate {

    
}

extension AlcoholWithdrawalViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.formModel {
            return 3
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
           // for formMetaData cell
           return 1
        } else if section == 1 {
            // for a section that might contain all the questions
            return formModel?.sections[0].questions.count ?? 0
        } else {
            // last section for formSubmit cell
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.formMetadataCell.rawValue, for: indexPath) as! FormMetadataCell
            cell.mainView.backgroundColor = .clear
            cell.data = formMetaData
            cell.delegate = self
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: myTableView.frame.width)

            return cell
        } else if (indexPath.section == 1) {
            let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.withdrawalCell.rawValue, for: indexPath) as! WithdrawalCell
            
            guard let questions = formModel?.sections.first?.questions else {
                return cell
            }

            let question = questions[indexPath.row]
            let items = question.content.items
            let description = question.content.description
            
            
            if let description = description, description.contains("<strong>Procedure</strong>") {
                let cell = myTableView.dequeueReusableCell(withIdentifier: cellIdentifiers.textViewCell.rawValue, for: indexPath) as! TextViewCell
                
                cell.textView.attributedText = description.htmlToAttributedString
                cell.textView.font = .systemFont(ofSize: 15)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: myTableView.frame.width)
                
                return cell
            } else {
                
                let currentArrangeSubviews = cell.stackView.arrangedSubviews
                if currentArrangeSubviews.count > 0 {
                    currentArrangeSubviews.forEach {
                        $0.removeFromSuperview()
                    }
                }
                items.forEach {
                    let view = MyClass.instanceFromNib(nibView: "RateView") as! RateView
                    view.valueLabel.text = "\($0.value)"
                    view.titleLabel.text = $0.description
                    view.rate = "\($0.value)"
                    view.delegate = self
                    view.questionId = question.id

                    if $0.description == "" {
                        view.hyphenLabel.isHidden = true
                    }
                    
                    if let answer = question.answer, Int(answer) == $0.value {
                        view.radioIconImage.image = UIImage(systemName: "checkmark.circle.fill")
                    } else {
                        view.radioIconImage.image = UIImage(systemName: "circle")
                    }
                    
                    cell.stackView.addArrangedSubview(view)
                }
                cell.titleLabel.text = question.title
                cell.descriptionLabel.text = description
                return cell
            }
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension AlcoholWithdrawalViewController:
            RateViewDelegate,
            FormSubmitCellDelegate,
            FormMetadataCellDelegate {
    
    func getRateFromCell(_ rate: String, _ questionId: Int, _ rateView: RateView) {
        guard let formModel = formModel else { return }
        if let index = formModel.sections.first?.questions.firstIndex(where: {$0.id == questionId}) {
            self.formModel?.sections[0].questions[index].answer = rate
            myTableView.reloadData()
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
        guard let formModel = formModel, let token = token else { return }
        
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
