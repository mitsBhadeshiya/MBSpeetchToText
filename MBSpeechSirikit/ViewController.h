//
//  ViewController.h
//  MBSpeechSirikit
//
//  Created by Mitul Bhadeshiya on 18/11/17.
//  Copyright © 2017 Abc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>


@interface ViewController : UIViewController <SFSpeechRecognizerDelegate>
{
    IBOutlet UITextView *txtSpeech;
    IBOutlet UIButton *btnRecord;
    
    
}

@end

