//
//  ViewController.m
//  VoiceRecorder
//
//  Created by Richard Grice on 5/1/14.
//  Copyright (c) 2014 CS212 richard grice. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
{
    AVAudioPlayer *myPlayer;
    AVAudioRecorder *myRecorder;
    //just added <-------
    UIPickerView *AudioPicker;
    
    
}

@end

@implementation ViewController

@synthesize recordTimer = _recordTimer,RecordPause = _recordPause, Stop = _Stop, Play = _Play, label = _Label, volumeSlider = _volumeSlider, AudioPicker = _AudioPicker, pickerData = _pickerData, soundFileArray = _soundFileArray, selectedSound = _selectedSound, audioPlayer = _audioPlayer;
//@synthesize fileArray;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Disable stop and play buttons when application launches
    [_Stop setEnabled:NO];
    [_Play setEnabled:NO];
    
    //Add AudioPickerView
    AudioPicker.delegate = self;
    AudioPicker.dataSource = self;
    [self.AudioPicker reloadAllComponents];

    
    // set up audio file with paths

//     NSArray *pathComponents = [NSArray arrayWithObjects:
//     [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"MyAudioMemo.m4a",nil];
    
    
     
    NSFileManager *fileManager = [NSFileManager defaultManager];
    _soundFileArray = [[NSMutableArray alloc] init];
    

    NSArray *pathComponents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *docDir = [pathComponents objectAtIndex:0];
//------------> CREATING URL PATH FOR AUDIOPLAYER    <--------------------
    //NSURL *url = [NSURL fileURLWithPathComponents:selectedSound];
    if([pathComponents count] > 0) {
   NSString *docDir = [pathComponents objectAtIndex:0];
    
        NSError *error = nil;
        _soundFileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docDir error:&error];
        
        if(error){
            NSLog(@"Failed getting files with error: %@",[error description]);
        }
        NSLog(@"Files are in fact being created...");
        
    
    NSArray *index=[pathComponents lastObject];
    NSLog(@">>>>>>>>>>>>>>>>>>> index=%@",index);
    NSInteger count = [_soundFileArray count];

    //for (int i=2; i<= [pathComponents count]; i++)
    //{
    NSString *filename = [NSString stringWithFormat:@"audio %@.caf",[NSNumber numberWithFloat:count]];
        
        NSLog(@"------> CCCCCCCCCCCounting here , %d",[pathComponents count]);

   

    NSString *filePath = [docDir stringByAppendingPathComponent:filename];
//-----------------------------------------------------------------------
//        NSFileManager *manager=[NSFileManager defaultManager];
//        NSString *path = [pathComponents objectAtIndex:0];      // Presumably this is a valid path?
//        //NSArray *contents = [manager contentsOfDirectoryAtPath:path error:nil];
//        NSUInteger numberOfFiles = [_soundFileArray count];
//        if ([_soundFileArray indexOfObject:@".DS_Store"] != NSNotFound)
//            numberOfFiles--;
//        NSLog(@"Number of files , %d", numberOfFiles);
//-----------------------------------------------------------------------
        
    if ([fileManager fileExistsAtPath:docDir isDirectory:nil])
        NSLog(@"File does exist<--!!, %@", docDir);
    else
        NSLog(@"File not found");
    NSLog(@"______________________________________");
    NSLog(@"----> recorderFileName: %@",filename);
    NSLog(@"----> recorderFilePath <------: %@",filePath);
        
    
    
    //set up/create an audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),&audioRouteOverride);
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    //Initiatize and prepare the recorder
    // myRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    myRecorder =  [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:filePath] settings:recordSetting error:NULL];
        
   _audioPlayer =  [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:&error];
        //NSURL *url = [NSURL fileURLWithPath:_filePath];
    
    myRecorder.delegate = self;
    myRecorder.meteringEnabled = YES;
    [myRecorder prepareToRecord];
    //[myPlayer prepareToPlay];
   
        //[self fileArray];
}

// Creating array of files listed in the url directory path
    
    _pickerData = [[NSMutableArray alloc] init];
    
    if([pathComponents count] > 0) {
        NSString *docDir = [pathComponents objectAtIndex:0];
        NSError *error = nil;
        _pickerData = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docDir error:&error];
        if(error){
            NSLog(@"Failed getting files with error: %@",[error description]);
            
        }
        NSLog(@"Files are indeed listed...");
        NSLog(@"hey is this a count, %d", [pathComponents count]);
        NSLog(@"hey is this another count, %d", [_pickerData count]);
        

    }
    
}


