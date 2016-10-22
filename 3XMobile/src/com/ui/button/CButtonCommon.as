package com.ui.button
{
	import flash.geom.Point;
	import flash.text.TextFormat;

	/**
	 * @author caihua
	 * @comment 通用按钮生成
	 * 创建时间：2014-6-10 上午11:19:07 
	 */
	public class CButtonCommon extends CButton
	{
		private var _name:String;
		private var _label:String;
		
		private static var BMDATA_LIST:Array = [
			//公用按钮
			{cname: "button.common" , size:new Point(804,2518)}, 
		];
		
		
		private static var BUTTON_LIST:Object = {
			add: new CButtonInfo(new Point(31,31),new Point(0,0),new Point(31,0),new Point(62,0),new Point(93,0) , null), 
			add2: new CButtonInfo(new Point(22,22),new Point(0,31),new Point(22,31),new Point(44,31),new Point(66,31) , null), 
			again: new CButtonInfo(new Point(30,30),new Point(0,53),new Point(30,53),new Point(60,53),new Point(90,53) , null), 
			blue: new CButtonInfo(new Point(108,38),new Point(0,83),new Point(108,83),new Point(216,83),new Point(324,83) , null), 
			blueshort: new CButtonInfo(new Point(71,38),new Point(0,121),new Point(71,121),new Point(142,121),new Point(213,121) , null), 
			close: new CButtonInfo(new Point(45,45),new Point(0,159),new Point(45,159),new Point(90,159),new Point(135,159) , null), 
			close1: new CButtonInfo(new Point(45,45),new Point(0,204),new Point(45,204),new Point(90,204),new Point(135,204) , null), 
			closeblue: new CButtonInfo(new Point(22,22),new Point(0,249),new Point(22,249),new Point(44,249),new Point(66,249) , null), 
			closered: new CButtonInfo(new Point(24,24),new Point(0,271),new Point(24,271),new Point(48,271),new Point(72,271) , null), 
			confirmyellow: new CButtonInfo(new Point(118,52),new Point(0,295),new Point(118,295),new Point(236,295),new Point(354,295) , null), 
			fullscreen: new CButtonInfo(new Point(27,27),new Point(0,347),new Point(27,347),new Point(54,347),new Point(81,347) , new Point(108,347)), 
			green: new CButtonInfo(new Point(108,38),new Point(0,374),new Point(108,374),new Point(216,374),new Point(324,374) , null), 
			greenshort: new CButtonInfo(new Point(71,38),new Point(0,412),new Point(71,412),new Point(142,412),new Point(213,412) , null), 
			left_small: new CButtonInfo(new Point(31,31),new Point(0,450),new Point(31,450),new Point(62,450),new Point(93,450) , null), 
			level_close: new CButtonInfo(new Point(30,30),new Point(0,481),new Point(30,481),new Point(60,481),new Point(90,481) , null), 
			level_music: new CButtonInfo(new Point(30,30),new Point(0,511),new Point(30,511),new Point(60,511),new Point(90,511) , new Point(120,511)), 
			level_set: new CButtonInfo(new Point(32,32),new Point(0,542),new Point(32,542),new Point(64,542),new Point(96,542) , null),
			level_sound: new CButtonInfo(new Point(30,30),new Point(0,574),new Point(30,574),new Point(60,574),new Point(90,574) , new Point(120,574)), 
			
			main_arena: new CButtonInfo(new Point(64,64),new Point(0,605),new Point(64,605),new Point(128,605),new Point(192,605) , null), 
			main_arena_silver: new CButtonInfo(new Point(64,64),new Point(0,669),new Point(64,669),new Point(128,669),new Point(192,669) , null), 
			main_code: new CButtonInfo(new Point(64,64),new Point(0,733),new Point(64,733),new Point(128,733),new Point(192,733) , null), 
			main_friendmessage: new CButtonInfo(new Point(64,64),new Point(0,797),new Point(64,797),new Point(128,797),new Point(192,797) , null), 
			main_gift: new CButtonInfo(new Point(64,64),new Point(0,861),new Point(64,861),new Point(128,861),new Point(192,861) , null), 
			main_giftcenter: new CButtonInfo(new Point(64,64),new Point(0,925),new Point(64,925),new Point(128,925),new Point(192,925) , null), 
			main_morefriend: new CButtonInfo(new Point(64,64),new Point(0,989),new Point(64,989),new Point(128,989),new Point(192,989) , null), 
			music: new CButtonInfo(new Point(27,27),new Point(0,1053),new Point(27,1053),new Point(54,1053),new Point(81,1053) , new Point(108,1053)), 
			musicgame: new CButtonInfo(new Point(27,27),new Point(0,1080),new Point(27,1080),new Point(54,1080),new Point(81,1080) , new Point(108,1080)), 
			
			next: new CButtonInfo(new Point(38,38),new Point(0,1107),new Point(38,1107),new Point(76,1107),new Point(114,1107) , null), 
			prev: new CButtonInfo(new Point(38,38),new Point(0,1145),new Point(38,1145),new Point(76,1145),new Point(114,1145) , null), 
			right_small: new CButtonInfo(new Point(31,31),new Point(0,1183),new Point(31,1183),new Point(62,1183),new Point(93,1183) , null),
			short: new CButtonInfo(new Point(76,38),new Point(0,1214),new Point(76,1214),new Point(152,1214),new Point(228,1214) , null), 
			slider: new CButtonInfo(new Point(20,28),new Point(0,1252),new Point(20,1252),new Point(40,1252),new Point(60,1252) , null), 
			slider_down: new CButtonInfo(new Point(26,27),new Point(0,1280),new Point(26,1280),new Point(52,1280),new Point(78,1280) , null), 
			slider_groove: new CButtonInfo(new Point(5,15),new Point(0,1307),new Point(5,1307),new Point(10,1307),new Point(15,1307) , null), 
			slider_up: new CButtonInfo(new Point(26,27),new Point(0,1322),new Point(26,1322),new Point(52,1322),new Point(78,1322) , null), 
			start: new CButtonInfo(new Point(155,53),new Point(0,1349),new Point(155,1349),new Point(310,1349),new Point(465,1349) , null), 
			subtract: new CButtonInfo(new Point(22,22),new Point(0,1402),new Point(22,1402),new Point(44,1402),new Point(66,1402) , null), 
			
			tab: new CButtonInfo(new Point(98,34),new Point(0,1424),new Point(98,1424),new Point(196,1424),new Point(294,1424) , new Point(392,1424)), 
			yellowlong: new CButtonInfo(new Point(185,53),new Point(0,1458),new Point(185,1458),new Point(370,1458),new Point(555,1458) , null),
			z_main_honor: new CButtonInfo(new Point(64,64),new Point(0,1511),new Point(64,1511),new Point(128,1511),new Point(192,1511) , null), 
			z_main_mail: new CButtonInfo(new Point(64,64),new Point(0,1575),new Point(64,1575),new Point(128,1575),new Point(192,1575) , null),
			z_n1_main_forum: new CButtonInfo(new Point(64,64),new Point(0,1639),new Point(64,1639),new Point(128,1639),new Point(192,1639) , null) ,
			z_n2_main_onekeyfillup: new CButtonInfo(new Point(64,64),new Point(0,1703),new Point(64,1703),new Point(128,1703),new Point(192,1703) , null),
			
			z_n3_tab: new CButtonInfo(new Point(90,35),new Point(0,1767),new Point(90,1767),new Point(180,1767),new Point(270,1767) , new Point(360,1767)),
			z_n4_area: new CButtonInfo(new Point(64,64),new Point(0,1802),new Point(64,1802),new Point(128,1802),new Point(192,1802) , null), 
			z_n5_quickstart: new CButtonInfo(new Point(136,126),new Point(0,1866),new Point(136,1866),new Point(272,1866),new Point(408,1866) , null), 
			z_n6_tab: new CButtonInfo(new Point(99,29),new Point(0,1992),new Point(99,1992),new Point(198,1992),new Point(297,1992) , new Point(396,1992)),
			z_n7_jump: new CButtonInfo(new Point(82,29),new Point(0,2021),new Point(82,2021),new Point(164,2021),new Point(246,2021) , null),
			
			z_n8_rule: new CButtonInfo(new Point(31,31),new Point(0,2050),new Point(31,2050),new Point(62,2050),new Point(93,2050) , null), 
			z_n90_last: new CButtonInfo(new Point(31,31),new Point(0,2081),new Point(31,2081),new Point(62,2081),new Point(93,2081) , null),  
			z_n91_first: new CButtonInfo(new Point(31,31),new Point(0,2112),new Point(31,2112),new Point(62,2112),new Point(93,2112) , null),
			z_n92_activity: new CButtonInfo(new Point(64,64),new Point(0,2143),new Point(64,2143),new Point(128,2143),new Point(192,2143) , null),
			z_n93_gps: new CButtonInfo(new Point(24,24),new Point(0,2207),new Point(24,2207),new Point(48,2207),new Point(72,2207) , null), 
			z_n94_addfriend: new CButtonInfo(new Point(24,24),new Point(0,2231),new Point(24,2231),new Point(48,2231),new Point(72,2231) , null), 
			z_n95_serieslogin: new CButtonInfo(new Point(64,64),new Point(0,2255),new Point(64,2255),new Point(128,2255),new Point(192,2255) , null),
			z_n96_close: new CButtonInfo(new Point(40,40),new Point(0,2319),new Point(40,2319),new Point(80,2319),new Point(120,2319) , null),
			z_n96_yingxiongbang: new CButtonInfo(new Point(64,64),new Point(0,2359),new Point(64,2359),new Point(128,2359),new Point(192,2359) , null), 
			z_n97_yellow: new CButtonInfo(new Point(108,39),new Point(0,2423),new Point(108,2423),new Point(216,2423),new Point(324,2423) , null),
			z_n98_invite: new CButtonInfo(new Point(201,56),new Point(0,2462),new Point(201,2462),new Point(402,2462),new Point(603,2462) , null)
		};
		
		
		private static var BUTTON_BMDATA_IDX:Object = {
			/*---公用按钮------ */
			add:0,
			blue: 0,
			blueshort: 0,
			close: 0,
			closeblue:0,
			closered:0,
			confirmyellow:0,
			fullscreen: 0,
			green: 0,
			greenshort: 0,
			left_small:0,
			music:0,
			musicgame:0,
			next:0,
			prev:0,
			right_small:0,
			short:0,
			slider:0,
			slider_groove:0,
			slider_up:0,
			start:0,
			tab:0,
			main_arena:0,
			main_code:0,
			main_friendmessage:0,
			main_gift:0,
			main_giftcenter:0,
			close1:0,
			yellowlong:0,
			main_morefriend:0,
			subtract:0
		};
		
		/**
		 * 构造函数
		 */
		public function CButtonCommon(name:String , text:String = "" , tf:TextFormat = null , glowColor:uint = 0x4c2807)
		{
			this.name = name;
			this._name = name;
			var idx:int = BUTTON_BMDATA_IDX[name];
			super(BMDATA_LIST[idx]["cname"], BMDATA_LIST[idx]["size"], BUTTON_LIST[name] , text , tf , glowColor);
		}
		
		public function setLabel(label:String):void
		{
			this._label = label;
		}
		
		public function get __name():String
		{
			return this._name;
		}
		
		public function get __label():String
		{
			return this._label;
		}
	}
}