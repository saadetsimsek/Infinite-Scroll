//
//  APICaller.swift
//  InfiniteScroll
//
//  Created by Saadet Şimşek on 05/08/2024.
//

import Foundation

final class APICaller {
   
    static let shared = APICaller()
    
    public private(set) var models = [String]()
    
    private init(){
        
    }
    
    func fetchData(completion: @escaping([String]) -> Void){
        DispatchQueue.global().asyncAfter(deadline: .now()+2) { [weak self] in //kodun belirli bir süre (2 saniye) sonra arka planda çalışmasını sağlar.
            self?.models = Array(1...20).map {"Book \($0)"}
            completion(self?.models ?? [])
        }
    }
    
    func loadMorePosts(completion: @escaping ([String]) -> Void){
        DispatchQueue.global().asyncAfter(deadline: .now()+2) { [weak self] in
            guard let strongSelf  = self, 
                    let last = strongSelf.models.last else {
                return
            }
            let number = Int(last.components(separatedBy: " ").last!)!
            let start = number + 1
            let end = start + 20
            let newData = Array(start...end).map {"Book \($0)"}
            strongSelf.models.append(contentsOf: newData)
            completion(self?.models ?? [])
        }
    }
    
}
