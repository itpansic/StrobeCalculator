//
//  ViewController.m
//  StrobeCalculator
//
//  Created by admin on 2017/8/10.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Additions.h"
#import "commonMacroDefine.h"
#import "StrobeListCtrl.h"

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnStrobeSelect;
@property (weak, nonatomic) IBOutlet UIImageView *ivStrobe;
@property (weak, nonatomic) IBOutlet UILabel *lbStrobeTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbStrobeSubTitle;
@property (weak, nonatomic) IBOutlet UIPickerView *pvAperture;
@property (weak, nonatomic) IBOutlet UIPickerView *pvEv;
@property (weak, nonatomic) IBOutlet UIPickerView *pvShutter;
@property (weak, nonatomic) IBOutlet UIPickerView *pvIso;
@property (weak, nonatomic) IBOutlet UIPickerView *pvFlashEv;
@property (weak, nonatomic) IBOutlet UIButton *btnLock;

@property (weak, nonatomic) IBOutlet UILabel *lbDistance;

@property (strong, nonatomic) NSDictionary *dicStrobeInfo;

//第0档代表F1
@property (assign, nonatomic) float currentStopAperture;
//第0档代表1秒
@property (assign, nonatomic) float currentStopShutter;
//第0档代表ISO 100
@property (assign, nonatomic) float currentStopIso;
//第0档代表EV0
@property (assign, nonatomic) float currentStopFlashEv;

@property (assign, nonatomic) float currentStopEv;
@property (assign, nonatomic) float fDistance;
//步长 1代理 1EV 2代表 1/2EV  3代表1/3EV
@property (assign, nonatomic) int stepPerEv;

//光圈最小步值
@property (assign, nonatomic) int stopBeginAperture;

//光圈最大步值
@property (assign, nonatomic) int stopEndAperture;

//快门最小步值
@property (assign, nonatomic) int stopBeginShutter;

//快门最大步值
@property (assign, nonatomic) int stopEndShutter;

//ISO最小步值
@property (assign, nonatomic) int stopBeginIso;

//ISO最大步值
@property (assign, nonatomic) int stopEndIso;

//闪光曝光补偿开始值
@property (assign, nonatomic) int stopBeginFlashEv;

//闪光曝光补偿结束值
@property (assign, nonatomic) int stopEndFlashEv;

//EV开始值
@property (assign, nonatomic) int stopBeginEv;

//EV结束值
@property (assign, nonatomic) int stopEndEv;


//高速同步速度 0代表 1秒 1代表 1/2秒
@property (assign, nonatomic) float fSyncShutterStop;

@property (strong, nonatomic) NSArray *arrayTextAperture;
@property (strong, nonatomic) NSArray *arrayTextShutter;
@property (strong, nonatomic) NSArray *arrayTextIso;
@property (weak, nonatomic) IBOutlet UIPickerView *pvStep;

@end

@implementation ViewController


- (void)initWork {
    self.dicStrobeInfo = nil;
    self.arrayTextAperture = [[self class] arrayTextAperture];
    self.arrayTextShutter = [[self class] arrayTextShutter];
    self.arrayTextIso = [[self class] arrayTextIso];
    _stopBeginAperture = 15;
    _stopEndAperture = 0;
    
    _stopBeginShutter = 13;
    _stopEndShutter = -15;
    
    _stopBeginIso = -2;
    _stopEndIso = 12;
    
    _stopBeginFlashEv = 3;
    _stopEndFlashEv = -3;
    
    [self setupEvBeginAndEnd];
    _stepPerEv = 3;
    self.currentStopAperture = 8;
    self.currentStopShutter = 7.66666;
    self.currentStopIso = 0;
    self.currentStopFlashEv = 0;
    
    self.fSyncShutterStop = 7.66666; //对应1/200的快门速度

}

//根据已经设置好的光圈快门ISO范围，设置EV的范围
- (void)setupEvBeginAndEnd {
    //先取到实际的光圈快门ISO 小值 和 大值
    float smallAperture =   _stopBeginAperture  < _stopEndAperture  ? _stopBeginAperture    : _stopEndAperture;
    float bigAperture =     _stopBeginAperture  < _stopEndAperture  ? _stopEndAperture      : _stopBeginAperture;
    float smallShutter =    _stopBeginShutter   < _stopEndShutter   ? _stopBeginShutter     : _stopEndShutter;
    float bigShutter =      _stopBeginShutter   < _stopEndShutter   ? _stopEndShutter       : _stopBeginShutter;
    float smallIso =        _stopBeginIso       < _stopEndIso       ? _stopBeginIso         : _stopEndIso;
    float bigIso =          _stopBeginIso       < _stopEndIso       ? _stopEndIso           : _stopBeginIso;
    self.stopBeginEv = smallAperture + smallShutter - bigIso;
    self.stopEndEv = bigAperture + bigShutter - smallIso;
}

