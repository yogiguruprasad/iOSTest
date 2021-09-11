//
//  FriendsViewModel.swift
//  iOSTest
//
//  Created by Diksha on 04/09/21.
//

import Foundation

class FriendsViewModel {
    var friendDataModel:FriendsList?
    
    func getFriendsList(callback:Callback<FriendsList,String>) {
        NetworkManager.sharedInstance().makeAPICall(url: ConfigureURL.LOGIN, modelObject: FriendsList.self, params: ["results":"10"], method: .get, callback: Callback(onSuccess: { response in
            self.friendDataModel = response
            callback.onSuccess(response)
        }, onFailure: { error in
            callback.onFailure(error)
        }))
        
        
//        let requestDispatcher = APIRequestDispatcher(environment: APIEnvironment.production, networkSession: APINetworkSession())
//        let bookCreationRequest = FriendsEndpoint.index
//        let bookOperation = APIOperation(bookCreationRequest)
//        bookOperation.execute(in: requestDispatcher) { result in
//            switch result {
//            case .json(result: let responseData):
//                let data = try? JSONSerialization.data(withJSONObject: responseData as Any, options: .prettyPrinted)
//                self.friendDataModel = try! JSONDecoder().decode(FriendsList.self, from: data!)
//                callback.onSuccess(self.friendDataModel!)
//            case .error:
//                callback.onFailure("Fail to load data")
//            case .file(fileURL: _): break
//
//            }
//        }
    }
}
