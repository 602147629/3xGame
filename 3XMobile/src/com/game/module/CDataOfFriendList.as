package com.game.module
{
	import com.netease.protobuf.UInt64;
	import com.ui.util.CBaseUtil;
	
	import qihoo.triplecleangame.protos.CMsgGetFriendListResponse;
	import qihoo.triplecleangame.protos.CMsgGetNameImageResponse;
	import qihoo.triplecleangame.protos.PBFriendList;
	import qihoo.triplecleangame.protos.PBRequestInfo;
	
	import time.HashMap;

	/**
	 * @author caihua
	 * @comment 好友列表
	 * 创建时间：2014-7-4 下午4:29:10 
	 */
	public class CDataOfFriendList extends CDataBase
	{
		//存的是qid
		private var _friendList:Array;
		
		//请求添加我为好友的列表
		private var _msgFriendAskToMakeFriendsList:Array;
		
		//每日送给我道具的好友列表 dayReceivedList
		private var _msgFriendSendMeGiftList:Array;
		
		//每日我送出礼物的好友列表 daySendList
		private var _msgMeSendFriendGiftList:Array;
		
		//存放的是哪些好友像我索要了多少个什么道具   dayRequestInfoList
		private var _msgFriendAskMeToSendList:Array;
		
		//存放今天我问谁要了礼物
		private var _msgMeAskFrindToSendGiftList:Array;
		
		//每日已获得的礼物数
		private var _dayGetCount:int = 0;
		
		//每日已赠送的礼物数
		private var _daySendCount:int = 0;
		
		//好友邀请我的 好友列表 invitedList
		private var _msgFriendInvitMeList:Array;
		
		//好友的头像和名字缓存
		private var _imgCache:HashMap;
		
		private var _nameCache:HashMap;
		private var _starCache:HashMap;
		
		
		public function CDataOfFriendList()
		{
			super("CDataOfFriendList");
			
//			if(Debug.isDebug)
			{
				init();
			}
		}
		
		public function init():void
		{
			_friendList = new Array();
			_msgFriendAskToMakeFriendsList = new Array();
			_msgFriendInvitMeList = new Array();
			_msgFriendSendMeGiftList = new Array();
			_msgFriendAskMeToSendList = new Array();
			_msgMeAskFrindToSendGiftList = new Array();
			
			_imgCache = new HashMap();
			_nameCache = new HashMap();
			_starCache = new HashMap();
		}
		
		public function delFriend(fid:UInt64):void
		{
			for(var i:int = 0 ; i < _friendList.length ; i++)
			{
				if(CBaseUtil.toNumber2(_friendList[i]) == CBaseUtil.toNumber2(fid))
				{
					_friendList.splice(i);
				}
			}
		}
		
		public function cacheImg(fid:UInt64 , imgObj:CMsgGetNameImageResponse):void
		{
			_imgCache.put(CBaseUtil.toNumber2(fid) , imgObj);
		}
		
		/**
		 * 从缓存取头像和名字
		 */
		public function getImg(fid:UInt64):CMsgGetNameImageResponse
		{
			var imgObject:CMsgGetNameImageResponse = _imgCache.get(CBaseUtil.toNumber2(fid) , null);
			return imgObject;
		}
		
		public function cacheName(fid:UInt64 , fname:String):void
		{
			if(_nameCache.get(CBaseUtil.toNumber2(fid) , "") != "")
			{
				return;
			}
			_nameCache.put(CBaseUtil.toNumber2(fid) , fname);
		}
		
		public function getName(fid:UInt64):String
		{
			var fname:String = _nameCache.get(CBaseUtil.toNumber2(fid) , "");
			return fname;
		}
		
		public function cacheStar(fid:UInt64 , starNum:int):void
		{
			_starCache.put(CBaseUtil.toNumber2(fid) , starNum);
		}
		
		public function getStar(fid:UInt64):int
		{
			var starNum:int = _starCache.get(CBaseUtil.toNumber2(fid) , -1);
			return starNum;
		}
		
		public function addFriend(fid:UInt64):void
		{
			_friendList.unshift(fid);
		}
		
		public function getFriendList(num:int = 12):Array
		{
			return _friendList;
		}
		
		public function serilization(list:CMsgGetFriendListResponse):void
		{
			init();
			
			if(list)
			{
				for(var i:int =0 ; i < list.friendList.length ; i++)
				{
					var pbStarArray:PBFriendList  = list.friendList[i] as PBFriendList;
					_friendList.push(pbStarArray.qid);
				}
				
				_msgFriendAskToMakeFriendsList = list.requestAddList;
				_msgFriendInvitMeList = list.invitedList;
				_msgFriendSendMeGiftList = list.dayReceivedList;
				_msgFriendAskMeToSendList = list.dayRequestInfoList;
				_dayGetCount = list.dayGetCount;
				_daySendCount = list.daySendCount;
			}
		}
		
		public function delKeyInArray(arr:Array , fid:UInt64):void
		{
			for( var i:int =0 ; i < arr.length ; i ++)
			{
				if(CBaseUtil.toNumber2(arr[i].qid) ==CBaseUtil.toNumber2(fid) )
				{
					arr.splice(i-1 , 1);
					break;
				}
			}
		}
		
		/**
		 * 新的好友让我送礼物
		 */
		public function addNewToFriendAskMeToSendList(fid:UInt64 , itemid:int , itemnum:int = 1):void
		{
			var msg:PBRequestInfo = new PBRequestInfo();
			msg.qid = fid;
			msg.itemID = itemid;
			msg.itemNum = itemnum;
			_msgFriendAskMeToSendList.unshift(msg);
		}
		
		/**
		 * 是否是好友关系
		 */
		public function isFriend(fid:UInt64):Boolean
		{
			for( var i:int =0 ; i < _friendList.length ; i ++)
			{
				if(CBaseUtil.toNumber2(_friendList[i]) == CBaseUtil.toNumber2(fid) )
				{
					return true;
				}
			}
			return false;
		}

		public function get msgFriendAskToMakeFriendsList():Array
		{
			return _msgFriendAskToMakeFriendsList;
		}

		public function get msgFriendSendMeGift():Array
		{
			return _msgFriendInvitMeList;
		}

		public function get msgFriendSendMeGiftList():Array
		{
			return _msgFriendSendMeGiftList;
		}

		public function get msgFriendAskMeToSendList():Array
		{
			return _msgFriendAskMeToSendList;
		}

		public function get dayGetCount():int
		{
			return _dayGetCount;
		}

		public function get daySendCount():int
		{
			return _daySendCount;
		}

		/**
		 * 添加好友到，我请求好友送礼物的列表中
		 */
		public function addFriendToMeAskFrindToSendGiftList(fid:UInt64):void
		{
			_msgMeAskFrindToSendGiftList.unshift(fid);
		}
		
		public function get msgMeAskFrindToSendGiftList():Array
		{
			return _msgMeAskFrindToSendGiftList;
		}

	}
}