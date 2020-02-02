//
//  MeetingCell.swift
//  BicycleRide
//
//  Created by Daniel BENDEMAGH on 04/01/2020.
//  Copyright © 2020 Daniel BENDEMAGH. All rights reserved.
//

import UIKit

class MeetingCell: UITableViewCell {

    @IBOutlet weak var meetingName: UILabel!
    @IBOutlet weak var meetingDate: UILabel!
    @IBOutlet weak var meetingTime: UILabel!
    @IBOutlet weak var meetingImage: UIImageView!
    @IBOutlet weak var meetingCity: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(meeting: Meeting) {
        meetingName.text = meeting.name
        //let dateTime = meeting.timeStamp.date()
        meetingDate.text = meeting.timeStamp.date()
        //meetingTime.text = meeting.time
        meetingCity.text = meeting.city
        if meeting.bikeType == "Route" {
            meetingImage.image = UIImage(named: "BicycleRoad")
        } else {
            meetingImage.image = UIImage(named: "BicycleVTT")
        }
    }
}
