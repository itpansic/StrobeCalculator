//
//  commonMacroDefine.h
//  ios
//
//  Created by 陈威 on 2016/12/1.
//  Copyright © 2016年 BeautyPlus. All rights reserved.
//

/*
 此头文件为设置一些常见常用的宏定义
 
 此头文件已经放入了.PCH文件里面
 */

#ifndef commonMacroDefine_h
#define commonMacroDefine_h

//常用函数定义
#define ONLINECSWEBURL      @"http://www.sobot.com/chat/h5/index.html?sysNum=6efa352cea7b405396cd87f8e7fd1b3b&source=2&back=1"



#define nbTrans(nb) [SSGlobal descForInteger:nb]
#define simpleAlertView(title,msg) {UIAlertView *av = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil]; [av show]; }

//常用常数定义
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define STATUSBAR_HOLDPLACE_HEIGHT (STATUSBAR_HEIGHT > 20 ? STATUSBAR_HEIGHT - 20 : 0)
#define NAV_HEIGHT 44

#define ISIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define ISIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define ISIOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)
#define ISIOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10)
#define ISBELOWIOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] <= 6)




//数据库消息类型
#define typeCommented     @"typeCommented"
#define typeReplyed       @"typeReplyed"
#define typeMsgTopic      @"typeReplyed"      //帖子推送

#define typeSystemNoti    @"typeSystemNoti"
#define typeShopNoti      @"typeShopNoti"
#define typeShopMsg       @"typeShopMsg"
#define typeShopJoinOrReg @"typeShopJoinOrReg"
#define typeServiceChat   @"typeServiceChat"
#define typeMessage       @"typeMessage"

//本地通知

//更新TABBAR BADGE NUMBER
#define RefreshBuinessList                  @"RefreshBuinessList"
#define msgUpdateTabBadge                   @"msgUpdateTabBadge"
#define msgNewFollower                      @"msgNewFollower"
#define msgNewConsume                       @"msgNewFollower"
#define msgNewShowTheme                     @"msgNewShowTheme"
#define msgNewShowShop                      @"msgRefreshShowShop"
#define msgNewShowSystem                    @"msgNewShowSystem"
#define msgNewShowMarket                    @"msgNewShowMarket"
#define msgNewShowMessageFriend             @"msgRefreshShowMessageFriend"
#define msgNewShowMessageStranger           @"msgRefreshShowMessageStranger"
#define msgNewSystemNoti                    @"msgNewSystemNoti"
#define msgNewMarketNoti                    @"msgNewMarketNoti"
#define msgNewShopNoti                      @"msgNewShopNoti"
#define msgNewShopMsg                       @"msgNewShopMsg"
#define msgNewServiceChat                   @"msgNewServiceChat"
#define msgNewMessage                       @"msgNewMessage"
#define msgSentMessage                      @"msgSentMessage"
#define msgShopMsgSentMessage               @"msgShopMsgSentMessage"
#define msgReceiveMessageFriend             @"msgReceiveMessageFriend"
#define msgReceiveMessageStranger           @"msgReceiveMessageStranger"
#define msgJumpTopic                        @"msgJumpTopic"
#define msgGetCheckIn                       @"msgGetCheckIn"

#define msgSideslip                         @"msgSideslip"
#define sideShopId                          @"sideShopId"

#define msgPitchChanged                     @"msgPitchChanged"

#define msgFollowChanged                    @"msgFollowChanged"
#define msgUpdateSign                       @"msgUpdateSign"
#define msgUpdateMyHead                     @"msgUpdateMyHead"

#define msgReplyed                          @"msgReplyed"

#define msgErcodePayed                      @"msgErcodePayed"

#define NotificationOnlineDistributeUpdated @"NotificationOnlineDistributeUpdated"

