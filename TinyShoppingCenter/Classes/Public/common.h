//
//  common.h
//  MoveShoppingMall
//
//  Created by 庞宏侠 on 17/2/7.
//  Copyright © 2017年 ckys. All rights reserved.
//
#define common_h

/* 网络环境0：测试，1：生产 */
#define AppEnvironment 0
/* 银联与银联Apple Pay环境："00" 表示线上环境"01"表示测试环境 */
#define UnionPayEnvironment @"00"
/* 两次刷新的时间间隔 */
#define Interval 5

#define shareSDKAppID @"16f95f8fa566e"
#define weiBoAppkey @"4079281429"
#define weiBoSecrete @"86938fa31195ded301855bcb2394cb75"
#define qqAppID @"1105610041"
#define qqAppKey @"9CUGfw8PtfHyaSt1"

//版本相关
#define ServerVersion @"YDSC_serverVersion"
#define Forceupdate @"YDSC_forceupdate"
#define CKLastVersionKey @"YDSC_lastVersion"
#define AppStoreUrl @"YDSC_appstoreurl"

/**微信授权登录,获取微信用户信息,移动商城的*/
#define kWXAPP_ID @"wx997fa1bb80ec9278"
#define kWXAPP_SECRET @"3032a3cadba21fcdd5fc362152e2c574"
#define WXCommercialTenantId @"1427373102"

//京东支付相关
//商户号：110440579
//APPID：JDJR110440579001
#define JDMerchantID @"110440579002"
#define JDAPPID @"JDJR110440579001"

//北京智齿客服appKey
#define WisdomTooth_AppKey @"78843e7d2f7a4f54bc894a34dbd2d968"
#define sysNum @"b96b3e57c0814d9d987bd21efc7c5934"

/**融云appkey*/
#define RONGCLOUD_IM_Appkey @"z3v5yqkbvsfv0"

#define DeviceId_UUID_Value [NSString stringWithFormat:@"%@",[getUUID getUUID]]

#define kWeiXinRefreshToken @"refresh_token"
#define KAccsess_token @"access_token"
#define KExpires_in @"expires_in"
#define KolderData @"older"


#define Kmobile @"CKSC_phone"
#define KnickName @"CKSC_nickName"
/**openid(通过微信授权获得)*/
#define KopenID @"CKSC_appopenid"
/**unionid(通过微信授权获得)*/
#define Kunionid @"CKSC_unionid"
#define kheamImageurl @"CKSC_headImageUrl"

#define KMyCouponList @"CKSC_myCouponList"


#define KloginStatus @"loginSuccess"

/**微信授权之后 跳转登录*/
#define WeiXinAuthSuccess @"WeiXinAuthSuccess"
/* 微信支付回调 */
#define WeiXinPay_CallBack @"weixinpay"
#define Alipay_CallBack @"AlipayBack"
#define UnionPay_CallBack @"UnionpayCallBack"


#define USER_DefaultAddress @"YDSC_DefaultAddress"
#define MallintegralShowOrNot @"mallintegralshow"


//适配缩放
#define SCREEN_WIDTH_SCALE SCREEN_WIDTH / 375.0
#define SCREEN_HEIGHT_SCALE SCREEN_HEIGHT / 667.0

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#define iOS7M ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
#define iOS8M ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
#define iOS9M ([[[UIDevice currentDevice]systemVersion]floatValue]>=9.0)


#define IPHONE_X [[SCCommon getCurrentDeviceModel] isEqualToString:@"iPhone_X"]

/**距离导航栏底部的距离*/
#define NaviHeight (IPHONE_X ? 88 : 64)
/**iphonex导航栏增加的高度*/
#define NaviAddHeight (IPHONE_X ? 24 : 0)
#define BOTTOM_BAR_HEIGHT (IPHONE_X ? 34 : 0)


//高度等于480
#define iphone4 ([UIScreen mainScreen].bounds.size.height == 480)
//高度大于480
#define iphone5 ([UIScreen mainScreen].bounds.size.height ==568)
//高度等于667
#define iphone6 ([UIScreen mainScreen].bounds.size.height ==667)
//高度大于667
#define iphone6Plus ([UIScreen mainScreen].bounds.size.height ==736)


/* --------------------字体配置-------------------- */
#define CHINESE_SYSTEM(x)       [UIFont systemFontOfSize:x]
#define CHINESE_SYSTEM_BOLD(x)  [UIFont boldSystemFontOfSize:x]

// 字体定义
#define MAIN_BODYTITLE_FONT [UIFont systemFontOfSize:15.0f]// 主标题 正文 文字
#define NORMAL_FONT       [UIFont systemFontOfSize:14.0f]// 主标题 正文 文字
#define MAIN_TITLE_FONT   [UIFont systemFontOfSize:15.0f]// 辅助文字
#define MAIN_SUBTITLE_FONT  [UIFont systemFontOfSize:13.0f]// 辅助说明文字

