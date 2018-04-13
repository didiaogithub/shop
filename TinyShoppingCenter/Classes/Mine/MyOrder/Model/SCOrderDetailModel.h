//
//  SCOrderDetailModel.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/26.
//  Copyright © 2017年 ckys. All rights reserved.
//

#import "BaseEncodeModel.h"

//订单中的商品
@interface CKGoodsDetailModel : BaseEncodeModel

/**商品名称*/
@property (nonatomic, copy) NSString *name;
/**购买数量*/
@property (nonatomic, copy) NSString *count;

@end

@interface CKOldDetailModel : BaseEncodeModel

/**原单单号*/
@property (nonatomic, copy) NSString *orderno;
/**原单金额*/
@property (nonatomic, copy) NSString *ordermoney;
/**原单商品购买详情*/
@property (nonatomic, strong) NSMutableArray<CKGoodsDetailModel*> *goodsArray;

@end

@interface CKChangeDetailModel : BaseEncodeModel

/**原单单号*/
@property (nonatomic, copy) NSString *orderno;
/**原单金额*/
@property (nonatomic, copy) NSString *ordermoney;
/**原单商品购买详情*/
@property (nonatomic, strong) NSMutableArray<CKGoodsDetailModel*> *goodsArray;

@end


@interface SCOrderDetailGoodsModel : BaseEncodeModel
/** 图片路径*/
@property (nonatomic, copy) NSString *path;
/** 规格*/
@property (nonatomic, copy) NSString *spec;
/** 数量*/
@property (nonatomic, copy) NSString *count;
/** 商品名称*/
@property (nonatomic, copy) NSString *name;
/** 商品id*/
@property (nonatomic, copy) NSString *itemid;
/** 商品金额*/
@property (nonatomic, copy) NSString *price;
/**是否有评论*/
@property (nonatomic, copy) NSString *iscomment;
/** 状态*/
@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *isoversea;
@end

@interface SCOrderDetailModel : BaseEncodeModel

@property (nonatomic, strong) NSMutableArray *itemlistArr;
/**订单id*/
@property (nonatomic, copy) NSString *Id;
/**订单no*/
@property (nonatomic, copy) NSString *no;
/**收货人*/
@property (nonatomic, copy) NSString *gettername;
/**收货电话*/
@property (nonatomic, copy) NSString *gettermobile;
/**收货地址*/
@property (nonatomic, copy) NSString *getteraddress;
/**总金额*/
@property (nonatomic, copy) NSString *ordermoney;
/**运费*/
@property (nonatomic, copy) NSString *transfee;
/**下单时间*/
@property (nonatomic, copy) NSString *ordertime;
/**物流信息*/
@property (nonatomic, copy) NSString *transmsg;
/**是否存在物流信息*/
@property (nonatomic, copy) NSString *iftransno;
/**订单状态*/
@property (nonatomic, copy) NSString *orderstatus;
/**支付方式*/
@property (nonatomic, copy) NSString *paymethod;
/**支付时间*/
@property (nonatomic, copy) NSString *paytime;
/**获取的积分数*/
@property (nonatomic, copy) NSString *integralnum;
/**是否可以修改地址*/
@property (nonatomic, copy) NSString *limittime;
/**优惠金额*/
@property (nonatomic, copy) NSString *favormoney;
/**实付金额*/
@property (nonatomic, copy) NSString *money;

//3.1.3新增
/**支付流水*/
@property (nonatomic, copy) NSString *payno;
/**原订单支付方式*/
@property (nonatomic, copy) NSString *paymethodold;
/**原订单支付时间*/
@property (nonatomic, copy) NSString *paytimeold;
/**原订单支付流水*/
@property (nonatomic, copy) NSString *paynoold;
/**物流单号*/
@property (nonatomic, copy) NSString *transno;
/**物流公司*/
@property (nonatomic, copy) NSString *transname;
/** 补差额*/
@property (nonatomic, copy) NSString *balancemoney;
/** 3:换货订单*/
@property (nonatomic, copy) NSString *orderfrom;

/**原单信息*/
@property (nonatomic, strong) NSMutableArray<CKOldDetailModel*> *olddetailArry;
/**新单信息*/
@property (nonatomic, strong) NSMutableArray<CKChangeDetailModel*> *newdetailArry;

@end
