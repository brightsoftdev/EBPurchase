//
//  ViewController.m
//  EBPurchase-Demo
//
//  Created by Dave Wooldridge, Electric Butterfly, Inc.
//  Copyright (c) 2012 Electric Butterfly, Inc. - http://www.ebutterfly.com/
//

#import "ViewController.h"


// REPLACE THIS VALUE WITH YOUR OWN IN-APP PURCHASE PRODUCT ID.

#define SUB_PRODUCT_ID @"Your.IAP.Product.ID"

// ALSO ADD THE RELATED PARENT APP BUNDLE IDENTIFIER TO THE INFO PLIST.


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // Create an instance of EBPurchase.
    demoPurchase = [[EBPurchase alloc] init];
    demoPurchase.delegate = self;

    
    isPurchased = NO; // default.
}

-(void) viewWillAppear:(BOOL)animated
{   
    buyButton.enabled = NO; // Only enable after populated with IAP price.
    
    // Request In-App Purchase product info and availability.
    
    if (![demoPurchase requestProduct:SUB_PRODUCT_ID]) 
    {
        // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
        
        [buyButton setTitle:@"Purchase Disabled in Settings" forState:UIControlStateNormal];
    }
}


-(IBAction)purchaseProduct 
{
    // First, ensure that the SKProduct that was requested by
    // the EBPurchase requestProduct method in the viewWillAppear 
    // event is valid before trying to purchase it.
    
    if (demoPurchase.validProduct != nil) 
    {
        // Then, call the purchase method.
        
        if (![demoPurchase purchaseProduct:demoPurchase.validProduct]) 
        {
            // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
            UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before making this purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [settingsAlert show];
            [settingsAlert release];
        }
    }
}

-(IBAction)restorePurchase 
{
    // Restore a customer's previous non-consumable or subscription In-App Purchase.
    // Required if a user reinstalled app on same device or another device.
    
    // Call restore method.
    if (![demoPurchase restorePurchase]) 
    {
        // Returned NO, so notify user that In-App Purchase is Disabled in their Settings.
        UIAlertView *settingsAlert = [[UIAlertView alloc] initWithTitle:@"Allow Purchases" message:@"You must first enable In-App Purchase in your iOS Settings before restoring a previous purchase." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [settingsAlert show];
        [settingsAlert release];
    }
}


#pragma mark -
#pragma mark EBPurchaseDelegate Methods

-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription 
{
    NSLog(@"ViewController requestedProduct");
    
    if (productPrice != nil) 
    {
        // Product is available, so update button title with price.
        
        [buyButton setTitle:[@"Buy Game Levels Pack " stringByAppendingString:productPrice] forState:UIControlStateNormal];
        buyButton.enabled = YES; // Enable buy button.
        
    } else {
        // Product is NOT available in the App Store, so notify user.
        
        buyButton.enabled = NO; // Ensure buy button stays disabled.
        [buyButton setTitle:@"Buy Game Levels Pack" forState:UIControlStateNormal];
        
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"This In-App Purchase item is not available in the App Store at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unavailAlert show];
        [unavailAlert release];
    }
}

-(void) successfulPurchase:(EBPurchase*)ebp identifier:(NSString*)productId receipt:(NSData*)transactionReceipt 
{
    NSLog(@"ViewController successfulPurchase");
    
    // Purchase or Restore request was successful, so...
    // 1 - Unlock the purchased content for your new customer!
    // 2 - Notify the user that the transaction was successful.
    
    if (!isPurchased) 
    {
        // If paid status has not yet changed, then do so now. Checking 
        // isPurchased boolean ensures user is only shown Thank You message 
        // once even if multiple transaction receipts are successfully 
        // processed (such as past subscription renewals).
        
        isPurchased = YES;
                
        //-------------------------------------
        
        // 1 - Unlock the purchased content and update the app's stored settings.

        //-------------------------------------

        // 2 - Notify the user that the transaction was successful.
        
        UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:@"Your purhase was successful and the Game Levels Pack is now unlocked for your enjoyment!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [updatedAlert show];
        [updatedAlert release];
    }
    
}

-(void) failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage 
{
    NSLog(@"ViewController failedPurchase");
    
    // Purchase or Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Stopped" message:@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    [failedAlert release];
}

-(void) incompleteRestore:(EBPurchase*)ebp 
{
    NSLog(@"ViewController incompleteRestore");
    
    // Restore queue did not include any transactions, so either the user has not yet made a purchase
    // or the user's prior purchase is unavailable, so notify user to make a purchase within the app.
    // If the user previously purchased the item, they will NOT be re-charged again, but it should 
    // restore their purchase. 
    
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:@"Restore Issue" message:@"A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [restoreAlert show];
    [restoreAlert release];
}

-(void) failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage 
{
    NSLog(@"ViewController failedRestore");
    
    // Restore request failed or was cancelled, so notify the user.

    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Restore Stopped" message:@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact the app's customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    [failedAlert release];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    buyButton = nil;
}

- (void)dealloc
{
    // Release the EBPurchase instance and delegate.
    demoPurchase.delegate = nil;
    [demoPurchase release];
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
