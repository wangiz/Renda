//
//  AppAnalyticsViewController.swift
//  MySampleApp
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.5
//

import UIKit
import AWSMobileAnalytics

class AppAnalyticsViewController: UIViewController {
    
    // MARK:- IBActions
    
    @IBAction func clickedCustomEvent(sender: AnyObject) {
        let eventClient = AWSMobileClient.sharedInstance.mobileAnalytics.eventClient
        let event = eventClient.createEventWithEventType("DemoCustomEvent")
        event.addAttribute("DemoAttributeValue1", forKey: "DemoAttribute1")
        event.addAttribute("DemoAttributeValue2", forKey: "DemoAttribute2")
        event.addMetric(Int((arc4random() % 65535)), forKey: "DemoMetric")
        eventClient.recordEvent(event)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            eventClient.submitEvents()
        })
        
        let alertView = UIAlertController(title: NSLocalizedString("Event Submitted",
            comment: "Title bar for alert dialog about an event."),
            message: event.prettyPrint(),
            preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Button on alert dialog."), style: .Default, handler: nil)
        alertView.addAction(alertAction)
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    @IBAction func clickedMonetizationEvent(sender: AnyObject) {
        
        let eventClient = AWSMobileClient.sharedInstance.mobileAnalytics.eventClient
        let eventBuilder = AWSMobileAnalyticsAppleMonetizationEventBuilder(eventClient: eventClient)
        eventBuilder.withProductId("DEMO_PRODUCT_ID")
        eventBuilder.withItemPrice(1.00, andPriceLocale: NSLocale(localeIdentifier: "en_US"))
        eventBuilder.withQuantity(1)
        eventBuilder.withTransactionId("DEMO_TRANSACTION_ID")
        let event = eventBuilder.build()
        eventClient.recordEvent(event)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            eventClient.submitEvents()
        })
        
        let alertView = UIAlertController(title: NSLocalizedString("Event Submitted",
            comment: "Title bar for alert dialog about an event."),
            message: event.prettyPrint(),
            preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Button on alert dialog."), style: .Default, handler: nil)
        alertView.addAction(alertAction)
        presentViewController(alertView, animated: true, completion: nil)
    }
}

// MARK:- Utility Methods

extension AWSMobileAnalyticsEvent {
    private func prettyPrint() -> String {
        return "EVENT TYPE : \(self.eventType)\nATTRIBUTES : \(self.allAttributes())\nMETRICS : \(self.allMetrics())"
    }
}
