//
//  FirstViewController.h
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IRInterpreter.h"
@interface FirstViewController : UIViewController
{
    //the uitextview into which users type their code
    IBOutlet UITextView *input;
    
    
    //a file handle passed to IRInterpreter; communication
    NSFileHandle *fileHandle;
    NSPipe *pipe;
    
    UITextView *output;
}
@property (nonatomic, retain) IBOutlet UITextField *output;
@property (nonatomic, retain) IBOutlet UITextView *input;
-(IBAction)runCode:(id)sender;
@end
