//
//  Session+CoreDataProperties.swift
//  Genre
//
//  Created by Ryan David Forsyth on 2019-10-14.
//  Copyright © 2019 Ryan F. All rights reserved.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var correctCount: Int32
    @NSManaged public var incorrectCount: Int32
    @NSManaged public var gameId: Int32

}
