//
//  ViewController.m
//  StopWatch
//
//  Created by Daniel Esposito on 28/Mar/2014.
//  Copyright (c) 2014 Daniel Esposito. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    
    NSTimer *_myTimer;
    NSDate *_currentDate;
    NSDate *_startDate;
    NSDate *_stopDate;
}
@property (weak, nonatomic) IBOutlet UILabel *timerOutputLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   

	
}


- (IBAction)stopTimerPressed:(id)sender {
    
    [self stopTimer];
        // store an start date
}

- (IBAction)startTimerPressed:(id)sender {
    
    [self startTimer];
    
    [self updateDisplayTime];
    
}

- (IBAction)resetTimerPressed:(id)sender {
    NSLog(@"Reset!");
    [self resetTimer];
}

- (void)resetTimer{
    
    [self stopTimer];
    
    // set to nil
        _startDate = nil;
        _stopDate = nil;
        self.timerOutputLabel.text = @"00:00:00.000";


}


//- (void)updateDisplayTime {
//    
//    _currentDate = [NSDate date];
//    
//    NSTimeInterval elapsedSeconds = [_currentDate timeIntervalSinceDate:_startDate];
//    
////    NSLog(@"elapsedSeconds: %f",elapsedSeconds);
//    
//    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    
//    NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    
//    NSDateComponents *elapsedDateComponents = [gregorianCalendar components:unitFlags fromDate:_startDate toDate:_currentDate options:0];
//
//    NSInteger hours = [elapsedDateComponents hour];
//    NSInteger minutes = [elapsedDateComponents minute];
//    NSInteger seconds = [elapsedDateComponents second];
//    
//    // Grab the decimals to the right side of elapsed time
//    double intPart;
//    double milliseconds = modf(elapsedSeconds, &intPart);
//    
//    // s.3 -> intPart = 2.0 milliseconds = 0.3
//    
//    self.timerOutputLabel.text = [NSString stringWithFormat:@"%02d:%02d:%06.3f",hours,minutes,seconds + milliseconds];
//    
//    NSLog(@"self.timeLabel.text = %@",self.timerOutputLabel.text);
//}


- (void)updateDisplayTime {
    _currentDate = [NSDate date];
    
    NSTimeInterval elapsedSeconds = [_currentDate timeIntervalSinceDate:_startDate];
    
    self.timerOutputLabel.text = [self formatTimeInterval:elapsedSeconds];
    
}


-(NSString *)formatTimeInterval:(NSTimeInterval)timeInterval {

    // shift a date using the elapsedSeconds back to 1970
    
    NSDate *startDate1970 = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    NSString *dateString = [dateFormatter stringFromDate:startDate1970];
    
    
    NSLog(@"date: %@", startDate1970);
    return dateString;
}





-(void)startTimer{
    if (!_myTimer) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:0.001 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    
        
            // Store a start date
            if (!_startDate) {
                
                _startDate = [NSDate date];
            }
            else
            {
                // resume
                NSTimeInterval duration = [_stopDate timeIntervalSinceDate:_startDate];
                _startDate = [NSDate dateWithTimeInterval:-duration sinceDate:[NSDate date]];
                
            }
            
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"HH:mm:ss.SSS"];
                NSString *startDateString = [formatter stringFromDate:_startDate];
                NSLog(@"Start: %@", startDateString);
        }
    
}

-(void)stopTimer{
    
    [_myTimer invalidate];
    _myTimer = nil;
    
    if (_startDate) {
        
        // store an stop date
        _stopDate = [NSDate date];
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss.SSS"];
        NSString *stopDateString = [formatter stringFromDate:_stopDate];
        
        NSLog(@"Stop: %@", stopDateString);
        NSLog(@"Stop: %@", [self formatTimeInterval:60 * 60 * 23 + 60 + 23]);
    }
    else if(!_startDate)
    {
        self.timerOutputLabel.text = [NSString stringWithFormat:@"00:00:00.000"];
        
    }
    
    if (!_startDate && !_stopDate) {
        
        self.timerOutputLabel.text = [NSString stringWithFormat:@"00:00:00.000"];
        
    }else if (!_startDate || !_stopDate){
        
        [self updateDisplayTime];
    }
}

- (void)updateTime:(NSTimer *)timer{
    _currentDate = [NSDate date];
//    NSLog(@"Date: %@ - %@", _currentDate, timer);
    
    [self updateDisplayTime];
}

@end
