//
//  LJAddStrobeCtrl.m
//  BeautyPlus
//
//  Created by peter on 15/3/24.
//  Copyright (c) 2015年 BeautyPlus. All rights reserved.
//
#import "LJAddStrobeCtrl.h"
#import "UIView+Additions.h"
#import "SSInputView.h"
#import "commonMacroDefine.h"
#import "SSPredicate.h"
@interface LJAddStrobeCtrl ()
<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewDistribute3;
@property (weak, nonatomic) IBOutlet UIView *viewDistribute2;
@property (weak, nonatomic) IBOutlet UILabel *lbPopMarkTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbChannelTitle;

@property (weak, nonatomic) IBOutlet UILabel *lbDelegateTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbDelegate;
@property (weak, nonatomic) IBOutlet UILabel *lbChannel;
@property (strong, nonatomic) IBOutlet UIView *viewDistribute;
//当前键盘高度
@property (assign, nonatomic) float currentKeyboardHeight;
//最后出现的键盘调度
@property (assign, nonatomic) float lastKeyboardHeight;
@property (weak, nonatomic) IBOutlet UITextField *tfStrobeName;
@property (weak, nonatomic) IBOutlet UITextField *tfGn;
@property (strong, nonatomic) NSDictionary *dicInitial;

@end

@implementation LJAddStrobeCtrl
- (id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        self.dicInitial = dic;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _lastKeyboardHeight = 0;
        _currentKeyboardHeight = 0;
        //监听键盘弹出和消失消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)show {
    [self.view removeAllSubviews];
    if (!self.view.superview) {
        UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
        [window addSubview:self.view];
        self.view.frame = window.bounds;
    }
    if (!_viewDistribute.superview) {
        [self.view addSubview:_viewDistribute];
        _viewDistribute.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
    }
    if (self.dicInitial) {
        _tfStrobeName.text = _dicInitial[@"strobeName"];
        _tfGn.text = [_dicInitial[@"gn"] stringValue];
    }
}

- (void)updateLeftRightBtnInView:(UIView *)view {
    UIView *viewLeft = nil;
    UIView *viewRight = nil;
    viewLeft = [view viewWithTag:751];
    viewRight = [view viewWithTag:752];
    viewLeft.width = (SCREEN_WIDTH - 40 - 45) / 2;
    viewLeft.left = 15;
    viewRight.width = (SCREEN_WIDTH - 40 - 45) / 2;
    viewRight.left = viewLeft.right + 15;
}

- (void)hideKeyboard:(UIButton *)sender {
    [self resign];
}

- (void)resign {
    [_tfGn resignFirstResponder];
    [_tfStrobeName resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self show];
}

//输入时的工具栏
+ (UIView *)viewInputForTouchView:(UIView *)aView {
    SSInputView *view = [[SSInputView alloc]init];
    
    view.touchView = aView;
    return view;
}

- (void)viewDidLoad {
    
    {
        //界面设置
        UIView *aView = [[self class] viewInputForTouchView:_viewDistribute];
        UIButton *btn1 = (UIButton *)[aView viewWithTag:101];
        UIButton *btn2 = (UIButton *)[aView viewWithTag:102];
        UIButton *btn3 = (UIButton *)[aView viewWithTag:103];
        btn1.hidden = YES;
        btn2.hidden = YES;
        [btn3 addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        _tfStrobeName.inputAccessoryView = aView;
        _tfGn.inputAccessoryView = aView;
        
        [super viewDidLoad];
        [self updateLeftRightBtnInView:_viewDistribute];
        _viewDistribute.layer.cornerRadius = 10;
        _viewDistribute.layer.masksToBounds = YES;
        _viewDistribute.width = SCREEN_WIDTH - 40;
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (IBAction)btnCancelTapped:(id)sender {
    _tfStrobeName.text = @"";
    _tfGn.text = @"";
    [self.view removeAllSubviews];
    [self.view removeFromSuperview];
}
- (IBAction)btnSaveTapped:(id)sender {
    [self resign];
    if (_tfStrobeName.text <= 0) {
        simpleAlertView(@"提示", @"请填写设备名称");
        [_tfStrobeName becomeFirstResponder];
        return;
    }
    if (_tfGn.text <= 0) {
        simpleAlertView(@"提示", @"请填写GN值");
        [_tfGn becomeFirstResponder];
        return;
    }
    if (![SSPredicate fitTo16Numbers:_tfGn.text]) {
        simpleAlertView(@"提示", @"请填写正确的GN值，要求为1-6位的整数");
        [_tfGn becomeFirstResponder];
        return;
    }
    [self commitAction];

}

- (void)commitAction {

    if (self.dicInitial) {
        //是编辑
        if (_dicInitial[@"dataId"]) {
            NSDictionary *dic = @{@"dataId" : _dicInitial[@"dataId"],
                                  @"strobeName" : _tfStrobeName.text,
                                  @"gn" : [NSNumber numberWithInteger:[_tfGn.text integerValue]]};
            if (self.handleEditSuccess) {
                self.handleEditSuccess(dic);
            }
        }

    }
    else {
        //是新增
        NSString *UUID = [[NSUUID UUID] UUIDString];
        NSDictionary *dic = @{@"dataId" : UUID,
                              @"strobeName" : _tfStrobeName.text,
                              @"gn" : [NSNumber numberWithInteger:[_tfGn.text integerValue]]};
        if (self.handleAddSuccess) {
            self.handleAddSuccess(dic);
        }
    }
    [self.view removeAllSubviews];
    [self.view removeFromSuperview];

}
- (IBAction)btnPopCancelTapped:(id)sender {
    [self.view removeAllSubviews];
    [self.view removeFromSuperview];
}

//更新tvPopMark和viewDistribute的高度位置
- (void)updateTvPopMarkFrameWithKeyBoardHeight {
    float gap = 20.f;
    [UIView animateWithDuration:0.25 animations:^{
        _viewDistribute3.top = _viewDistribute2.bottom;
        _viewDistribute.height = _viewDistribute3.bottom;
        _viewDistribute.centerX = SCREEN_WIDTH / 2;
        _viewDistribute.centerY = SCREEN_HEIGHT / 2 - _currentKeyboardHeight / 2;
        if (_viewDistribute.height > SCREEN_HEIGHT - _currentKeyboardHeight - gap - gap) {
            _viewDistribute.top = SCREEN_HEIGHT - _currentKeyboardHeight - _viewDistribute.height - gap;
        }
    }];
    
}

#pragma mark keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    self.lastKeyboardHeight = keyboardRect.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSValue *animationCurve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSUInteger curve = 0;
    [animationCurve getValue:&curve];
    
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    _currentKeyboardHeight = keyboardRect.size.height;
    {
        if (_tfStrobeName.isFirstResponder || _tfGn.isFirstResponder){
            [self updateTvPopMarkFrameWithKeyBoardHeight];
        }
    }
    
}



- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    _currentKeyboardHeight = 0;
    [animationDurationValue getValue:&animationDuration];
    {
        if (_tfStrobeName.isFirstResponder || _tfGn.isFirstResponder){
            [self updateTvPopMarkFrameWithKeyBoardHeight];
        }
    }
}

@end
