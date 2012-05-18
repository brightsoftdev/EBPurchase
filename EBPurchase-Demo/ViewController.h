//
//  ViewController.h
//  EBPurchase-Demo
//
//  Created by Dave Wooldridge, Electric Butterfly, Inc.
//  Copyright (c) 2012 Electric Butterfly, Inc. - http://www.ebutterfly.com/
//

#import <UIKit/UIKit.h>

// Import the EBPurchase class.

#import "EBPurchase.h"


@interface ViewController : UIViewController <EBPurchaseDelegate> {
    
    // Assign this class as a delegate of EBPurchaseDelegate.
    // Then add an EBPurchase property.
    
    EBPurchase* demoPurchase;
    
    IBOutlet UIButton *buyButton;
    
    BOOL isPurchased;
}

-(IBAction)purchaseProduct;

-(IBAction)restorePurchase;


@end