//根据STOP值，从指定的列表里找对应的预设文本
- (NSString *)getTextFromArrayText:(NSArray *)arrayText withStop:(float)stop {
    //先判断在不在预设文本包含范围里
    if (arrayText && arrayText.count > 0) {
        NSDictionary *dicBegin = [arrayText objectAtIndex:0];
        NSDictionary *dicEnd = [arrayText objectAtIndex:arrayText.count - 1];
        
        float stopBegin = [[dicBegin objectForKey:@"stop"] floatValue];
        float stopEnd = [[dicEnd objectForKey:@"stop"] floatValue];
        
        
        if (stop > stopBegin - 0.01f && stop < stopEnd + 0.01f) {
            //在预设文本列表包含范围里，找到最接近的那一个
            float minStopGap = 99999.f;
            NSDictionary *dicTmp = nil;
            
            for (NSDictionary *dic in arrayText) {
                float stopInDic = [[dic objectForKey:@"stop"] floatValue];
                float gap = fabsf(stopInDic - stop);
                if (gap < minStopGap) {
                    //这一个离真实值比上一个更近
                    minStopGap = gap;
                    dicTmp = dic;
                }
                else {
                    //这一个离真实值比上一个更远，那上一个值就是要找的值
                    break;
                }
            }
            if (dicTmp) {
                //有值，用这个DIC里的文本组装字符串并返回
                NSString *text = [dicTmp objectForKey:@"text"];
                return text;
            }
            
        }
    }
    return nil;
}

//从步进值得到光圈字符串 步进值stop为0时，代表光圈F 1.0
- (NSString *)stringApertureFromStop:(float)stop {
    NSString *stringBack = @"";
    //先算出F值
    float f = powf(M_SQRT2, stop);
    
    //查找预设文本
    NSString *text = [self getTextFromArrayText:_arrayTextAperture withStop:stop];
    if (text && text.length > 0) {
        return text;
    }
    
    if (f > 10.f ||
        (fmodf(stop, 1.0f) < 0.0001f && f > 5.7f)) {
        stringBack = [NSString stringWithFormat:@"F %.0f", f];
        //如果是整数步进值，则超过F2.8 (stop 3)则四舍五入至整数
        //如果超过F10 ，同样四舍五入至整数
//        int nF = (int)(f + 0.5f);
//        stringBack =  [NSString stringWithFormat:@"F %d", nF];
        
    }
    else {
        //其他情况四舍五入至小数点后1位
        stringBack =  [NSString stringWithFormat:@"F %.1f", f];
    }
    return stringBack;
}

//从步进值得到快门字符串 步进值stop为0时， 代表1秒
- (NSString *)stringShutterFromStop:(float)stop {
    
    //查找预设文本
    NSString *text = [self getTextFromArrayText:_arrayTextShutter withStop:stop];
    if (text && text.length > 0) {
        return text;
    }
    
    NSString *stringBack = @"";
    if (stop < 0.0001f) {
        //stop小于等于0时，按照 3m 19s 这样的形式返回
        float fS = 1 / powf(2.0f, stop);
        int nS = (int)(fS + 0.5f);
        int hours = nS / (60 * 60);
        int minutes = (nS / (60)) & 60;
        int secs = nS % (60);
        if (hours > 0) {
            stringBack =  [NSString stringWithFormat:@"%dh %dm", hours, minutes];
        }
        else if (minutes > 0) {
            stringBack =  [NSString stringWithFormat:@"%dm %ds", minutes, secs];
        }
        else {
            //小于2秒，精确到0.1秒
            //小于3秒, 精确到0.5秒
            //超过3秒，精确到秒
            if (fS >= 2.9999f) {
                stringBack =  [NSString stringWithFormat:@"%ds",secs];
            }
            else if (fS >= 1.9999f) {
                float nn = (int)(fS / 0.5f + 0.5f) * 0.5f;
                stringBack =  [NSString stringWithFormat:@"%.1fs",nn];
            }
            else {
                stringBack =  [NSString stringWithFormat:@"%.1fs",fS];
            }
        }
    }
    else {
        //stop大于等于0时，按照 1/1000 这样的形式返回
        
        //超过15，则按照5的整数倍输出
        //超过130，则按照10的整数倍输出
        //超过700，则按照50的整数倍输出
        //超过1300，则按照100的整数倍输出
        float fS = powf(2.0f,stop);
        int nS = (int)(fS + 0.5f);
        if (nS >= 1300) {
            nS = ((int)(nS / 100.f + 0.5f)) * 100;
        }
        else if (nS >= 700) {
            nS = ((int)(nS / 50.f + 0.5f)) * 50;
        }
        else if (nS >= 130) {
            nS = ((int)(nS / 10.f + 0.5f)) * 10;
        }
        else if (nS >= 15) {
            nS = ((int)(nS / 5.f + 0.5f)) * 5;
        }
        stringBack =  [NSString stringWithFormat:@"1/%d",nS];
    }
    return stringBack;
}

//从步进值得到ISO字符串 步进值stop为0时， 代表ISO 100
- (NSString *)stringIsoFromStop:(float)stop {
    
    //查找预设文本
    NSString *text = [self getTextFromArrayText:_arrayTextIso withStop:stop];
    if (text && text.length > 0) {
        return text;
    }
    
    
    NSString *stringBack = @"";
    
    
    //超过80，则按照5的整数倍输出
    //超过130，则按照10的整数倍输出
    //超过700，则按照50的整数倍输出
    //超过1300，则按照100的整数倍输出
    float fIso = 100 * powf(2.0f, stop);
    int nIso = (int)(fIso + 0.5f);
    if (nIso >= 1300) {
        nIso = ((int)(nIso / 100.f + 0.5f)) * 100;
    }
    else if (nIso >= 700) {
        nIso = ((int)(nIso / 50.f + 0.5f)) * 50;
    }
    else if (nIso >= 130) {
        nIso = ((int)(nIso / 10.f + 0.5f)) * 10;
    }
    else if (nIso >= 65) {
        nIso = ((int)(nIso / 5.f + 0.5f)) * 5;
    }
    stringBack =  [NSString stringWithFormat:@"ISO %d",nIso];
    return stringBack;
}

