//
//  NetworkRequestService.swift
//  ParamedicsApp
//
//  Created by Ty Nguyen on 2021-10-09.
//

import Foundation

enum OpenNewError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
    case unavailabeInternet
}

class NetworkingServices {
    typealias getAssessmentFolderCompletion = ([AssessmentFolderModel]?, OpenNewError?) -> ()
    typealias postRequestForInteractiveFormCompletion = (Int?, OpenNewError?) -> ()
    typealias getAssessmentFormCompletion = (AssessmentForm?, OpenNewError?) -> ()
    typealias getResourcesCompletion = ([Region]?, OpenNewError?) -> ()
    typealias signInCompletion = ([String : Any]?, OpenNewError?) -> ()
    typealias getUserProfileCompletion = (UserProfile?, OpenNewError?) -> ()
    
    private static let host = "8754-38-117-113-17.ngrok.io"
    private static let scheme = "http"
    
    static func getAssessmentFolders(completion: @escaping getAssessmentFolderCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = scheme
        urlBuilder.host = host
        urlBuilder.path = "/Folders"
        
        let url = urlBuilder.url!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from ParamedicsAPI: \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data returned from ParamedicsAPI")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable to process ParamedicsAPI response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failure response from Paramedics: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    
                    let decodedData = try decoder.decode([AssessementFolder].self, from: data)

                    let assessmentFolders: [AssessmentFolderModel] = decodedData.map {
                        AssessmentFolderModel(id: $0.id, title: $0.title, forms: $0.forms.map {
                            FormModel(id: $0.id, title: $0.title)
                        })
                    }
                    
                    completion(assessmentFolders, nil)
                    
                } catch {
                    print("Unable to decode ParamedicsAPI response: \(error)")
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
    
    // for all forms
    static func getAssessmentForm(_ formId: Int, _ fullName: String, completion: @escaping getAssessmentFormCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = scheme
        urlBuilder.host = host
        urlBuilder.path = "/InteractiveForms/\(formId)"
        
        let url = urlBuilder.url!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from ParamedicsAPI: \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data returned from ParamedicsAPI")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable to process ParamedicsAPI response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failure response from Paramedics: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    
                    let decodedData = try decoder.decode(AssessmentFormDecodable.self, from: data)
                    
                    let paramedics = fullName
                    let now = DateTimeUtilities.getCurrentDateTime()
                    
                    let formData = AssessmentForm(id: decodedData.id, title: decodedData.title, paramedics: paramedics, date: now, hasScoring: decodedData.hasScoring,
                        sections: decodedData.sections.map {
                        Section(
                            name: $0.name,
                            questions: $0.questions.map {
                                Question(
                                    id: $0.id,
                                    type: $0.type,
                                    title: $0.title,
                                    content: Content(
                                        items: $0.content.items.map {
                                            Item(
                                                description: $0.description,
                                                value: $0.value
                                            )
                                        },
                                        description: $0.content.description,
                                        max_score: $0.content.max_score))
                            })
                    })
                    
                    completion(formData, nil)
                    
                } catch {
                    print("Unable to decode ParamedicsAPI response: \(error)")
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
    
    static func submitFormAnswersToAPI(submitData: SubmitModel, token: String, completion: @escaping postRequestForInteractiveFormCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = scheme
        urlBuilder.host = host
        urlBuilder.path = "/Assessments"
        
        let url = urlBuilder.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let encoder = JSONEncoder()
            
            encoder.outputFormatting = .prettyPrinted
            
            let jsonData = try encoder.encode(submitData)
            
            request.httpBody = jsonData
            
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString!)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard error == nil else {
                    print("Failed post data to ParamedicsAPI: \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let _ = data else {
                    print("No data returned from ParamedicsAPI")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable to process ParamedicsAPI response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failure response from ParamedicsAPI: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                completion(response.statusCode, nil)
            
            }
            task.resume()
        } catch {
            print("Unable to encode SubmitModel object: \(error)")
            completion(nil, .invalidData)
        }
    }
    
    static func getResources(completion: @escaping getResourcesCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = scheme
        urlBuilder.host = host
        urlBuilder.path = "/ResourceRegions"
        
        guard let url = urlBuilder.url else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from ParamedicsAPI: \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data returned from ParamedicsAPI")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable to process ParamedicsAPI response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failure response from Paramedics: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    
                    let decodedData = try decoder.decode([RegionDecodable].self, from: data)
                    
                    let regionData = decodedData.map {
                        Region(
                            id: $0.id,
                            name: $0.name,
                            resources: $0.resources.map {
                                Resource(id: $0.id, name: $0.name, location: $0.location, logo: $0.logo, websiteURL: $0.websiteURL, contacts: $0.contacts?.map {
                                    Contact(id: $0.id, name: $0.name, title: $0.title, phone: $0.phone, ext: $0.ext, fax: $0.fax, email: $0.email)
                                  })
                        })
                    }
                    
                    completion(regionData, nil)
                    
                } catch {
                    print("Unable to decode ParamedicsAPI response: \(error)")
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
    
    static func signIn(_ username: String, _ password: String, completion: @escaping signInCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = scheme
        urlBuilder.host = host
        urlBuilder.path = "/Accounts/login"
        
        guard let url = urlBuilder.url else { return }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let loginStr = "{\"email\": \"\(username)\", \"password\": \"\(password)\"}"
        
        print("submitData: \(loginStr)")
    
        let jsonData = Data(loginStr.utf8)
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed request from ParamedicsAPI: \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data return from ParamedicsAPI")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable to process ParamedicsAPI response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failure response from ParamedicsAPI: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    if let tokenInfo = json {
                        completion(tokenInfo, nil)
                    }
                } catch {
                    print("Unable to decode ParamedicsAPI response: \(error)")
                    completion(nil, .invalidData)
                }
            }
        }
        task.resume()
    }
    
    static func getUserProfile(_ token: String, completion: @escaping getUserProfileCompletion) {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = scheme
        urlBuilder.host = host
        urlBuilder.path = "/Accounts/myaccount"
        
        guard let url = urlBuilder.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Failed post data to ParamedicsAPI: \(error!.localizedDescription)")
                completion(nil, .failedRequest)
                return
            }
            
            guard let data = data else {
                print("No data returned from ParamedicsAPI")
                completion(nil, .invalidData)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Unable to process ParamedicsAPI response")
                completion(nil, .invalidResponse)
                return
            }

            guard response.statusCode == 200 else {
                print("Failure response from ParamedicsAPI: \(response.statusCode)")
                completion(nil, .failedRequest)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let userProfile = try decoder.decode(UserProfile.self, from: data)
                
                completion(userProfile, nil)
            } catch {
                print("Unable to decode ParamedicsAPI response: \(error)")
                completion(nil, .invalidData)
            }
        }.resume()
    }
}