#define coordinateShenzhen CLLocationCoordinate2DMake(22.5485, 114.0644)
//超时时间
#define DEFAULT_TIMEOUT    15
#define DEFAULT_ROWS       20
//TABBAR高度
#define TABBAR_HEIGHT      50.0f
#define INPUTVIEW_HEIGHT   31.0f

//默认显示的美丽圈个数
#define DEFAULT_THEMECOUNT 11

#define APPSTORE_ID      @"1145763193"
#define DES_KEY          @"jxt~!@!#$#@%$^%&%&(&*("
//微信开放平台 APPID
//用户版
#define WECHAT_ID_USER        @"wxf097725c55ee0475"
//商家版
#define WECHAT_ID_MERCHANT        @"wx45c59e32ccb8734a"
//商家版_公网测试
#define WECHAT_ID_GLOBALTEST   @"wx73ef07ad108039de"
//微信开放平台 APPID
#define WECHAT_ID IS_GLOBAL_TEST ? WECHAT_ID_GLOBALTEST : WECHAT_ID_MERCHANT
//微信开放平台 APP_SECRET
//用户版
#define WECHAT_SECRET_USER        @"1bf7ea890351e1934997034b0a20ce25"
//商家版
#define WECHAT_SECRET_MERCHANT        @"3d4e0430b0acf91d3580143e20701869"
//商家版_公网测试
#define WECHAT_SECRET_GLOBALTEST   @"d4624c36b6795d1d99dcf0547af5443d"
//微信开放平台 APP_SECRET
#define WECHAT_SECRET IS_GLOBAL_TEST ? WECHAT_SECRET_GLOBALTEST : WECHAT_SECRET_MERCHANT

//QQ互联
#define QQ_APP_ID        @"1101078323"
#define QQ_APP_KEY       @"c5Uk9bGHOBe2aBLA"

//新浪微博


#define WEIBO_APP_ID     @"1328522324"                      //公司
//#define WEIBO_APP_ID @"477817964"   //测试
#define WEIBO_APP_SECRET @"6ee0e505853e71f1a240d3bf8bbd9743"//公司
//#define WEIBO_APP_SECRET @"d5fe3d9c3c25ab4091ee4a405b2c7b59"  //测试
#define WEIBO_REDIRECT   @"http://sns.whalecloud.com/sina2/callback"
//XMPP RES
#define XMPP_DOMAIN      @"mljia"
#define XMPP_RES         @"mljia"
//SHARE SDK
#define SHARESDK_APP_ID  @"1c0ab3014b2e"
//百度地图
#define BAIDU_MAP_ID BAIDU_MAP_ID_SHOP
#define BAIDU_MAP_ID_SHOP @"9CBnh2GsVnKr5XElT80weWGy"  //商家版
//#define BAIDU_MAP_ID @"wDkwlg7KqoGY8HeP3g47bZFV"//PETER
//美丽加接口上下文
#define CONTEXT_MEIRONG @"meirong.client"
#define CONTEXT_AUTH    @"auth"
#define CONTEXT_FORUM   @"forum.client"
#define CONTEXT_UPLOAD  @"upload"
#define CONTEXT_PUBLIC  @"cn.mljia.client"
#define CONTEXT_APPSHOP @"shop.client"

//商家版支付宝参数
#define ALI_SCHEME_SHOP      @"ap2015111600813277"

//商家版公网测试专用
#define ALI_SCHEME_GLOBALSHOPTEST      @"ap2015110600709546"

#define ALI_SCHEME (IS_GLOBAL_TEST ? ALI_SCHEME_GLOBALSHOPTEST : ALI_SCHEME_SHOP)


//友盟统计

#define UMENG_APPKEY_SHOP   @"551530dbfd98c515890009fd"//商家
//我的美丽圈每页行数
#define MY_THEME_ROWS 8