#pragma UIPickerview
// Return AudioPicker components
- (NSInteger)pickerView:(UIPickerView *)AudioPicker numberOfRowsInComponent:(NSInteger)component {
    return [self.soundFileArray count];
    //return 3;
}

// Return AudioPicker components
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)AudioPicker {
    NSLog(@"number of components");
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)AudioPicker titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [self.soundFileArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)AudioPicker didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _selectedSound = [_soundFileArray objectAtIndex: row];
    NSLog(@"did select ---->, @%d", row);
    //[self.pickerData  selectRow:row inComponent:0 animated:YES];
    NSLog(@"---> this file is here? %@", _filePath);
    NSLog(@"---> selectSound, this file name is? <-- %@", self->_selectedSound);
    
    [self playAudioFile:_selectedSound];
    //[myPlayer play];
  
}

#pragma AVControl actions
    // Record and pause button
- (IBAction)recordPressed:(UIButton *)sender {
    if (myPlayer.playing) {
        [_recordPause setBackgroundImage:[UIImage imageNamed:@"Record.png"]forState:UIControlStateNormal];
        [myPlayer stop];
    }
        if (!myRecorder.recording) {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setActive:YES error:nil];
        //start recording
            [myRecorder record];
            [_recordPause setBackgroundImage:[UIImage imageNamed:@"PauseOff.png"]forState:UIControlStateNormal];
            [_recordPause setTitle:@"Pause" forState:UIControlStateNormal];
            
            recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recordUpdate) userInfo:nil repeats:YES];
            NSLog(@"session is recording, %@", recordTimer);
        NSLog(@"----> recorderFilePath <------: %@",_filePath);
    } else {
        
        //pause recording
        [myRecorder pause];
        [_recordPause setBackgroundImage:[UIImage imageNamed:@"Record.png"]forState:UIControlStateNormal];
        [_recordPause setTitle:@"Record" forState:UIControlStateNormal];
    }
            [_Stop setEnabled:YES];
            [_Play setEnabled:NO];
}

- (IBAction)stopPressed:(UIButton *)sender {
    
    [myRecorder stop];
    [myPlayer stop];
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
    NSLog(@"session stopped, %@", _Stop);
    
}

-(void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [_recordPause setBackgroundImage:[UIImage imageNamed:@"Record.png"]forState:UIControlStateNormal];
    [_recordPause setTitle:@"Record" forState:UIControlStateNormal];
    
    [_Stop setEnabled:NO];
    [_Play setEnabled:YES];
}

-(void)playAudioFile:(NSString*)selectAudioFile{

    NSURL *url = [NSURL fileURLWithPath:_filePath];
    
    NSError *error;
    _audioPlayer =  [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",
              [error localizedDescription]);
    } else {
        _audioPlayer.delegate = self;
        //[audioPlayer prepareToPlay];
        [_audioPlayer play];
    }

}

- (IBAction)playPressed:(UIButton *)sender {
    //Check if recorder is not in recording, initialize myPlayer
    //and playback timer
    if (!myRecorder.recording) {
        
        myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:myRecorder.url error:nil];
        
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recordUpdate) userInfo:nil repeats:YES];

    //}else{
        //myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:myPlayer.url //error:nil];
        
        //[AudioPicker selectedRowInComponent:0];
    
        [myPlayer setDelegate:self];
        myPlayer.volume = 1.0;
        //[myPlayer prepareToPlay];
        //[myPlayer setNumberOfLoops:0];
        //
        [myPlayer play];
        
        
        NSLog(@"session is playing, %@", _Play);
        
    }
    [_Stop setEnabled:YES];
    
   
}

- (IBAction)volumeChange:(UISlider *)sender {
    if (myPlayer != nil) {
    
    myPlayer.volume = sender.value;

    }
}
// Function time counter --> selector for NSTimer
- (void) recordUpdate {
    if ([myRecorder isRecording]) {
        float minutes = floorf(myRecorder.currentTime/60);
        float seconds = myRecorder.currentTime - (minutes *60);
        
        NSString *time= [[NSString alloc] initWithFormat:@"%0.0f.%0.0f", minutes, seconds];
        self.label.text = time;
    }else if
         (!myRecorder.recording) {
            float minutes = floorf(myPlayer.currentTime/60);
            float seconds = myPlayer.currentTime - (minutes *60);
            
            NSString *time= [[NSString alloc] initWithFormat:@"%0.0f.%0.0f", minutes, seconds];
            self.label.text = time;

     
        }
    }


@end
