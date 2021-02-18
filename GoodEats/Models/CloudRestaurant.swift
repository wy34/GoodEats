//
//  CloudRestaurant.swift
//  GoodEats
//
//  Created by William Yeung on 2/17/21.
//

import UIKit
import CloudKit

class CloudRestaurant: NSObject {
    var recordId: CKRecord.ID?
    var name: String = ""
    var image: UIImage?
}
