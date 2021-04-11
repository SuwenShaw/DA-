-- 订单信息表
CREATE TABLE IF NOT EXISTS `dim_order_info`  (
  `id` int NOT NULL,
  `order_no` varchar(50) NULL,
  `person_id` varchar(50) NULL,
  `status` varchar(20) NULL COMMENT '订单状态',
  `source` varchar(50) NULL COMMENT '来源，如 app web',
  `payment` double NULL COMMENT '实际支付金额',
  `channel` varchar(20) NULL COMMENT '渠道',
  `store` varchar(50) NULL COMMENT '下单门店 code',
  `amount` int NULL COMMENT '产品总件数',
  `ship_no` int NULL COMMENT '快递号',
  `delivery_type` varchar(255) NULL COMMENT '快递类型',
  `delivery_address_id` varchar(255) NULL COMMENT '收货地址 id',
  `delivery_mobile` varchar(50) NULL COMMENT '收获手机号',
  `delivery_time` timestamp NULL COMMENT '发货时间',
  `payment_time` timestamp NULL COMMENT '支付时间',
  `created_time` timestamp NULL COMMENT '创建时间',
  `updated_time` timestamp NULL COMMENT '更新时间',
  `remark` varchar(255) NULL COMMENT '备注',
  `payment_type` varchar(255) NULL COMMENT '付款方式',
  `payment_account` varchar(255) NULL COMMENT '付款账号',
  PRIMARY KEY (`id`)
);