/* --------------------屏幕适配比例-------------------- */
//不同屏幕尺寸字体适配（375，667是因为效果图为IPHONE6系列 如果不是则根据实际情况修改）
#define kScreenWidthRatio       (SCREEN_WIDTH / 375.0)
#define kScreenHeightRatio      (SCREEN_HEIGHT / 667.0)
#define AdaptedWidth(x)         ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x)        ceilf((x) * kScreenHeightRatio)
/**主标题 正常字体 颜色*/
#define TitleColor CKYS_Color(50,53,56)
/**副标题 灰色字体颜色*/
#define SubTitleColor CKYS_Color(163,164,165)

//RGB color
#define CKYS_Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define KUserdefaults [NSUserDefaults standardUserDefaults]

#define APPKeyWindow [UIApplication sharedApplication].keyWindow
//通知
#define CKCNotificationCenter [NSNotificationCenter defaultCenter]

/**测试过可用地址*/
//审核用的openid
//#define OpenidForLogin @"000fDaw000ut5PMoH329jx0cjjomFeoX5L000"
//#define OpenidForRegist @"000qoaU000_wafWITA29bHyfQwyqwJomz8000"

#define OpenidForLogin @"b79wJqo042_waf8_ITA8_bHyfQwyqomz8500"
#define OpenidForRegist @"b79wJqo042_waf9_ITA9_bHyfQwyqomz9500"

////测试审核登录用的openid
//#define OpenidForLogin @"b507AmE000D0bD-CYaVp193YIRHNraoatK000"
//#define OpenidForRegist @"00016ks000AwjUdpUfkYCwbkDt5G-voP-L000"

/**请求的参数openid */
#define USER_OPENID  [KUserdefaults objectForKey:@"USER_OPENID"]

/**域名配置*/
#define WebServiceAPI [[DefaultValue shareInstance] domainName]
/**消息域名*/
#define MsgApi  [[DefaultValue shareInstance] domainSmsMessage]
/**微信支付宝域名*/
#define WebServicePayAPI [[DefaultValue shareInstance] domainNamePay]
/**银联、Apple Pay域名*/
#define WebServiceUnitPayAPI [[DefaultValue shareInstance] domainNameUnionPay]
/**上传图片域名*/
#define UploadImageDomain [[DefaultValue shareInstance] domainNameRes]

///**分享时的logo域名*/
#define ShareLogoUrl @"front/appmall/img/sharedefault.jpg"

/**判断ios是否在审核中*/
#define CheckSuccessCode @"200"
#define IsIosCheck_Url @"Wxmall/Login/isAppMaill3Check"

#define GetLoginType @"Wxmall/Login/getAppMallLoginType"

/**获取融云Token*/
#define getRongYunToken @"Msg/Msg/getUserToken"

/**首页弹出活动*/
#define ActivityUrl @"Wxmall/Index/getActivityItem"
/**启动页数据*/
#define AdUrl @"Wxmall/Index/getAdvertisementItem"

/**微信*/
#define payForJoinByWX_Url @"pay/appmall_pay/weixin/example/app.php"
/**支付宝*/
#define payForJoinByAli_Url @"pay/appmall_pay/alipay/app.php"
/**银联支付~*/
#define Uionpay_Url @"pay/appmall_pay/unionpay/pages/payinfo.php"
/**获取可用支付方式和版本号是否强制更新~*/
#define PayMethodUrl @"Wxmall/Index/getSomePath"


/**获取店铺所有者，用来判断和谁聊天*/
#define GetShopOwenerUrl @"Wxmall/User/getUserFromOpenid"
/**进店提醒*/
#define ShopNoticeUrl @"Wxmall/Index/actNotice"
/**商品首页*/
#define Home_Url @"Wxmall/Index/getIndex"
/**商品分类列表*/
#define CategoryUrl @"Wxmall/Item/getItem"
/**获取搜索热门标签*/
#define GetHotItemUrl @"Wxmall/User/getHotItem"
/**商品详情*/
#define GoodsDetailUrl @"Wxmall/Item/getItemById"
/**添加收藏*/
#define AddCollectionUrl @"Wxmall/Collection/addCollection"
/**取消收藏*/
#define CancelCollectionUrl @"Wxmall/Collection/cancelCollection"
/**收藏列表*/
#define GetCollecListUrl @"Wxmall/Collection/getCollection"
/**评论列表*/
#define CommentListUrl @"Wxmall/Item/getCommentByItemId"
/**添加到购物车*/
#define AddToShoppingCarUrl @"Wxmall/ShoppingCart/addShoppingCart"
/**获取购物车列表*/
#define GetShoppingCarUrl @"Wxmall/ShoppingCart/getShoppingCart"
/**删除购物车商品*/
#define DelShoppingCarUrl @"Wxmall/ShoppingCart/delShoppingCart"
/**修改*/
//#define UpdateShoppingCarUrl @"Wxmall/ShoppingCart/updateShoppingCart"
#define UpdateShoppingCarInfoUrl @"Wxmall/ShoppingCart/updateShoppingCartInfo"

