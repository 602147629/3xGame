package com.ui.item
{
	import com.game.consts.ConstIcon;
	import com.game.consts.ConstString;
	import com.ui.util.CBaseUtil;
	
	import flash.display.MovieClip;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import framework.resource.faxb.items.Item;
	import framework.util.ResHandler;

	/**
	 * @author caihua
	 * @comment 道具
	 * 创建时间：2014-7-3 下午5:30:42 
	 */
	public class CItemIcon extends CItemAbstract
	{
		private var _id:int;
		private var _num:int;
		private var _isShowTips:Boolean;
		private var _isShowBg:Boolean;
		private var _isUseBubble:Boolean;
		
		private var _flowTipItem:CItemFlowTip;
		private var _flowTipText:String;
		
		private var _iconClass:String = "";
		
		private var _tf:TextField
		
		//iconClass : iconObstacle - 消除体 ,  common.icon  - 普通按钮
		private var _hasTip:Boolean;

		private var _toolConfig:Item;
		
		public function CItemIcon(id:int = 0  , num:int = 1, isShowTips:Boolean = true , iconClass:String = "common.icon", isShowBg:Boolean = true, isUseBubble:Boolean = false )
		{
			_id = id;
			_num = num;
			_isShowTips = isShowTips;
			_isShowBg = isShowBg;
			_isUseBubble = isUseBubble;
			_iconClass = iconClass;
			super("common.item.icon");
		}
		
		override protected function drawContent():void
		{
			var cls:Class = ResHandler.getClass(_iconClass);
			var item:MovieClip = new cls();
			
			mc.back.visible = _isShowBg;
			if(_isUseBubble)
			{
				mc.back.gotoAndStop(2);
			}
			else
			{
				mc.back.gotoAndStop(1);
			}
			
			if(_iconClass == "common.icon")
			{
				item.gotoAndStop(_id + 1);
			}
			else if(_iconClass == "common.tool.img")
			{
				_toolConfig = CBaseUtil.getToolConfigById(_id);
				var frameIndex:int = CBaseUtil.getIconFrameByIconId(_toolConfig.icon);
				item.gotoAndStop(frameIndex);
			}
			else if(_iconClass == "iconObstacle")
			{
				item.gotoAndStop(ConstIcon.getOBSIconById(_id) + 1);
			}
			
			mc.imgpos.addChild(item);
			if(_isUseBubble)
			{
				mc.imgpos.x = 73 - item.width >> 1;
				mc.imgpos.y = 77 - item.height >> 1;
			}
			else
			{
				mc.imgpos.x = 58 - item.width >> 1;
				mc.imgpos.y = 58 - item.height >> 1;
			}
			
			
			_tf = CBaseUtil.getTextField(mc.energytf , 16 ,0xffffff );
			
			_tf.text = "" + _num;
			
			if(_num == 0)
			{
				_tf.visible = false;
				mc.bg.visible = false;
			}
			
			mc.mouseChildren = false;
			
			if(_id == ConstIcon.ICON_TYPE_ENERTY)
			{
				_flowTipText =  ConstString.FLOW_TIP_ENERGY;
			}
			else if(_id == ConstIcon.ICON_TYPE_SILVER)
			{
				_flowTipText = ConstString.FLOW_TIP_SILVER;
			}
			else
			{
				if(_toolConfig)
				{
					_flowTipText = _toolConfig.itemName;
				}
			}
			
			if(_isShowTips)
			{
				mc.addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
				mc.addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
			}
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			if(!_hasTip)
			{
				_hasTip = true;
				
				var pos:Point = mc.localToGlobal(new Point(-15 , -2));
				
				CBaseUtil.showTip(_flowTipText , pos,new Point(90,20) ,true , "up");
			}
			else
			{
				_hasTip = false;
				CBaseUtil.closeTip()
			}
		}
	}
}