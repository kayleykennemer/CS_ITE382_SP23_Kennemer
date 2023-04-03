//
//  ContentView.swift
//  Photorama
//
//  Created by Kayley Kennemer on 4/3/23.
//

import UIKit
class PhotosViewController: UIViewController{
    @IBOutlet private var imageView: UIImageView!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        store.fetchInterestingPhotos{
            (photoResult) in
            
            switch photoResult {
            case let .success(photos):
                print("successfully found \(photos.count) photos.")
            case let .failure(error):
                print("Error fetching interesting photos: \(error)")
            }
            if let firstPhoto = photo.first{
                seld.updateImageView(for: firstPhtoto)
            }
        }
    }
}
class Photo: Codable{
    let title: String
    let remouteURL: URL
    let photoID: String
    let dateTaken: Date
}

struct FlickrResponse: Codable{
    let photos: [Photo]
    enum CodingKeys: String, CodingKey{
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "dateTaken"
    }
}
enum EndPoint: String{
    case interestingPhotos = "flickr.interestingness.getList"
}

private static let baseUrLString = "https://api.flickr.com/services/rest"
private static func flickrURL(endPoint: EndPoint, parameters: [String:String]?) -> URL{
    return URL(string: "")
}

static var interestingPhotosURL(endPoint: EndPoint, parameterd: [String:String]?) -> URL{
    var components - URLComponents(string:baseURLString)!
    var queryItems = [URLQueryItem]()
    
    if let additionalParams = parameters{
        for (key, value) in additionalParams{
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
    }
    components.queryItems = queryItems
    
    return components.url!
}

private static let apiKey = "a6d819499131071f158fd740860a5a88"

let baseParams = [
    "method": endPoint.rawValue,
    "format": "json",
    "nojsoncallback": "1",
    "api_key": apiKey
]

for (key, value) in baseParams {
    let item = URLQueryItem(name: key, value: value)
    queryItems.append(item)
}

private let session: URLSession = {
    let config = URLSessionConfiguration.default
    return URLSession(configuration: config)
}()

private func processPhotosRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
    guard let imageDAta = data,
          let image = UIImage(data: imageData) else{
        if data == nil{
            return .failure(error!)
        }else{
            return .failure(PhotoError.imageCreationError)}
        }
    return .success(image)
    }

func fetchInterestingPhotos(completion:@escaping (Result <[Photo], Error>) -> Void){
    let url = FlickrAPI.interestingPhotosURL
    let request = URlRequest(url: url)
    let task = session.dataTask(with: request){
        (data, response, error) in
        
        let result = self.processPhotoRequest(data: data, error: error)
        completion(result)
    }
        task.resume()
}

var store: PhotoStore!

let rootViewController = window!.rootViewController as! UINavigationController
let photosViewController = rootViewController.topViewController as! PhotosViewController
photosViewController.store = PhotoStore()

array(JSon){
    "name": "christian",
    "job":{
        "company": "Athens State University",
        "title": "Gloriuse Instructor and Dr. of Evil"
    }
}

static func photos(fromJSON data: Data) -> Result<[Photo], Error>{
    do{
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFormGMT: 0)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
        let photos = flickrResponse.photosInfo.photos.filter {
            $0.remoteURL != nil
        }
        return.success(photos)
    } catch{
        return.failure(error)
    }
}

enum PhotoError: Error {
    case imageCreationError
    case missingImageURL
}

func fetchImage (for photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void) {
    guard let photoURL = photo.remoteURL else {
        completion(.failure(PhotoError.missingImageURL))
        return
    }
    let request = URLRequest(url: photoURL)
    
    let task = session.dataTask(with: request){
        (data, response, error)
    }
    task.resume()
}

func updateImageView (for photo: Photo){
    store.fetchImage(for: photo){
        (imageResult) in
        
        switch imageResult{
        case let .success(image): self.imageView.image = image
        case let .failure(error): print("Error downloading image: \(error)")
        }
    }
}
