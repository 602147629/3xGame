package com.ui.item
{
	import com.game.module.CDataManager;
	import com.netease.protobuf.UInt64;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CLoadImage;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import framework.fibre.core.Notification;
	import framework.rpc.DataUtil;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.notification.GameNotification;
	
	import qihoo.gamelobby.protos.UserOrigin;
	import qihoo.triplecleangame.protos.CMsgFriendStarInfoResponse;
	import qihoo.triplecleangame.protos.CMsgGetNameImageResponse;
	import qihoo.triplecleangame.protos.CMsgSendPlayerOrigin;

	/**
	 * @author caihua
	 * @comment 好友item
	 * 创建时间：2014-6-10 下午2:07:19 
	 */
	public class CItemFriend extends CItemAbstract
	{
		private var _fid:UInt64;
		private var _icon:String = "";
		private var _name:String = "";
		private var _imgSize:Point;
		private var _selected:Boolean = false;
		private var _clsKey:String = "";
		//显示浮窗
		private var _isShowTips:Boolean = false;
		
		private var _flowTipItem:CItemFlowTip;
		private var _hasTip:Boolean;
		
		private var _imgMsgOK:Boolean = false;
		private var _typeMsgOK:Boolean = false;
		
		private var typeMsg:CMsgSendPlayerOrigin;

		private var imgMsg:CMsgGetNameImageResponse;
		
		private var _selfSatisfy:Boolean = false;
		
		/**
		 * item.friend ： 主场景中下面的头像框
		 * item.friend.mini : 很小的框，没有名字
		 * item.friend.mini2 : 很小的框，没有名字
		 * item.friend.help : 中等框
		 * item.friend.bar  : 藤条上的人头
		 * selfSatisfy : 是否自己取数据
		 * 默认大小是48
		 */
		public function CItemFriend(fid:UInt64 , clsKey:String = "item.friend.help", size:Point = null , showTip:Boolean = true , selfSatisfy:Boolean = true)
		{
			this._fid = fid;
			this._imgSize = size;
			
			_clsKey = clsKey;
			
			_isShowTips = showTip;
			
			_selfSatisfy = selfSatisfy;
			
			super(_clsKey);
		}
		
		override protected function drawContent():void
		{
			var tf:TextFormat = new TextFormat();
			tf.color = 0xffffff;
			if(mc.starNum)
			{
				mc.starNum.setTextFormat(tf);
			}
			
			if(_clsKey == "item.friend")
			{
				this.mc.fname.setTextFormat(tf);
			}
			
			if(mc.duigou)
			{
				mc.duigou.visible = false;
			}
			
			var bg:Bitmap = CScaleImageUtil.CScaleImageFromClass(ConstantUI.BMD_FLOWTIP_UI_SCALE , 
				new Rectangle(14 , 14 , 2,2) , 
				new Point(107,19.55));
			
			bg.visible = false;
			
			CBaseUtil.regEvent(GameNotification.EVENT_FRIEND_IMG_NAME , __showImgAndIcon);
			CBaseUtil.regEvent(GameNotification.EVENT_FRIEND_STAR_INFO , __showStarInfo);
			CBaseUtil.regEvent(GameNotification.EVENT_USER_TYPE , __showUserName);
			
			update();
			
			setEnabled();
			
			if(_isShowTips)
			{
				this.addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
				this.addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
			}
		}
		
		public function update():void
		{
			if(this._fid)
			{
				_name = CDataManager.getInstance().dataOfFriendList.getName(_fid);
				if(_name != "")
				{
					_typeMsgOK = true;
					__refreshName();
				}
				
				imgMsg = CBaseUtil.getImageAndName(_fid);
				if(imgMsg)
				{
					_imgMsgOK = true;
					__drawImg();
					__refreshName();
				}
				
				//取好友的星值
				if(_clsKey == "item.friend")
				{
					var star:int = CBaseUtil.getFriendStar(_fid);
					CBaseUtil.toNumber2(DataUtil.instance.myUserID) == CBaseUtil.toNumber2(_fid)
					{
						star = CDataManager.getInstance().dataOfGameUser.totalStar;
					}
					
					if(star == -1)
					{
						star = 0;
					}
					
					mc.starNum.text = ""+star;
				}
			}
		}
		
		private function __showImgAndIcon(d:Notification):void
		{
			var data:Object = d.data;
			if(data.message && CBaseUtil.toNumber2(data.message.userQID) == CBaseUtil.toNumber2(_fid))
			{
				
				imgMsg = data.message;
				_imgMsgOK = true;
				
				if(imgMsg.name != "")
				{
					_name = imgMsg.name;
				}
				
				__refreshName();
				
				__drawImg();
			}
		}
		
		private function __showStarInfo(d:Notification):void
		{
			var message:CMsgFriendStarInfoResponse = d.data.message;
			if(_clsKey == "item.friend" && CBaseUtil.toNumber2(message.qid) == CBaseUtil.toNumber2(this._fid))
			{
				mc.starNum.text = message.totoalStar;
			}
		}
		
		private function __showUserName(d:Notification):void
		{
			var data:Object = d.data;
			if(data.message && CBaseUtil.toNumber2(data.message.qid) == CBaseUtil.toNumber2(_fid))
			{
				
				typeMsg = data.message;
				_typeMsgOK = true;
				
				__refreshName();
			}
		}
		
		//刷新名字
		private function __refreshName():void
		{
			if(_typeMsgOK && _imgMsgOK)
			{
				__drawName();
			}
		}
		
		private function __drawName():void
		{
			if( !_name)
			{
				//需要判断是否是注册用户
				if(typeMsg && typeMsg.origin != UserOrigin.UserOrigin_Visitor)
				{
					_name = "用户~"+(CBaseUtil.toNumber2(_fid)+ 195);
				}
				else
				{
					_name = "游客~" + CBaseUtil.toNumber2(_fid);
				}
			}
			
			if(this.mc.fname != null)
			{
				this.mc.fname.text = _name;
			}
			
			CDataManager.getInstance().dataOfFriendList.cacheName(_fid , _name);
		}
		
		
		private function __drawImg():void
		{
			_icon = getImgUrl(imgMsg);
			if(_icon!="")
			{
				var img:CLoadImage = new CLoadImage(_icon , 48 , 48 , true , 0);
				if(_imgSize != null)
				{
					img.width = _imgSize.x + 3;
					img.height = _imgSize.y + 3;
				}
				
				mc.imgpos.addChild(img);
			}
			else
			{
				var cls:Class = ResHandler.getClass("bmd.defaultHead");
				var defaultBmp:Bitmap = new Bitmap(new cls());
				if(_imgSize != null)
				{
					defaultBmp.width = _imgSize.x + 3;
					defaultBmp.height = _imgSize.y + 3;
				}
				else
				{
					defaultBmp.width = 52;
					defaultBmp.height = 50;
				}
				mc.imgpos.addChild(defaultBmp);
			}
		}
		
		private function getImgUrl(msg:CMsgGetNameImageResponse):String
		{
			if(!_imgSize)
			{
				return msg.image48;
			}
			
			var width:int = _imgSize.x;
			
			if(width <= 20)
			{
				return msg.image20;
			}
			else if(width > 20 && width <= 48)
			{
				return msg.image48;
			}
			else if(width > 48 && width <= 80)
			{
				return msg.image80;
			}
			else
			{
				return msg.image150;
			}
		}
		
		public function setEnabled():void
		{
			mc.enabled = true;
			mc.buttonMode = true;
			mc.mouseChildren = false;
			mc.mouseEnabled = false;
		}
		
		public function set selected(selected:Boolean):void
		{
			_selected = selected;
			mc.duigou.visible = selected;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}

		public function get fid():UInt64
		{
			return _fid;
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			toggleTip();
		}
		
		public function toggleTip():void
		{
			if(!_hasTip)
			{
				_hasTip = true;
				
				var pos:Point = this.localToGlobal(new Point(0 , 10));
				
				if(_clsKey == "item.friend.bar")
				{
					CBaseUtil.showTip(_name ,pos,new Point(160 , 20) ,true , "left" , false);
				}
				else if(_clsKey == "item.friend.mini" || _clsKey == "item.friend.mini2")
				{
					CBaseUtil.showTip(_name ,this.localToGlobal(new Point(32 , 5)),new Point(160 , 20) ,true , "right" , false);
				}
				else
				{
					CBaseUtil.showTip(_name ,pos, new Point(160 , 20) ,true , "up" , false);
				}
			}
			else
			{
				_hasTip = false;
				CBaseUtil.closeTip()
			}
			
		}
		
		override protected function dispose():void
		{
			CBaseUtil.removeEvent(GameNotification.EVENT_FRIEND_IMG_NAME , __showImgAndIcon);
			CBaseUtil.removeEvent(GameNotification.EVENT_FRIEND_STAR_INFO , __showStarInfo);
			CBaseUtil.removeEvent(GameNotification.EVENT_USER_TYPE , __showUserName);
		}
	}
}