-- 订单明细表
-- 记录订单明细
CREATE TABLE IF NOT EXISTS `fact_order_detail_info`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_detail_no` varchar(0) NULL,
  `order_no` varchar(0) NULL,
  `person_id` varchar(0) NULL,
  `status` varchar(20) NULL COMMENT '状态',
  `store` varchar(255) NULL COMMENT '门店编码',
  `source` varchar(255) NULL COMMENT '来源,如 app web',
  `total_price` double NULL COMMENT '实付金额',
  `amount` int NULL COMMENT '产品件数',
  `sku_code` int NULL COMMENT '产品编码',
  `price` double NULL COMMENT '单价',
  `delivery_no` varchar(255) NULL COMMENT '快递号',
  `delivery_type` varchar(30) NULL COMMENT '快递类型',
  `is_delivery_insurance` int NULL COMMENT '是否具有运费险',
  `delivery_address_id` varchar(255) NULL COMMENT '收货地址id',
  `delivery_mobile` varchar(255) NULL COMMENT '收货手机号',
  `delivery_time` timestamp NULL COMMENT '收货时间',
  `payment_time` timestamp NULL COMMENT '支付时间',
  `created_time` timestamp NULL COMMENT '创建时间',
  `updated_time` timestamp NULL COMMENT '更新时间',
  `remark` varchar(255) NULL COMMENT '备注',
  `payment_type` varchar(20) NULL COMMENT '支付类型',
  `payment_account` varchar(255) NULL COMMENT '支付账号',
  PRIMARY KEY (`id`)
);


-- 收货地址信息表
-- 管理收货地址信息
CREATE TABLE IF NOT EXISTS `fact_delivery_address_info`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `delivery_address_id` varchar(255) NULL,
  `delivery_name` varchar(255) NULL COMMENT '收货人名字',
  `country` varchar(255) NULL COMMENT '国家',
  `province` varchar(255) NULL COMMENT '省份',
  `city` varchar(255) NULL COMMENT '城市',
  `county` varchar(255) NULL COMMENT '县/区',
  `street` varchar(255) NULL COMMENT '街道',
  `detail_address` varchar(255) NULL COMMENT '详细地址',
  `address_label` varchar(255) NULL COMMENT '地址标签',
  `is_default_address` varchar(255) NULL COMMENT '是否为默认地址',
  `created_time` timestamp NULL COMMENT '创建时间',
  `updated_time` timestamp NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
);

-- 产品信息表
CREATE TABLE IF NOT EXISTS `fact_product_info`  (
  `id` int NOT NULL,
  `sku_code` varchar(255) NULL COMMENT '产品编码',
  `name` varchar(255) NULL COMMENT '产品名字',
  `category1` varchar(255) NULL COMMENT '一级分类',
  `category2` varchar(255) NULL COMMENT '二级分类',
  `price` double NULL COMMENT '单价',
  `color` varchar(255) NULL COMMENT '颜色',
  `size` varchar(255) NULL COMMENT '尺码',
  `created_time` timestamp NULL COMMENT '创建时间',
  `updated_time` timestamp NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
);

-- 门店信息表
CREATE TABLE IF NOT EXISTS `fact_store_info`  (
  `id` int NOT NULL,
  `name` varchar(255) NULL COMMENT '门店名字',
  `store_no` varchar(255) NULL COMMENT '门店编码',
  `province` varchar(255) NULL COMMENT '所属省份',
  `city` varchar(255) NULL COMMENT '所属城市',
  `channel` varchar(255) NULL COMMENT '所属渠道',
  `created_time` timestamp NULL COMMENT '创建时间',
  `updated_time` timestamp NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
);

-- 用户信息表
CREATE TABLE IF NOT EXISTS `fact_person_info`  (
  `id` int NOT NULL,
  `person_id` varchar(255) NULL COMMENT '顾客编码',
  `account_id` varchar(255) NULL COMMENT '账户编码',
  `nick_name` varchar(255) NULL COMMENT '账户昵称',
  `real_name` varchar(255) NULL COMMENT '名字',
  `is_member` char(10) NULL COMMENT '是否为会员',
  `status` varchar(20) NULL COMMENT '状态',
  `gender` varchar(20) NULL COMMENT '性别',
  `mobile` varchar(255) NULL COMMENT '手机号码',
  `email` varchar(255) NULL COMMENT '邮箱',
  `store` varchar(255) NULL COMMENT '注册门店',
  `is_black_list` varchar(255) NULL COMMENT '是否在黑名单中',
  `country` varchar(255) NULL COMMENT '所在国家',
  `province` varchar(255) NULL COMMENT '所在省份',
  `city` varchar(255) NULL COMMENT '所在城市',
  `remark` varchar(255) NULL COMMENT '备注',
  `birthday` timestamp NULL COMMENT '出生年月',
  `created_time` timestamp NULL COMMENT '创建时间',
  `updated_time` timestamp NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
);


-- 广告日志信息表(APP端)
-- 收集广告投放信息
CREATE TABLE IF NOT EXISTS `ad_app_log`  (
  `id` int NOT NULL,
  `user_id` varchar(255) NULL,
  `device_id` varchar(255) NULL COMMENT '设备id',
  `device_type` varchar(255) NULL COMMENT '设备类型',
  `op_time` varchar(255) NULL COMMENT '操作时间',
  `op_type` varchar(255) NULL COMMENT '操作类型，如曝光、点击',
  `source` varchar(255) NULL COMMENT '来源，如 weibo douyin',
  `ip` varchar(255) NULL COMMENT 'ip 地址',
  `province` varchar(255) NULL COMMENT 'ip地址解析出来的省份',
  `city` varchar(255) NULL COMMENT 'ip 地址解析出来的城市',
  `longitude` varchar(255) NULL COMMENT '经度',
  `latitude` varchar(255) NULL COMMENT '纬度',
  `os` varchar(255) NULL COMMENT '操作系统',
  `mac` varchar(255) NULL COMMENT '物理地址',
  PRIMARY KEY (`id`)
);

-- app 行为日志表
-- 记录用户在 app 的行为
CREATE TABLE IF NOT EXISTS `app_action_log`  (
  `id` int NOT NULL,
  `os` varchar(255) NULL COMMENT '操作系统',
  `user_id` varchar(255) NULL COMMENT '用户名',
  `device_id` varchar(255) NULL COMMENT '设备号',
  `device_type` varchar(255) NULL COMMENT '设备类型',
  `page_name` varchar(255) NULL COMMENT '页面名称',
  `source_url` varchar(255) NULL COMMENT '上一个 url',
  `url` varchar(255) NULL COMMENT '当前url',
  `visit_time` timestamp NULL COMMENT '访问时间',
  `created_time` timestamp NULL COMMENT '创建时间',
  `ip` varchar(255) NULL COMMENT 'ip 地址',
  `province` varchar(255) NULL COMMENT 'IP 解析获取到的城市',
  `city` varchar(255) NULL COMMENT 'IP 解析获取到的城市',
  `longitude` varchar(255) NULL COMMENT '经度',
  `latitude` varchar(255) NULL COMMENT '纬度',
  `mac` varchar(255) NULL COMMENT 'mac地址',
  PRIMARY KEY (`id`)
);

-- web 端行为日志表
-- 记录用户在 web 端的行为
CREATE TABLE IF NOT EXISTS `web_action_log`  (
  `id` int NOT NULL,
  `os` varchar(255) NULL COMMENT '操作系统',
  `user_id` varchar(255) NULL COMMENT '用户名',
  `browser` varchar(255) NULL COMMENT '浏览器版本',
  `page_name` varchar(255) NULL COMMENT '页面名称',
  `source_url` varchar(255) NULL COMMENT '上一个 url',
  `url` varchar(255) NULL COMMENT '当前url',
  `cookie` varchar(255) NULL COMMENT '会话 id',
  `visit_time` timestamp NULL COMMENT '访问时间',
  `created_time` timestamp NULL COMMENT '创建时间',
  `ip` varchar(255) NULL COMMENT 'ip 地址',
  `province` varchar(255) NULL COMMENT 'IP 解析获取到的城市',
  `city` varchar(255) NULL COMMENT 'IP 解析获取到的城市',
  `longitude` varchar(255) NULL COMMENT '经度',
  `latitude` varchar(255) NULL COMMENT '纬度',
  `mac` varchar(255) NULL COMMENT 'mac地址',
  PRIMARY KEY (`id`)
);

-- 手机号设备号映射表
CREATE TABLE IF NOT EXISTS `moible_device_mapping`  (
  `id` int NOT NULL,
  `mobile_md5` varchar(255) NULL COMMENT 'md5加密后的手机号',
  `device_id` varchar(255) NULL COMMENT '设备号',
  `device_type` varchar(255) NULL COMMENT '设备类型,如 IMEI IDFA',
  PRIMARY KEY (`id`)
);

ALTER TABLE `app_action_log` ADD CONSTRAINT `fk_app_action_log_fact_person_info_1` FOREIGN KEY (`user_id`) REFERENCES `fact_person_info` (`person_id`);
ALTER TABLE `dim_order_info` ADD CONSTRAINT `fk_dim_order_info_fact_order_detail_info_1` FOREIGN KEY (`order_no`) REFERENCES `fact_order_detail_info` (`order_no`);
ALTER TABLE `fact_delivery_address_info` ADD CONSTRAINT `fk_fact_delivery_address_info_dim_order_info_1` FOREIGN KEY (`delivery_address_id`) REFERENCES `dim_order_info` (`delivery_address_id`);
ALTER TABLE `fact_order_detail_info` ADD CONSTRAINT `fk_fact_order_detail_info_fact_store_info_1` FOREIGN KEY (`store`) REFERENCES `fact_store_info` (`store_no`);
ALTER TABLE `fact_order_detail_info` ADD CONSTRAINT `fk_fact_order_detail_info_fact_store_info_copy_1_1` FOREIGN KEY (`sku_code`) REFERENCES `fact_product_info` (`sku_code`);
ALTER TABLE `fact_person_info` ADD CONSTRAINT `fk_fact_person_info_dim_order_info_1` FOREIGN KEY (`person_id`) REFERENCES `dim_order_info` (`person_id`);
ALTER TABLE `moible_device_mapping` ADD CONSTRAINT `fk_moible_device_mapping_ad_app_log_1` FOREIGN KEY (`device_id`) REFERENCES `ad_app_log` (`device_id`);
ALTER TABLE `moible_device_mapping` ADD CONSTRAINT `fk_moible_device_mapping_fact_person_info_1` FOREIGN KEY (`mobile_md5`) REFERENCES `fact_person_info` (`mobile`);
ALTER TABLE `web_action_log` ADD CONSTRAINT `fk_web_action_log_fact_person_info_1` FOREIGN KEY (`user_id`) REFERENCES `fact_person_info` (`person_id`);