//从步进值得到曝光补偿字符串 步进值stop为0时，代表EV 0
- (NSString *)stringFlashEvFromStop:(float)stop {
    
    if (fabsf(stop - 0) < 0.001) {
        return @"闪光补偿 0 EV";
    }
    int sig = stop > 0.001 ? 1 : -1;
    
    if (sig > 0) {
        return [NSString stringWithFormat:@"闪光补偿 +%.1f EV", stop];
    }
    else {
        return [NSString stringWithFormat:@"闪光补偿 -%.1f EV", fabsf(stop)];
    }
}

//从步进值得到EV字符串 步进值stop为0时，代表EV 0
- (NSString *)stringEvFromStop:(float)stop {
    
    if (fabsf(stop - 0) < 0.001) {
        return @"0 EV";
    }
    return [NSString stringWithFormat:@"%.1f EV", stop];
}


//选择光圈
- (void)selectStopAperture:(float)stop animated:(BOOL)animated {
    //算出是第多少个
    float fRow = fabsf(stop - _stopBeginAperture) * _stepPerEv;
    int nRow = (int)(fRow + 0.5f);
    if (nRow < 0) {
        nRow = 0;
    }
    int rowMax = [self rowsForAperture] - 1;
    if (nRow > rowMax) {
        nRow = rowMax;
    }
    [_pvAperture selectRow:nRow inComponent:0 animated:YES];
}

//选择快门
- (void)selectStopShutter:(float)stop animated:(BOOL)animated {
    //算出是第多少个
    float fRow = fabsf(stop - _stopBeginShutter) * _stepPerEv;
    int nRow = (int)(fRow + 0.5f);
    if (nRow < 0) {
        nRow = 0;
    }
    int rowMax = [self rowsForShutter] - 1;
    if (nRow > rowMax) {
        nRow = rowMax;
    }
    [_pvShutter selectRow:nRow inComponent:0 animated:YES];
}

//选择ISO
- (void)selectStopIso:(float)stop animated:(BOOL)animated {
    //算出是第多少个
    float fRow = fabsf(stop - _stopBeginIso) * _stepPerEv;
    int nRow = (int)(fRow + 0.5f);
    if (nRow < 0) {
        nRow = 0;
    }
    int rowMax = [self rowsForIso] - 1;
    if (nRow > rowMax) {
        nRow = rowMax;
    }
    [_pvIso selectRow:nRow inComponent:0 animated:YES];
}

//选择闪光曝光补偿
- (void)selectStopFlashEv:(float)stop animated:(BOOL)animated {
    //算出是第多少个
    float fRow = fabsf(stop - _stopBeginFlashEv) * _stepPerEv;
    int nRow = (int)(fRow + 0.5f);
    if (nRow < 0) {
        nRow = 0;
    }
    int rowMax = [self rowsForFlashEv] - 1;
    if (nRow > rowMax) {
        nRow = rowMax;
    }
    [_pvFlashEv selectRow:nRow inComponent:0 animated:YES];
}

//选择步进值
- (void)selectStepPerEv:(int)stepPerEv animated:(BOOL)animated {
    //算出是第多少个
    [_pvStep selectRow:stepPerEv - 1 inComponent:0 animated:YES];
}

//选择EV
- (void)selectStopEv:(float)stop animated:(BOOL)animated {
    //算出是第多少个
    float fRow = fabsf(stop - _stopBeginEv) * _stepPerEv;
    int nRow = (int)(fRow + 0.5f);
    if (nRow < 0) {
        nRow = 0;
    }
    int rowMax = [self rowsForEv] - 1;
    if (nRow > rowMax) {
        nRow = rowMax;
    }
    [_pvEv selectRow:nRow inComponent:0 animated:YES];
}

//从缓存数据更新到界面
- (void)updateFromUserDefault {
    NSDictionary *dicCacheStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"cacheStatus"];
    NSNumber *nbCurrentStopAperture = dicCacheStatus[@"currentStopAperture"];
    NSNumber *nbCurrentStopShutter = dicCacheStatus[@"currentStopShutter"];
    NSNumber *nbCurrentStopIso = dicCacheStatus[@"currentStopIso"];
    NSNumber *nbCurrentStopFlashEv = dicCacheStatus[@"currentStopFlashEv"];
    NSNumber *nbSyncShutterStop = dicCacheStatus[@"syncShutterStop"];
    NSNumber *nbstepPerEv = dicCacheStatus[@"stepPerEv"];
    NSString *strobeDateId = dicCacheStatus[@"strobeDataId"];
    NSNumber *nbLockFlagEv = dicCacheStatus[@"lockFlagEv"];
    if (nbCurrentStopAperture)
        self.currentStopAperture = [nbCurrentStopAperture floatValue];
    if (nbCurrentStopShutter)
        self.currentStopShutter = [nbCurrentStopShutter floatValue];
    if (nbCurrentStopIso)
        self.currentStopIso = [nbCurrentStopIso floatValue];
    if (nbCurrentStopFlashEv)
        self.currentStopFlashEv = [nbCurrentStopFlashEv floatValue];
    if (nbSyncShutterStop)
        self.fSyncShutterStop = [nbSyncShutterStop floatValue];
    if (nbstepPerEv)
        self.stepPerEv = [nbstepPerEv intValue];
    _currentStopEv = _currentStopAperture + _currentStopShutter - _currentStopIso;
    [self selectStopEv:_currentStopEv animated:YES];
    if (strobeDateId && strobeDateId.length > 0) {
        //需要从PLIST找到对应的闪光灯信息
        NSArray *arrayStrobeInfo = [StrobeListCtrl getArrayStrobe];
        NSDictionary *dicMatch = nil;
        for (NSDictionary *dicTmp in arrayStrobeInfo) {
            NSString *dataId = dicTmp[@"dataId"];
            if ([strobeDateId isEqualToString:dataId]) {
                dicMatch = dicTmp;
                break;
            }
        }
        self.dicStrobeInfo = dicMatch;
    }
    if (nbLockFlagEv && nbLockFlagEv.integerValue == 1) {
        _btnLock.selected = YES;
    }
    else {
        _btnLock.selected = NO;
    }
    [self updateCurrentStrobeInfo];
}

