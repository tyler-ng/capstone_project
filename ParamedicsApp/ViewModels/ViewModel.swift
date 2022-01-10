//
//  ViewModel.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-09.
//

import Foundation

public class ViewModel {
    
    var errorStore: Box<OpenNewError?> = Box(nil)
    var assessFoldersStore: Box<[AssessmentFolderModel]?> = Box(nil)
    var submittingAnswerResultStore: Box<Int?> = Box(nil)
    var assessmentFormStore: Box<AssessmentForm?> = Box(nil)
    var resourcesStore: Box<[Region]?> = Box(nil)
    var tokenStore: Box<[String: Any]?> = Box(nil)
    var userProfileStore: Box<UserProfile?> = Box(nil)
    
    func initialDataFetching(_ token: String) {
        
        var errorResponse: OpenNewError?
        var assessmentFolderResponse: [AssessmentFolderModel]?
        var userProfileResponse: UserProfile?
        
        let myGroup = DispatchGroup()
        
        [0, 1].forEach {
            myGroup.enter()
            
            if $0 == 0 {
                // request for getting assessment folders
                NetworkingServices.getAssessmentFolders() { (assessmentFolders, error) in
                    if let error = error {
                        errorResponse = error.self
                    }
                    
                    if let assessmentFolders = assessmentFolders {
                        assessmentFolderResponse = assessmentFolders
                    }
                    
                    myGroup.leave()
                }
            } else {
                // request for getting user profile
                NetworkingServices.getUserProfile(token) { (userProfile, error) in
                    if let error = error {
                        errorResponse = error.self
                    }
                    
                    if let userProfile = userProfile {
                        userProfileResponse = userProfile
                    }
                    
                    myGroup.leave()
                }
            }
        }
        
        // all network requests are ended
        myGroup.notify(queue: .main) {
            print("Finish all requests")
            if let error = errorResponse {
                self.errorStore.value = error
            }
            
            if let assessmentFolder = assessmentFolderResponse {
                self.assessFoldersStore.value = assessmentFolder
            }
            
            if let userProfile = userProfileResponse {
                self.userProfileStore.value = userProfile
            }
        }
        
    }
    
    func getAssessmentFormById(formId: Int, fullName: String) {
        NetworkingServices.getAssessmentForm(formId, fullName) {[weak self] (clientFallRiskForm, error) in
            if let error = error {
                self?.errorStore.value = error.self
                return
            }
            
            guard let self = self,
                  let clientFallRiskForm = clientFallRiskForm
            else {
                return
            }
            
            self.assessmentFormStore.value = clientFallRiskForm
        }
    }
    
    func submitFormAnswerToAPI(submitData: SubmitModel, token: String) {
        NetworkingServices.submitFormAnswersToAPI(submitData: submitData, token: token) {[weak self] (statusCode, error) in
            if let error = error {
                self?.errorStore.value = error.self
                return
            }
            
            guard let self = self,
                  let statusCode = statusCode
            else {
                return
            }
            
            self.submittingAnswerResultStore.value = statusCode
        }
    }
    
    func getResourceFromAPI() {
        NetworkingServices.getResources() {[weak self] (regions, error) in
            if let error = error {
                self?.errorStore.value = error.self
                return
            }
            
            guard let self = self,
                  let regions = regions
            else {
                return
            }
            
            self.resourcesStore.value = regions
        }
    }
    
    func userSignInToAPI(_ username: String, _ password: String) {
        NetworkingServices.signIn(username, password) {[weak self] (tokenInfo, error) in
            if let error = error {
                self?.errorStore.value = error
                return
            }
            
            guard let self = self, let tokenInfo = tokenInfo else {
                return
            }
            
            self.tokenStore.value = tokenInfo
        }
    }
}
