package com.ui.item
{
	import com.netease.protobuf.UInt64;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CLoadImage;
	import com.ui.widget.CWidgetFloatText;
	
	import flash.display.Bitmap;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import framework.fibre.core.Notification;
	import framework.rpc.NetworkManager;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.notification.GameNotification;
	
	import qihoo.triplecleangame.protos.CMsgGetNameImageResponse;

	/**
	 * @author caihua
	 * @comment 好友邀请中的小好友item
	 * 创建时间：2014-7-2 下午3:04:30 
	 */
	public class CItemFriendAdd extends CItemAbstract
	{
		private var _img:CLoadImage;
		private var _fid:UInt64;
		private var _name:String = "";
		private var _imgSize:Point;
		private var _icon:String = "";
		private var _selected:Boolean = false;

		private var addBtn:CButtonCommon;
		private var _hasEvent:Boolean;
		
		public function CItemFriendAdd(fid:UInt64)
		{
			this._fid = fid;
			super(ConstantUI.ITEM_FRIEND_ADD);
		}
		
		override protected function drawContent():void
		{
			addBtn = new CButtonCommon("add");
			mc.addpos.addChild(addBtn);
			addBtn.addEventListener(TouchEvent.TOUCH_TAP , __onAdd , false, 0 ,true);
			
			if(this._fid)
			{
				var msg:CMsgGetNameImageResponse = CBaseUtil.getImageAndName(_fid);
				if(msg == null)
				{
					if(!_hasEvent)
					{
						_hasEvent = true;
						CBaseUtil.regEvent(GameNotification.EVENT_FRIEND_IMG_NAME , __showImgAndIcon);
					}
				}
				else
				{
					__doShow(msg);
				}
			}
		}
		
		override protected function dispose():void
		{
			if(_hasEvent)
			{
				_hasEvent = false;
				CBaseUtil.removeEvent(GameNotification.EVENT_FRIEND_IMG_NAME , __showImgAndIcon);
			}
		}
		
		private function __showImgAndIcon(d:Notification):void
		{
			var data:Object = d.data;
			var msg:CMsgGetNameImageResponse = data.message;
			
			__doShow(msg);
		}
		
		private function __doShow(msg:CMsgGetNameImageResponse):void
		{
			if(CBaseUtil.toNumber2(msg.userQID) == CBaseUtil.toNumber2(_fid))
			{
				_name = msg.name;
				
				_icon = getImgUrl(msg);
				
				if(_name == "")
				{
					_name = "用户_"+_fid;
				}
				
			}
			__drawIconAndName();
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
		
		private function __drawIconAndName():void
		{
			if(_icon!="")
			{
				var img:CLoadImage = new CLoadImage(_icon , 48 , 48 , true , 60);
				if(_imgSize != null)
				{
					img.width = _imgSize.x;
					img.height = _imgSize.y;
				}
				
				mc.imgpos.addChild(img);
			}
			else
			{
				var cls:Class = ResHandler.getClass("bmd.defaultHead");
				var defaultBmp:Bitmap = new Bitmap(new cls());
				if(_imgSize != null)
				{
					defaultBmp.width = _imgSize.x;
					defaultBmp.height = _imgSize.y;
				}
				else
				{
					defaultBmp.width = 48;
					defaultBmp.height = 48;
				}
				mc.imgpos.addChild(defaultBmp);
			}
			if(this.mc.fname != null)
			{
				this.mc.fname.text = _name;
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
		
		protected function __onAdd(event:TouchEvent):void
		{
			addBtn.enabled = false;
			addBtn.mouseEnabled = false;
			NetworkManager.instance.sendServerAddFriend(_fid);
			
			//加好友成功
			CWidgetFloatText.instance.showTxt("发送加好友请求成功,等待对方同意！");
		}
	}
}