- (void)updateUserDefault {
    NSDictionary *dicTmp = @{@"currentStopAperture" : [NSNumber numberWithFloat:self.currentStopAperture],
                             @"currentStopShutter" : [NSNumber numberWithFloat:self.currentStopShutter],
                             @"currentStopIso" : [NSNumber numberWithFloat:self.currentStopIso],
                             @"currentStopFlashEv" : [NSNumber numberWithFloat:self.currentStopFlashEv],
                             @"syncShutterStop" : [NSNumber numberWithFloat:self.fSyncShutterStop],
                             @"stepPerEv" : [NSNumber numberWithInt:self.stepPerEv],
                             @"lockFlagEv" : _btnLock.selected ? @1 : @0};
    NSMutableDictionary *dicCacheStatus = [dicTmp mutableCopy];
    
    if (_dicStrobeInfo && _dicStrobeInfo[@"dataId"]) {
        [dicCacheStatus setObject:_dicStrobeInfo[@"dataId"] forKey:@"strobeDataId"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dicCacheStatus forKey:@"cacheStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWork];
    //self.navigationController.navigationBar.translucent = NO;
   // self.edgesForExtendedLayout = UIRectEdgeNone;
    //从用户信息中获取默认参数，并更新界面
    [self updateFromUserDefault];
    
    //大屏幕适配
    {
        _pvAperture.width = SCREEN_WIDTH / 4;
        _pvShutter.width = SCREEN_WIDTH / 4;
        _pvIso.width = SCREEN_WIDTH / 4;
        _pvEv.width = SCREEN_WIDTH / 4;
        _pvShutter.left = 0;
        _pvAperture.left = _pvShutter.right;
        _pvIso.left = _pvAperture.right;
        _pvEv.left = _pvIso.right;
        [self updateCurrentStrobeInfo];
    }

    [self selectStopShutter:_currentStopShutter animated:YES];
    [self selectStopAperture:_currentStopAperture animated:YES];
    [self selectStopIso:_currentStopIso animated:YES];
    [self selectStopFlashEv:_currentStopFlashEv animated:YES];
    [self selectStepPerEv:_stepPerEv animated:YES];
    [self calculateEv];
    [self calculateDistance];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//更新当前闪光灯信息
- (void)updateCurrentStrobeInfo {
    float fLastRight = 0;
    if (_dicStrobeInfo) {
        NSString *strobeName = _dicStrobeInfo[@"strobeName"];
        NSNumber *strobeGn = _dicStrobeInfo[@"gn"];
        NSString *imageName = _dicStrobeInfo[@"imageName"];

        
        UIImage *image = [StrobeListCtrl imageWithImageName:imageName];
        if (image) {
            _ivStrobe.hidden = NO;
            _ivStrobe.image = image;
        }
        else {
            //没有有效图片
            _ivStrobe.hidden = YES;
        }
        _lbStrobeTitle.text = strobeName;
        _lbStrobeSubTitle.text = [NSString stringWithFormat:@"GN值(ISO100 米): %ld",[strobeGn integerValue]];
    }
    else {
        _ivStrobe.hidden = YES;
        _lbStrobeTitle.text = @"点击选择闪光设备";
        _lbStrobeSubTitle.text = @"无";
    }
    if (!_ivStrobe.hidden) {
        fLastRight = _ivStrobe.right;
    }
    fLastRight += 8;
    _lbStrobeTitle.left = fLastRight;
    _lbStrobeSubTitle.left = fLastRight;
    _lbStrobeTitle.width = SCREEN_WIDTH - 30 - fLastRight;
    _lbStrobeSubTitle.width = SCREEN_WIDTH - 30 - fLastRight;
    
    
}

- (void)calculateEv {
    if (!_btnLock.selected) {
        _currentStopEv = _currentStopAperture + _currentStopShutter - _currentStopIso;
        [self selectStopEv:_currentStopEv animated:YES];
    }
}

- (void)calculateDistance {
    if (!_dicStrobeInfo || !_dicStrobeInfo[@"gn"]) {
        _lbDistance.text = @"";
        return;
    }
    //高速同步衰减
    float cutStop = 0;
    if (_currentStopShutter - _fSyncShutterStop > 0.1f) {
        //高速同步
        cutStop = _currentStopShutter - _fSyncShutterStop + 1.333333f;
    }
    cutStop -= _currentStopIso;
    cutStop += _currentStopFlashEv;
    //Gn指数需要减cutStop档
/*
 float gnReal = _currentStrobeInfo.gn100 / powf(M_SQRT2, cutStop);
 float f = powf(M_SQRT2, _currentStopAperture);
 float distance = gnReal / f;
 */
    float distance = [_dicStrobeInfo[@"gn"] integerValue] / powf(M_SQRT2, cutStop + _currentStopAperture);
    _lbDistance.text = [NSString stringWithFormat:@"%.1fm",distance];
}

- (void)calculateAperture {
    
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (pickerView == _pvAperture) {
        return [self rowsForAperture];
    }
    else if (pickerView == _pvShutter) {
        return [self rowsForShutter];
    }
    else if (pickerView == _pvIso) {
        return [self rowsForIso];
    }
    else if (pickerView == _pvFlashEv) {
        return [self rowsForFlashEv];
    }
    else if (pickerView == _pvEv) {
        return [self rowsForEv];
    }
    else if (pickerView == _pvStep) {
        return 3;
    }
    return 0;
}

- (int)rowsForAperture {
    int stopBegin = 0;
    int stopEnd = 13;
    stopBegin = _stopBeginAperture;
    stopEnd = _stopEndAperture;
    return abs(stopEnd - stopBegin) * _stepPerEv + 1;
}

- (int)rowsForShutter {
    int stopBegin = 0;
    int stopEnd = 13;
    stopBegin = _stopBeginShutter;
    stopEnd = _stopEndShutter;
    int rows = abs(stopEnd - stopBegin) * _stepPerEv + 1;
    return rows;
}

- (int)rowsForIso {
    int stopBegin = 0;
    int stopEnd = 13;
    stopBegin = _stopBeginIso;
    stopEnd = _stopEndIso;
    return abs(stopEnd - stopBegin) * _stepPerEv + 1;
}

- (int)rowsForFlashEv {
    int stopBegin = -3;
    int stopEnd = 3;
    return abs(stopEnd - stopBegin) * _stepPerEv + 1;
}

- (int)rowsForEv {
    int stopBegin = -3;
    int stopEnd = 3;
    stopBegin = _stopBeginEv;
    stopEnd = _stopEndEv;
    return abs(stopEnd - stopBegin) * _stepPerEv + 1;
}

//重写方法
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        if (!font) font = [UIFont systemFontOfSize:15];
        [pickerLabel setFont:font];

        pickerLabel.minimumScaleFactor = 0.5f;
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//    if (pickerView == _pvFlashEv) {
//        if ([pickerLabel.text isEqualToString:@"EV 0.0"] ||
//            [pickerLabel.text isEqualToString:@"EV 0"]) {
//            pickerLabel.textColor = [UIColor colorWithRed:0 green:0.5f blue:0 alpha:1];
//        }
//        else {
//            pickerLabel.textColor = [UIColor blackColor];
//        }
//    }
    return pickerLabel;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == _pvAperture) {
        int sig = _stopBeginAperture < _stopEndAperture ? 1 : -1;
        float stop = _stopBeginAperture + sig * (row / (float)_stepPerEv);
        return [self stringApertureFromStop:stop];
    }
    else if (pickerView == _pvShutter) {
        int sig = _stopBeginShutter < _stopEndShutter ? 1 : -1;
        float stop = _stopBeginShutter + sig * (row / (float)_stepPerEv);
        return [self stringShutterFromStop:stop];
    }
    else if (pickerView == _pvIso) {
        int sig = _stopBeginIso < _stopEndIso ? 1 : -1;
        float stop = _stopBeginIso + sig * (row / (float)_stepPerEv);
        return [self stringIsoFromStop:stop];
    }
    else if (pickerView == _pvFlashEv) {
        int sig = _stopBeginFlashEv < _stopEndFlashEv ? 1 : -1;
        float stop = _stopBeginFlashEv + sig * (row / (float)_stepPerEv);
        return [self stringFlashEvFromStop:stop];
    }
    else if (pickerView == _pvEv) {
        int sig = _stopBeginEv < _stopEndEv ? 1 : -1;
        float stop = _stopBeginEv + sig * (row / (float)_stepPerEv);
        return [self stringEvFromStop:stop];
    }
    else if (pickerView == _pvStep) {
        NSString *step = @"1";
        if (row > 0) {
            step = [NSString stringWithFormat:@"1/%ld",row + 1];
        }
        return [NSString stringWithFormat:@"步长%@档",step];
    }
    return @"-";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView == _pvAperture) {
        int sig = _stopBeginAperture < _stopEndAperture ? 1 : -1;
        _currentStopAperture = sig * ((float)row / _stepPerEv) + _stopBeginAperture;
        if (_btnLock.selected) {
            //EV上锁了，改快门值
            _currentStopShutter = _currentStopEv - _currentStopAperture + _currentStopIso;
            [self selectStopShutter:_currentStopShutter animated:YES];
        }
        else {
            [self calculateEv];
        }
    }
    else if (pickerView == _pvShutter) {
        int sig = _stopBeginShutter < _stopEndShutter ? 1 : -1;
        _currentStopShutter = sig * ((float)row / _stepPerEv) + _stopBeginShutter;
        if (_btnLock.selected) {
            //EV上锁了，改光圈
            _currentStopAperture = _currentStopEv - _currentStopShutter + _currentStopIso;
            [self selectStopAperture:_currentStopAperture animated:YES];
        }
        else {
            [self calculateEv];
        }
        
    }
    else if (pickerView == _pvIso) {
        int sig = _stopBeginIso < _stopEndIso ? 1 : -1;
        _currentStopIso = sig * ((float)row / _stepPerEv) + _stopBeginIso;
        if (_btnLock.selected) {
            //EV上锁了，改快门值
            _currentStopShutter = _currentStopEv - _currentStopAperture + _currentStopIso;
            [self selectStopShutter:_currentStopShutter animated:YES];
        }
        else {
            [self calculateEv];
        }
    }
    else if (pickerView == _pvFlashEv) {
        int sig = _stopBeginFlashEv < _stopEndFlashEv ? 1 : -1;
        _currentStopFlashEv = sig * ((float)row / _stepPerEv) + _stopBeginFlashEv;
    }
    else if (pickerView == _pvEv) {
        int sig = _stopBeginEv < _stopEndEv ? 1 : -1;
        _currentStopEv = sig * ((float)row / _stepPerEv) + _stopBeginEv;
        //锁上EV
        if (!_btnLock.selected) {
            [self btnLockTapped:nil];
        }
        //改快门值
        _currentStopShutter = _currentStopEv - _currentStopAperture + _currentStopIso;
        [self selectStopShutter:_currentStopShutter animated:YES];
    }
    else if (pickerView == _pvStep) {
        self.stepPerEv = (int)row + 1;
        [_pvAperture reloadAllComponents];
        [_pvShutter reloadAllComponents];
        [_pvFlashEv reloadAllComponents];
        [_pvIso reloadAllComponents];
        [_pvEv reloadAllComponents];
        [_pvFlashEv reloadAllComponents];
        [self selectStopShutter:_currentStopShutter animated:NO];
        [self selectStopAperture:_currentStopAperture animated:NO];
        [self selectStopIso:_currentStopIso animated:NO];
        [self selectStopFlashEv:_currentStopFlashEv animated:NO];
        [self selectStopEv:_currentStopEv animated:NO];
    }

    

    [self calculateDistance];
    [self updateUserDefault];
}