//数据库版本
/*
 应用新的数据库版本，如果更改数据库，请在dbMsgUpdate.plist添加新版本数据库数据，各字段意义如下：
 
 Bool型，是否从Bundle复制一个新的DB，而不是从旧版数据库升级(如果为YES，则backwardVersion、sqlUpdateFromBackwardVersion可不填
 copyFromBundle
 
 String型，上个数据库版本号
 backwardVersion
 
 String型，当前数据库版本号
 version
 
 String型，从上个版本的数据库升级用的SQL语句
 sqlUpdateFromBackwardVersion
 
 */
#define DB_VERSION_SHOP @"1.0.1"

//头像边框线粗
#define avatarBorderWidth 1.2f;
//#define WEIBO_APP_ID @"1328522324"
#define APP_SHARE_ADDR @"https://www.mljia.cn/event/141103/index.html"
#define APP_ADDR @"http://itunes.apple.com/us/app/id1145763193"
#define kShareText @"我现在正在使用美丽加APP，十分好用，你也来试试吧！下载连接：http://itunes.apple.com/us/app/id1145763193"
#define APP_COMMENT_ADDR @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1145763193"

//接口地址


#define CONN_API_URL   @"https://client.mljia.cn"
#define CONN_PIC_URL   @"https://upload.mljia.cn"
#define CONN_PUSH_URL  @"push.mljia.cn"
#define CONN_PUSH_PORT @"15222"
#define CONN_PAY_URL    @"https://pay.mljia.cn"
#define CONN_WX_URL     @"https://wx.mljia.cn"
#define DB_NAME        @"dbMsg"
#define CONN_MALL_URL     @"https://mall.mljia.cn"
#define MARKETJUMP     @"jump.mljia.cn"
#define CHANNEL_APPSTORE       @"App Store"
#define CHANNEL_91             @"91ipa"
#define CHANNEL_TONGBU         @"tongbu"
#define CHANNEL_GUOFEN         @"funso"
#define CHANNEL_PP             @"25pp"
#define CHANNEL_XYMOBILE       @"xyzs"
#define CHANNEL_ENTERPRISE     @"ENP"
#define IS_CLEAN_MEMOERY YES

//店铺参数设置

//护理成本开启参数
#define MASSAGE_COST_FALG                               @"MASSAGE_COST_FALG"

//耗卡分卡金赠送金参数
#define CARD_PRESENT_SEPARATE_FLAG                      @"CARD_PRESENT_SEPARATE_FLAG"

//店铺是否开启消费短信默认发送功能
#define SYS_CONSUMESMS                                  @"SYS_CONSUMESMS"

//店铺是否开启储值卡可购买次卡
#define STORE_CARD_BUY_CI_CARD                          @"STORE_CARD_BUY_CI_CARD"

//店铺是否开启储值卡可耗卡外护理产品
#define STORE_CARD_CONSUME_OFF_CARD                     @"STORE_CARD_CONSUME_OFF_CARD"

//是否启用是否启用顾客信息费功能
#define CUSTOMER_INFO_FEE_FUN                           @"CUSTOMER_INFO_FEE_FUN"

//一键设置信息费价格,次卡
#define SET_CUSTOMER_INFO_FEE_CARD                      @"SET_CUSTOMER_INFO_FEE_CARD"

//一键设置信息费价格,储值卡
#define SET_CUSTOMER_INFO_FEE_STORE_CARD                @"SET_CUSTOMER_INFO_FEE_STORE_CARD"

//一键设置信息费价格,次卡（个性卡）
#define SET_CUSTOMER_INFO_FEE_SPECIFIC_CARD             @"SET_CUSTOMER_INFO_FEE_SPECIFIC_CARD"

//一键设置信息费价格,储值卡（个性卡）
#define SET_CUSTOMER_INFO_FEE_SPECIFIC_STORE_CARD       @"SET_CUSTOMER_INFO_FEE_SPECIFIC_STORE_CARD"

#define ASIHTTPREQUEST_DEBUG GCC_PREPROCESSOR_DEFINITIONS


#endif /* commonMacroDefine_h */
