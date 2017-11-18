//
//  ViewController.m
//  MBSpeechSirikit
//
//  Created by Mitul Bhadeshiya on 18/11/17.
//  Copyright © 2017 Abc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    SFSpeechRecognizer *speechRecognizer;
    SFSpeechAudioBufferRecognitionRequest *regRequest;
    SFSpeechRecognitionTask *regTask;
    AVAudioEngine *avEngine;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    NSLocale *locate = [[NSLocale alloc]initWithLocaleIdentifier:@"en-US"];
    speechRecognizer = [[SFSpeechRecognizer alloc]initWithLocale:locate];
    
    avEngine = [[AVAudioEngine alloc]init];
    regRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    regTask =[[SFSpeechRecognitionTask alloc]init];
    
    [btnRecord setEnabled:true];
    txtSpeech.text = @"";
    speechRecognizer.delegate  = self;
    
    //[self getPermissionSpeechRecognizer];
}

-(void)getPermissionSpeechRecognizer{
    
    SFSpeechRecognizerAuthorizationStatus  status =SFSpeechRecognizer.authorizationStatus;
    
    switch (status) {
        case SFSpeechRecognizerAuthorizationStatusAuthorized:{
            [btnRecord setEnabled:true];
            break;
        }
        default:
            [btnRecord setEnabled:false];
            break;
    }
}

-(IBAction)actionRecording:(id)sender
{
    
    if(avEngine.isRunning){
        [avEngine stop];
        [regRequest endAudio];
        [btnRecord setTitle:@"Record" forState:UIControlStateNormal];
        txtSpeech.text = @"";
        
    }else{
        [self startRecording];
        [btnRecord setTitle:@"Stop" forState:UIControlStateNormal];

    }
}


-(void)startRecording
{
    /*if(regTask != nil){
        [regTask cancel];
        regTask = nil;
    } */
    AVAudioSession *avAudioSession = [AVAudioSession sharedInstance];
    
    [avAudioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    [avAudioSession setMode:AVAudioSessionModeMeasurement error:nil];
    [avAudioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    AVAudioInputNode *inputEngineNode = avEngine.inputNode;
    if(!inputEngineNode){
        NSLog(@"sOME ERROR ");
    }
    
    regRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    
    if(!regRequest){
        NSLog(@"SOME ERROR IN REGISTER REQUEST");
    }
    
    regRequest.shouldReportPartialResults = YES;
    
    regTask = [speechRecognizer recognitionTaskWithRequest:regRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        
        BOOL isComplete = false;
        
        if(result != nil){
        
            txtSpeech.text = result.bestTranscription.formattedString;
            isComplete = result.isFinal;
        }
        if(error != nil || isComplete){
            
            [avEngine stop];
            [inputEngineNode removeTapOnBus:0];
            regRequest = nil;
            regTask = nil;
        }
    }];
    
    
    AVAudioFormat *recordingFormat = [inputEngineNode outputFormatForBus:0];
    
    [inputEngineNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [regRequest appendAudioPCMBuffer:buffer];
    }];
    
    [avEngine prepare];
    
    NSError *err ;
    [avEngine startAndReturnError:&err];

}

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available
{
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
