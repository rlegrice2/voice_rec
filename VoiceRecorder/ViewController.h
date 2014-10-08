//
//  ViewController.h
//  VoiceRecorder
//
//  Created by Richard Grice on 5/1/14.
//  Copyright (c) 2014 CS212 richard grice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>

@interface ViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate, AVAudioSessionDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    
   
    NSTimer *recordTimer;
    NSInteger *volume;
    //NSString *filePath;
    //NSArray *countArray;
    NSString *getFile;
    NSURL *url;
    //NSData *selectedSound;

    
}
@property (strong, nonatomic) IBOutlet UIButton *RecordPause;
@property (weak, nonatomic) IBOutlet UIButton *Stop;
@property (weak, nonatomic) IBOutlet UIButton *Play;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (strong, nonatomic) IBOutlet UIPickerView *AudioPicker;
@property (strong, nonatomic) NSArray* pickerData;
@property (strong, nonatomic) NSMutableArray* soundFileArray;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property (nonatomic, retain) NSTimer *recordTimer;
@property (nonatomic, retain) NSString* filename;
@property (readonly) NSString* filePath;
@property(nonatomic, strong)NSString *selectedSound;
//@property (strong, nonatomic) NSURL *url;


- (IBAction)recordPressed:(UIButton *)sender;

- (IBAction)stopPressed:(UIButton *)sender;

- (IBAction)playPressed:(UIButton *)sender;
- (IBAction)volumeChange:(UISlider *)sender;

- (void)recordUpdate;
- (void)playAudioFile:(NSString*)selectAudioFile;


 

@end