/**如果id不存在，openid为必填，查询指定人的默认地址*/
#define GetDefaultAddrUrl @"Wxmall/Address/getAddressById"
/**获取地址列表*/
#define GetAddrListUrl @"Wxmall/Address/getAddressList"
/**删除地址*/
#define DeleAddrUrl @"Wxmall/Address/deleteAddress"
/**修改地址*/
#define UpdateAddrUrl @"Wxmall/Address/updateAddress"
/**添加收货地址*/
#define AddAddrUrl @"Wxmall/Address/address"
/**生成活动订单*/
#define AddActiveOrderUrl @"Wxmall/Order/addOrderByActivity"
/**直接生成订单*/
#define AddOrderUrl @"Wxmall/Order/addOrder"
/**购物车生成订单*/
#define ShoppingCarAddOrderUrl @"Wxmall/Order/addOrderTwo"
/**积分商品生成订单*/
#define IntegralGoodsAddOrderUrl @"Wxmall/Order/addOrderFour"
/**奖励商品生成订单*/
#define MyPrizeGoodsAddOrderUrl @"Wxmall/Order/addOrderThree"
/**订单列表*/
#define GetOrderListUrl @"Wxmall/Order/getOrderList"
/**订单详情*/
#define OrderDetailUrl @"Wxmall/Order/getOrderById"
/**确认收货*/
#define ConfirmReceiveUrl @"Wxmall/Order/confirmOrderItem"
/**删除订单*/
#define DelOrderUrl @"Wxmall/Order/delOrder"
/**取消订单*/
#define CancelOrderUrl @"Wxmall/Order/cancelOrder"
/**发表评论*/
#define AddCommentUrl @"Wxmall/Order/addCommentByOrder"
/**退换货申请*/
#define ReturnOrderUrl @"Wxmall/Order/addRefurnItem"
/**退货默认原因*/
#define ReturnReasonUrl @"Wxmall/Item/getReturnReason"
/**签到*/
#define SignUrl @"Wxmall/Integral/signIn"
/**获取积分*/
#define GetMemberPointUrl @"Wxmall/Integral/getIntegral"
/**获取个人信息*/
#define GetMeInfoUrl @"Wxmall/User/getMeInfo"
/**更新个人信息*/
#define UpdateMeInfoUrl @"Wxmall/User/updateMeInfo"
/**上传评价图片*/
#define UploadImageUrl @"Resource/CkApp/uploadPhoto"
/**手机验证码*/
#define PhoneLoginUrl @"Wxmall/Login/userLogin" //@"Wxmall/Login/userLoginNew"
/**获取省  市  区  列表*/
#define GetAreaUrl @"Wxmall/Index/getAreaList"
/**获取物流信息*/
#define getLogisticsInfo_Url @"Wxmall/Order/getLogistics"

/**上传错误日志~*/  //暂时不用
#define UploadErrorLog @"Ckapp3/Index/uploadData"
/**更新订单地址~*/
#define updateOrderAddress_Url @"Wxmall/Order/updateOrderAddress"
/**获取积分商城商品列表~*/
#define GetIntegralGoodsList @"Wxmall/IntegralItem/getGoodList"
/**获取奖品商品列表~*/
#define GetMyPrizeGoodsList @"Wxmall/IntegralItem/getPrizeList"
//优惠券
/**根据订单情况获取可用优惠券*/
#define GetCanUseCoupons @"Wxmall/Coupon/getCouponsByUse"
/**获取优惠券详情*/
#define GetCouponInfoById @"Wxmall/Coupon/getCouponInfoById"
/**获取优惠券列表*/
#define GetMyCoupons @"Wxmall/Coupon/getMyCoupons"
/**删除优惠券*/
#define DeleteMyCoupons @"Wxmall/Coupon/deleteCoupons"
/**获取使用优惠券后的支付金额*/
#define GetOrderPayMoneyById @"Wxmall/Order/getOrderPayMoneyById"

//**融云聊天的默认头像*/
#define DefaultHeadPath @"/front/appmall/img/defaultimg.pngg"

/**未测试过的接口与域名*****************/

#define BaseImagestr_Url @"http://ckysre.ckc8.com/ckc3/Uploads/"
//*线下测试域名地址
#define WebOfflineServiceAPI @"http://testofflineckysappserver.ckc8.com/"
/**下载图片资源路径*/
#define Base_Imagestr_Url @"http://ckysre.ckc8.com/ckc3/Uploads/"
/**未测试过的接口与域名****************/
/**检测当前收货人是否实名认证（海外购的需要）*/
#define GetRealName @"Wxmall/OrderRealname/getRealname"
#define AddRealName @"Wxmall/OrderRealname/addRealname"

#define getMyTeamCkList_Url @"Ckapp3/CkInfo/getMyTeamCkList"

#define NetWorkNotReachable @"当前网络不可用，请检查你的网络设置"
#define NetWorkTimeout @"网络不给力，请稍后再试"



/**判空处理*/
#define IsNilOrNull(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]])  || ([(_ref) isKindOfClass:[NSNull class]]) || ([(_ref) isEqualToString:@"(null)"]) || ([(_ref) isEqualToString:@""]) || ([(_ref) isEqualToString:@"null"]) || ([(_ref) isEqualToString:@"<null>"]))


//debug状态输出log，release状态屏蔽log
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()




#endif /* common_h */
