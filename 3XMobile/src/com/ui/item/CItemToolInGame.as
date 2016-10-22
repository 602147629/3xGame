package com.ui.item
{
	import com.game.consts.ConstFlowTipSize;
	import com.game.module.CDataManager;
	import com.greensock.TweenLite;
	import com.ui.button.CButtonCommon;
	import com.ui.util.CBaseUtil;
	import com.ui.widget.CWidgetFloatText;
	
	import flash.display.MovieClip;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	
	import framework.datagram.Datagram;
	import framework.datagram.DatagramViewNormal;
	import framework.fibre.core.Fibre;
	import framework.fibre.core.Notification;
	import framework.resource.faxb.items.Item;
	import framework.util.ResHandler;
	import framework.view.ConstantUI;
	import framework.view.mediator.MediatorBase;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 关卡中道具
	 * 创建时间：2014-7-23 下午6:00:42 
	 */
	public class CItemToolInGame extends CItemAbstract
	{
		private var _id:int;
		private var _num:int;
		private var _isShowTips:Boolean;
		
		private var _flowTipItem:CItemFlowTip;
		private var _flowTipText:String;
		
		private var _toolConfig:Item;
		
		//TYPE_ONCE , TYPE_ALL
		private var _type:String = "TYPE_ONCE";
		
		private var __buyBtn:CButtonCommon;
		private var _hasTip:Boolean;
		
		public function CItemToolInGame(id:int = 0  , num:int = 0, isShowTips:Boolean = true , type:String = "TYPE_ONCE")
		{
			_id = id;
			_num = num;
			_isShowTips = isShowTips;
			_type = type;
			_toolConfig = CBaseUtil.getToolConfigById(_id);
			super("common.tool.ingame");
		}
		
		override protected function drawContent():void
		{
			var cls:Class = ResHandler.getClass("common.tool.img");
			var item:MovieClip = new cls();
			
			var frameIndex:int = CBaseUtil.getIconFrameByIconId(_toolConfig.icon);
			item.gotoAndStop(frameIndex);
			mc.imgpos.addChild(item);
			
			if(_isShowTips)
			{
				mc.addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
				mc.addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
			}
			
			//购买按钮
			__buyBtn = new CButtonCommon("add2");
			mc.addpos.addChild(__buyBtn);
			
			__update();
			
			__buyBtn.addEventListener(TouchEvent.TOUCH_TAP , __onBuy , false, 0 ,true);
			
			mc.addEventListener(TouchEvent.TOUCH_TAP , __onClick , false , 0 , true);
			
			CBaseUtil.regEvent(GameNotification.EVENT_TOOL_DATA_UPDATE , __onUpdate);
		}
		
		override protected function dispose():void
		{
			super.dispose();
			CBaseUtil.removeEvent(GameNotification.EVENT_TOOL_DATA_UPDATE , __onUpdate);
		}
		
		private function __onUpdate(d:Notification):void
		{
			__update();
		}
		
		private function __update():void
		{
			if(_type == "TYPE_ONCE")
			{
				__buyBtn.visible = false;
				
				mc.mouseChildren = false;
				
				for(var j:int = 0 ;j <  CDataManager.getInstance().dataOfLevel.inGameToolIdList.length ; j++)
				{
					var d:Object =  CDataManager.getInstance().dataOfLevel.inGameToolIdList[j];
					if(d.id == _id)
					{
						_num = d.num;
					}
				}
				
				//一次性使用道具秒黑
				if(_num <= 0)
				{
//					mc.filters = [CFilterUtil.grayFilter];
					mc.visible = false;
					mc.energytf.visible = false;
					mc.tfbg.visible = false;
				}
				else
				{
					mc.visible = true;
//					mc.filters = null;
					mc.energytf.visible = true;
					mc.tfbg.visible = true;
				}
			}
			else
			{
				_num = CDataManager.getInstance().dataOfUserTool.getToolNumById(_id);
				
				if(_num <= 0)
				{
					mc.energytf.visible = false;
					mc.tfbg.visible = false;
				}
				else
				{
					mc.energytf.visible = true;
					mc.tfbg.visible = true;
				}
				
				//使用次数超过限制
				if(_toolConfig.limit > 0 && CDataManager.getInstance().dataOfLevel.getUseTime(_id) >= _toolConfig.limit)
				{
					this.visible = false;	
				}
			}
			
			mc.energytf.text = "" + _num;
		}
		
		protected function __onClick(event:TouchEvent):void
		{
			if(! (event.target is MovieClip ))
			{
				return;
			}
			
			if(_num <= 0)
			{
				return;
			}
			
			if(CDataManager.getInstance().dataOfLevel.isUsingTool)
			{
				CWidgetFloatText.instance.showTxt("正在使用道具");
				return;
			}
			
			var dataGram:Datagram = new Datagram();
			dataGram.injectParameterList[0] = _id;
			
			//使用
			Fibre.getInstance().sendNotification(GameNotification.EVENT_USE_ITEM, dataGram);
		}
		
		protected function __onBuy(event:TouchEvent):void
		{
			CBaseUtil.sendEvent(MediatorBase.G_POP_UP_PANEL , new DatagramViewNormal(ConstantUI.PANEL_COMMON_BUY , true , {id:_id}));
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			if(!_hasTip)
			{
				_hasTip = true;
				CBaseUtil.showTip(_toolConfig.desc , mc.localToGlobal(new Point(mc.flowtippos.x , mc.flowtippos.y)),  
					ConstFlowTipSize.FLOW_TIP_MAX ,true , "left");
			}
			else
			{
				_hasTip = false;
				CBaseUtil.closeTip()
			}
		}
		
		public function lock():void
		{
			mc.lock.visible = true;
		}
		
		public function shine():void
		{
			CBaseUtil.setRegPointCenter(mc);
			TweenLite.to(mc , 0.6 , {rotation:720 , onComplete:__onComplete});
			
			function __onComplete():void
			{
				CBaseUtil.setRegPoint(mc , 0 , 0);
			}
		}
	}
}