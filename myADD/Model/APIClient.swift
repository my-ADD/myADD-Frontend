//
//  APIClient.swift
//  myADD
//
//  
//
import Foundation
import Alamofire

class APIClient {

    // MARK: -  포토카드 전체 목록 조회 (기록순)
    func getListAll(completion: @escaping (Result<[Card], Error>) -> Void) {
        let url = APIEndpoint.getListAllURL
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: APIResponse<[Card]>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    if let resultData = apiResponse.result {
                        print("getListAll GET 성공")
                        completion(.success(resultData))
                    } else {
                        print("Received result is null for getListAll")
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Received result is null for getListAll"])))
                    }
                } else {
                    let error = NSError(domain: "", code: apiResponse.code, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    print("API Error: \(apiResponse.message)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }

    
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
    //
    //        }
    
    // MARK: - OTT 플랫폼 선택 및 카테고리에 따른 포토카드 리스트 조회 (기록순)
    
    func categoryList(category: String, platform: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        
        let url = APIEndpoint.categoryListURL
        
        // 인코딩할 파라미터들
        let parameters: [String: Any] = [
            "category": category,
            "platform": platform
        ]

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseDecodable(of: APIResponse<[Card]>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    if let resultData = apiResponse.result {
                        print("categoryList GET 성공")
                        completion(.success(resultData))
                    } else {
                        print("Received result is null for categoryList")
                        completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Received result is null for categoryList"])))
                    }
                } else {
                    let error = NSError(domain: "", code: apiResponse.code, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    print("API Error: \(apiResponse.message)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }


                
    // MARK: - 포토카드 등록
    
    func addCard(image: UIImage?, card: Card, completion: @escaping (Result<APIResponse<EmptyResult>, Error>) -> Void) {
        let url = APIEndpoint.addCardURL

        AF.upload(multipartFormData: { (multipartFormData) in
            let cardData: [String: Any] = [
                "startedAt": card.startedAt ?? "시청 시작일",
                "endedAt": card.endedAt ?? "시청 종료일",
                "comment": card.comment ?? "",
                "title": card.title ?? "",
                "memo": card.memo ?? "",
                "category": card.category?.rawValue ?? "애니메이션",
                "views": card.views ?? 0,
                "genre": card.genre ?? "",
                "platform": card.platform ?? "넷플릭스",
                "emoji": card.emoji ?? ""
            ]

            do {
                let cardJSONData = try JSONSerialization.data(withJSONObject: cardData, options: [])
                multipartFormData.append(cardJSONData, withName: "post", mimeType: "application/json")
            } catch let error {
                print("JSONSerialization error: \(error.localizedDescription)")
            }

            // Resize the UIImage and convert it to Data
            if let actualImage = image,
               let resizedImage = actualImage.resizeWithWidth(width: 700),
               let imageData = resizedImage.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            } else {
                multipartFormData.append(Data(), withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                print("No image or error converting UIImage to Data.")
            }

        }, to: url, method: .post).responseDecodable(of: APIResponse<EmptyResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    print("addCard POST 성공")
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(domain: "", code: apiResponse.code, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    print("API Error: \(apiResponse.message)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }


        
    // MARK: -  포토카드 수정
    func updateCard(postId: Int, image: UIImage?, card: Card, completion: @escaping (Result<APIResponse<EmptyResult>, Error>) -> Void) {

        let url = APIEndpoint.updateCardURL + "?postId=\(postId)"
        
        AF.upload(multipartFormData: { (multipartFormData) in
            let cardData: [String: Any] = [
                "startedAt": card.startedAt ?? "시청 시작일",
                "endedAt": card.endedAt ?? "시청 종료일",
                "comment": card.comment ?? "",
                "title": card.title ?? "",
                "memo": card.memo ?? "",
                "category": card.category?.rawValue ?? "애니메이션",
                "views": card.views ?? 0,
                "genre": card.genre ?? "",
                "platform": card.platform ?? "넷플릭스",
                "emoji": card.emoji ?? "🙂"
            ]
            do {
                let cardJSONData = try JSONSerialization.data(withJSONObject: cardData, options: [])
                multipartFormData.append(cardJSONData, withName: "post", mimeType: "application/json")
            } catch let error {
                print("JSONSerialization error: \(error.localizedDescription)")
            }

            // Resize the UIImage and convert it to Data
            if let actualImage = image,
               let resizedImage = actualImage.resizeWithWidth(width: 700),
               let imageData = resizedImage.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            } else {
                multipartFormData.append(Data(), withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                print("No image or error converting UIImage to Data.")
            }

        }, to: url, method: .put).responseDecodable(of: APIResponse<EmptyResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    print("updateCard PUT 성공")
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(domain: "", code: apiResponse.code, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    print("API Error: \(apiResponse.message)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 포토카드 삭제
    
    func deleteCard(postId: Int, completion: @escaping (Result<APIResponse<EmptyResult>, Error>) -> Void) {
        let url = APIEndpoint.deleteCardURL + "?postId=\(postId)"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .delete, headers: headers).responseDecodable(of: APIResponse<EmptyResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    print("DELETE 성공")
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(domain: "", code: apiResponse.code, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    print("API Error: \(apiResponse.message)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - 캘린더

    func getCalendar(createdAt: String, completion: @escaping (Result<[Card], Error>) -> Void) {
        let url = APIEndpoint.calendarURL + "?createdAt=\(createdAt)"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        print("CreatedAt parameter: \(createdAt)")

        AF.request(url, method: .get, headers: headers).responseDecodable(of: APIResponse<[Card]>.self) { response in
            print("Received data: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No data")")

            switch response.result {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    print("getcalendar GET 성공")
                    completion(.success(apiResponse.result ?? []))
                } else {
                    let error = NSError(domain: "", code: apiResponse.code, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    print("API Error: \(apiResponse.message)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func getCreatedAt(completion: @escaping (Result<APIResponse<[String]>, Error>) -> Void) {
        let url = APIEndpoint.getCreatedAtURL
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: APIResponse<[String]>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    print("getCreatedAt GET 성공")
                    completion(.success(apiResponse))
                } else {
                    let error = NSError(domain: "", code: apiResponse.code, userInfo: [NSLocalizedDescriptionKey: apiResponse.message])
                    print("API Error: \(apiResponse.message)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Image Resize

extension UIImage {
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}

