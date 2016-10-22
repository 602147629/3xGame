package com.ui.item
{
	import com.game.module.CDataManager;
	import com.netease.protobuf.UInt64;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFilterUtil;
	import com.ui.util.CLoadImage;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import framework.fibre.core.Notification;
	import framework.rpc.DataUtil;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.notification.GameNotification;
	
	import qihoo.triplecleangame.protos.CMsgGetNameImageResponse;
	
	/**
	 * @author caihua
	 * @comment 关卡中的好友界面
	 * 创建时间：2014-8-16 下午3:04:30 
	 */
	public class CItemBarrierFriend extends CItemAbstract
	{
		private var _img:CLoadImage;
		private var _fid:UInt64;
		private var _name:String = "";
		private var _icon:String = "";
		private var _selected:Boolean = false;
		private var _rank:int;
		private var _star:Number;

		private var frame:Bitmap;
		private var _hasEvent:Boolean;
		
		private var _crown:MovieClip;
		
		public function CItemBarrierFriend(fid:UInt64 , rank:int , star:Number)
		{
			this._fid = fid;
			_rank = rank;
			_star = star;
			super(ConstantUI.ITEM_BARRIER_FRIEND);
		}
		
		override protected function drawContent():void
		{
			__drawBg();
			
			__drawImgAndName();
			
			__drawRank();
			
		}
		
		private function __drawRank():void
		{
			var tf:TextField = CBaseUtil.getTextField(mc.ranktext ,20 , 0xffffff);
			tf.filters =[CFilterUtil.getTextGlowFilter(0x5e2f12)];
			tf.text = "" + _rank;
			
			if(_rank <= 3)
			{
				if(_rank == 1)
				{
					_crown = ResHandler.getMcFirstLoad("item.crown.first");
				}
				else if(_rank == 2)
				{
					_crown = ResHandler.getMcFirstLoad("item.crown.second");
				}
				else
				{
					_crown = ResHandler.getMcFirstLoad("item.crown.third");
				}
				
				_crown.x = -1;
				_crown.y = (mc.height - _crown.height)/2;
				
				tf.visible = false;
				mc.addChild(_crown);
			}
			
			var tfScore:TextField = CBaseUtil.getTextField(mc.fscore ,14 , 0xffffff);
			tfScore.filters =[CFilterUtil.getTextGlowFilter(0x5e2f12)];
			
			if(_star == -1)
			{
//				CBaseUtil.getFriendStar(_fid);
			}
			
			_star = _star == -1 ? 0 : _star;
			
			tfScore.text = "总星值：" + _star;
		}
		
		private function __drawBg():void
		{
			var bg:Bitmap = CScaleImageUtil.CScaleImageFromClass("bmd.bg.step" , 
				new Rectangle(11,11,1,1) ,new Point(206,58));
			mc.bgpos.addChild(bg);
			
			frame = CScaleImageUtil.CScaleImageFromClass("bmd.frame.step" , 
				new Rectangle(11,11,1,1) ,new Point(206,58));
			mc.bgpos.addChild(frame);
			
			if(CBaseUtil.toNumber2(_fid) == CBaseUtil.toNumber2(DataUtil.instance.myUserID))
			{
				frame.visible = true;
			}
			else
			{
				frame.visible = false;
			}
		}
		
		private function __drawImgAndName():void
		{
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
				_name = CDataManager.getInstance().dataOfFriendList.getName(_fid);
				
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
			return msg.image48;
		}
		
		private function __drawIconAndName():void
		{
			if(_icon!="")
			{
				var img:CLoadImage = new CLoadImage(_icon , 48 , 48 , true , 60);
				
				img.width = 46;
				img.height = 46;
				
				mc.imgpos.addChild(img);
			}
			else
			{
				var cls:Class = ResHandler.getClass("bmd.defaultHead");
				var defaultBmp:Bitmap = new Bitmap(new cls());
				defaultBmp.width = 48;
				defaultBmp.height = 48;
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
		
		override protected function dispose():void
		{
			if(_hasEvent)
			{
				_hasEvent = false;
				CBaseUtil.removeEvent(GameNotification.EVENT_FRIEND_IMG_NAME , __showImgAndIcon);
			}
		}
	}
}