//光圈实际值、显示值对应列表
+ (NSArray *)arrayTextAperture {
    return @[@{@"stop":@0.0f,     @"text":@"F 1.0"},
             @{@"stop":@0.33333f, @"text":@"F 1.1"},
             @{@"stop":@0.5f,     @"text":@"F 1.2"},
             @{@"stop":@0.66667f, @"text":@"F 1.2"},
             @{@"stop":@1.0f,     @"text":@"F 1.4"},
             @{@"stop":@1.33333f, @"text":@"F 1.6"},
             @{@"stop":@1.5f,     @"text":@"F 1.8"},
             @{@"stop":@1.66667f, @"text":@"F 1.8"},
             @{@"stop":@2.0f,     @"text":@"F 2.0"},
             @{@"stop":@2.33333f, @"text":@"F 2.2"},
             @{@"stop":@2.5f,     @"text":@"F 2.5"},
             @{@"stop":@2.66667f, @"text":@"F 2.5"},
             @{@"stop":@3.0f,     @"text":@"F 2.8"},
             @{@"stop":@3.33333f, @"text":@"F 3.2"},
             @{@"stop":@3.5f,     @"text":@"F 3.5"},
             @{@"stop":@3.66667f, @"text":@"F 3.5"},
             @{@"stop":@4.0f,     @"text":@"F 4.0"},
             @{@"stop":@4.33333f, @"text":@"F 4.5"},
             @{@"stop":@4.5f,     @"text":@"F 4.5"},
             @{@"stop":@4.66667f, @"text":@"F 5.0"},
             @{@"stop":@5.0f,     @"text":@"F 5.6"},
             @{@"stop":@5.33333f, @"text":@"F 6.3"},
             @{@"stop":@5.5f,     @"text":@"F 6.7"},
             @{@"stop":@5.66667f, @"text":@"F 7.1"},
             @{@"stop":@6.0f,     @"text":@"F 8.0"},
             @{@"stop":@6.33333f, @"text":@"F 9.0"},
             @{@"stop":@6.5f,     @"text":@"F 9.5"},
             @{@"stop":@6.66667f, @"text":@"F 10"},
             @{@"stop":@7.0f,     @"text":@"F 11"},
             @{@"stop":@7.33333f, @"text":@"F 13"},
             @{@"stop":@7.5f,     @"text":@"F 13"},
             @{@"stop":@7.66667f, @"text":@"F 14"},
             @{@"stop":@8.0f,     @"text":@"F 16"},
             @{@"stop":@8.33333f, @"text":@"F 18"},
             @{@"stop":@8.5f,     @"text":@"F 19"},
             @{@"stop":@8.66667f, @"text":@"F 20"},
             @{@"stop":@9.0f,     @"text":@"F 22"},
             @{@"stop":@9.33333f, @"text":@"F 25"},
             @{@"stop":@9.5f,     @"text":@"F 27"},
             @{@"stop":@9.66667f, @"text":@"F 29"},
             @{@"stop":@10.0f,     @"text":@"F 32"},
             @{@"stop":@10.33333f, @"text":@"F 36"},
             @{@"stop":@10.5f,     @"text":@"F 38"},
             @{@"stop":@10.66667f, @"text":@"F 40"},
             @{@"stop":@11.0f,     @"text":@"F 45"},
             @{@"stop":@11.33333f, @"text":@"F 51"},
             @{@"stop":@11.5f,     @"text":@"F 54"},
             @{@"stop":@11.66667f, @"text":@"F 57"},
             @{@"stop":@12.0f,     @"text":@"F 64"},
             @{@"stop":@12.33333f, @"text":@"F 72"},
             @{@"stop":@12.5f,     @"text":@"F 76"},
             @{@"stop":@12.66667f, @"text":@"F 81"},
             @{@"stop":@13.0f,     @"text":@"F 91"}];
}
//快门实际值、显示值对应列表
+ (NSArray *)arrayTextShutter{
    return @[@{@"stop":@-5.0f,     @"text":@"30s"},
             @{@"stop":@-4.66667f, @"text":@"25s"},
             @{@"stop":@-4.5f,     @"text":@"20"},
             @{@"stop":@-4.33333f, @"text":@"20s"},
             @{@"stop":@-4.0f,     @"text":@"15"},
             @{@"stop":@-3.66667f, @"text":@"13s"},
             @{@"stop":@-3.5f,     @"text":@"10s"},
             @{@"stop":@-3.33333f, @"text":@"10s"},
             @{@"stop":@-3.0f,     @"text":@"8s"},
             @{@"stop":@-2.66667f, @"text":@"6s"},
             @{@"stop":@-2.5f,     @"text":@"6s"},
             @{@"stop":@-2.33333f, @"text":@"5s"},
             @{@"stop":@-2.0f,     @"text":@"4s"},
             @{@"stop":@-1.66667f, @"text":@"3.2s"},
             @{@"stop":@-1.5f,     @"text":@"3s"},
             @{@"stop":@-1.33333f, @"text":@"2.5s"},
             @{@"stop":@-1.0f,     @"text":@"2s"},
             @{@"stop":@-0.66667f, @"text":@"1.6s"},
             @{@"stop":@-0.5f,     @"text":@"1.5s"},
             @{@"stop":@-0.33333f, @"text":@"1.3s"},
             @{@"stop":@0.0f,     @"text":@"1s"},
             @{@"stop":@0.33333f, @"text":@"0.8s"},
             @{@"stop":@0.5f,     @"text":@"0.7s"},
             @{@"stop":@0.66667f, @"text":@"0.6s"},
             @{@"stop":@1.0f,     @"text":@"0.5s"},
             @{@"stop":@1.33333f, @"text":@"0.4s"},
             @{@"stop":@1.5f,     @"text":@"0.3s"},
             @{@"stop":@1.66667f, @"text":@"0.3s"},
             @{@"stop":@2.0f,     @"text":@"1/4"},
             @{@"stop":@2.33333f, @"text":@"1/5"},
             @{@"stop":@2.5f,     @"text":@"1/6"},
             @{@"stop":@2.66667f, @"text":@"1/6"},
             @{@"stop":@3.0f,     @"text":@"1/8"},
             @{@"stop":@3.33333f, @"text":@"1/10"},
             @{@"stop":@3.5f,     @"text":@"1/10"},
             @{@"stop":@3.66667f, @"text":@"1/13"},
             @{@"stop":@4.0f,     @"text":@"1/15"},
             @{@"stop":@4.33333f, @"text":@"1/20"},
             @{@"stop":@4.5f,     @"text":@"1/20"},
             @{@"stop":@4.66667f, @"text":@"1/25"},
             @{@"stop":@5.0f,     @"text":@"1/30"},
             @{@"stop":@5.33333f, @"text":@"1/40"},
             @{@"stop":@5.5f,     @"text":@"1/45"},
             @{@"stop":@5.66667f, @"text":@"1/50"},
             @{@"stop":@6.0f,     @"text":@"1/60"},
             @{@"stop":@6.33333f, @"text":@"1/80"},
             @{@"stop":@6.5f,     @"text":@"1/90"},
             @{@"stop":@6.66667f, @"text":@"1/100"},
             @{@"stop":@7.0f,     @"text":@"1/125"},
             @{@"stop":@7.33333f, @"text":@"1/160"},
             @{@"stop":@7.5f,     @"text":@"1/180"},
             @{@"stop":@7.66667f, @"text":@"1/200"},
             @{@"stop":@8.0f,     @"text":@"1/250"},
             @{@"stop":@8.33333f, @"text":@"1/320"},
             @{@"stop":@8.5f,     @"text":@"1/350"},
             @{@"stop":@8.66667f, @"text":@"1/400"},
             @{@"stop":@9.0f,     @"text":@"1/500"},
             @{@"stop":@9.33333f, @"text":@"1/640"},
             @{@"stop":@9.5f,     @"text":@"1/750"},
             @{@"stop":@9.66667f, @"text":@"1/800"},
             @{@"stop":@10.0f,     @"text":@"1/1000"},
             @{@"stop":@10.33333f, @"text":@"1/1250"},
             @{@"stop":@10.5f,     @"text":@"1/1500"},
             @{@"stop":@10.66667f, @"text":@"1/1600"},
             @{@"stop":@11.0f,     @"text":@"1/2000"},
             @{@"stop":@11.33333f, @"text":@"1/2500"},
             @{@"stop":@11.5f,     @"text":@"1/3000"},
             @{@"stop":@11.66667f, @"text":@"1/3200"},
             @{@"stop":@12.0f,     @"text":@"1/4000"},
             @{@"stop":@12.33333f, @"text":@"1/5200"},
             @{@"stop":@12.5f,     @"text":@"1/6000"},
             @{@"stop":@12.66667f, @"text":@"1/6500"},
             @{@"stop":@13.0f,     @"text":@"1/8000"}];
}
//ISO实际值、显示值对应列表
+ (NSArray *)arrayTextIso {
    return @[@{@"stop":@-3.0f,     @"text":@"ISO 12"},
             @{@"stop":@-2.66667f, @"text":@"ISO 16"},
             @{@"stop":@-2.5f,     @"text":@"ISO 18"},
             @{@"stop":@-2.33333f, @"text":@"ISO 20"},
             @{@"stop":@-2.0f,     @"text":@"ISO 25"},
             @{@"stop":@-1.66667f, @"text":@"ISO 32"},
             @{@"stop":@-1.5f,     @"text":@"ISO 40"},
             @{@"stop":@-1.33333f, @"text":@"ISO 45"},
             @{@"stop":@-1.0f,     @"text":@"ISO 50"},
             @{@"stop":@-0.66667f, @"text":@"ISO 64"},
             @{@"stop":@-0.5f,     @"text":@"ISO 75"},
             @{@"stop":@-0.33333f, @"text":@"ISO 80"},
             @{@"stop":@0.0f,     @"text":@"ISO 100"},
             @{@"stop":@0.33333f, @"text":@"ISO 125"},
             @{@"stop":@0.5f,     @"text":@"ISO 140"},
             @{@"stop":@0.66667f, @"text":@"ISO 160"},
             @{@"stop":@1.0f,     @"text":@"ISO 200"},
             @{@"stop":@1.33333f, @"text":@"ISO 250"},
             @{@"stop":@1.5f,     @"text":@"ISO 280"},
             @{@"stop":@1.66667f, @"text":@"ISO 320"},
             @{@"stop":@2.0f,     @"text":@"ISO 400"},
             @{@"stop":@2.33333f, @"text":@"ISO 500"},
             @{@"stop":@2.5f,     @"text":@"ISO 560"},
             @{@"stop":@2.66667f, @"text":@"ISO 640"},
             @{@"stop":@3.0f,     @"text":@"ISO 800"},
             @{@"stop":@3.33333f, @"text":@"ISO 1000"},
             @{@"stop":@3.5f,     @"text":@"ISO 1100"},
             @{@"stop":@3.66667f, @"text":@"ISO 1250"},
             @{@"stop":@4.0f,     @"text":@"ISO 1600"},
             @{@"stop":@4.33333f, @"text":@"ISO 2000"},
             @{@"stop":@4.5f,     @"text":@"ISO 2200"},
             @{@"stop":@4.66667f, @"text":@"ISO 2500"},
             @{@"stop":@5.0f,     @"text":@"ISO 3200"},
             @{@"stop":@5.33333f, @"text":@"ISO 4000"},
             @{@"stop":@5.5f,     @"text":@"ISO 4600"},
             @{@"stop":@5.66667f, @"text":@"ISO 5000"},
             @{@"stop":@6.0f,     @"text":@"ISO 6400"},
             @{@"stop":@6.33333f, @"text":@"ISO 8000"},
             @{@"stop":@6.5f,     @"text":@"ISO 9000"},
             @{@"stop":@6.66667f, @"text":@"ISO 10000"},
             @{@"stop":@7.0f,     @"text":@"ISO 12800"},
             @{@"stop":@7.33333f, @"text":@"ISO 16000"},
             @{@"stop":@7.5f,     @"text":@"ISO 18000"},
             @{@"stop":@7.66667f, @"text":@"ISO 20000"},
             @{@"stop":@8.0f,     @"text":@"ISO 25600"},
             @{@"stop":@8.33333f, @"text":@"ISO 32000"},
             @{@"stop":@8.5f,     @"text":@"ISO 35000"},
             @{@"stop":@8.66667f, @"text":@"ISO 40000"},
             @{@"stop":@9.0f,     @"text":@"ISO 51200"},
             @{@"stop":@9.33333f, @"text":@"ISO 64000"},
             @{@"stop":@9.5f,     @"text":@"ISO 70000"},
             @{@"stop":@9.66667f, @"text":@"ISO 80000"},
             @{@"stop":@10.0f,     @"text":@"ISO 100000"}];
}

- (IBAction)btnLockTapped:(id)sender {
    _btnLock.selected = !_btnLock.selected;
    [self updateUserDefault];
}

- (IBAction)btnStrobeTapped:(id)sender {
    NSString *dataId = nil;
    if (self.dicStrobeInfo) {
        dataId = self.dicStrobeInfo[@"dataId"];
    }
    StrobeListCtrl *ctrl = [[StrobeListCtrl alloc]initWithDataId:dataId];
    __weak typeof(self) weakself = self;
    ctrl.handleSelect = ^(NSDictionary *dicStrobe) {
        weakself.dicStrobeInfo = dicStrobe;
        [weakself updateCurrentStrobeInfo];
        [weakself calculateDistance];
    };
    [self.navigationController pushViewController:ctrl animated:YES];
}


@end
