package com.ui.widget
{
	import com.game.module.CDataManager;
	import com.ui.button.CButtonCommon;
	import com.ui.item.CItemBarrierFriend;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CFontUtil;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import framework.model.ListInfo;
	import framework.rpc.DataUtil;
	import framework.rpc.WebJSManager;
	
	import qihoo.gamelobby.protos.UserOrigin;

	/**
	 * @author caihua
	 * @comment 关卡好友列表
	 * 创建时间：2014-6-10 下午6:46:37 
	 */
	public class CWidgetBarrierFriendList extends CWidgetTurnPageBase
	{
		private var _friendRankBtn:CButtonCommon;
		private var _allRankBtn:CButtonCommon;
		private var _currentLabel:String;
		
		private var _level:int;
		
		public function CWidgetBarrierFriendList(level:int)
		{
			_level = level;
			
			super("item.barrier.friendlist");
		}
		
		/**
		 * 设置属性
		 */
		override protected function setPara():void
		{
			//每页横竖项数
			this._NUM_PER_PAGE = new Point(1, 6);
			//遮罩位置
			this._MASK_ZONE = new Rectangle(0, 50, 225, 380);
			//每项间隔
			this._ITEM_SPAN = new Point(208, 62);
			//最后一页填满模式
			this._dataListLastMode = ListInfo.MODE_KEEP_REMAIN;
			//item开始位置
			this._containerOldPos = new Point(10, 53);
		}
		
		override protected function drawItem(data:Object):Sprite
		{
			return new CItemBarrierFriend(data.fid , data.rank , data.star);
		}
		
		override protected function drawContent():void
		{
			super.drawContent();
			
			if(DataUtil.instance.userType == UserOrigin.UserOrigin_Visitor)
			{
				var inviteBtn:CButtonCommon = new CButtonCommon("z_n98_invite");
				
				inviteBtn.width = 209;
				inviteBtn.height = 59;
				
				inviteBtn.addEventListener(TouchEvent.TOUCH_TAP , __onRegister , false , 0 , true);
				
				mc.invitepos.addChild(inviteBtn);
			}
			
			
			var bg:Bitmap = CScaleImageUtil.CScaleImageFromClass("bmd.barrier.friendlistbg" , 
				new Rectangle(19,19,1,1) ,new Point(230,468));
			mc.bgpos.addChild(bg);
			
			mc.myranktf = CBaseUtil.getTextField(mc.myranktf , 16 , 0xffffff , null , false , 0x5e2f12);
			
			__drawButton();
			
			var scoreData:Array = new Array();
			var friendList:Array = CDataManager.getInstance().dataOfFriendList.getFriendList();
			for(var i:int = 0 ;i < friendList.length ;i ++)
			{
				scoreData.push({fid:friendList[i] , star:CBaseUtil.getFriendStar(friendList[i] , false , false)});
			}
			
			//自己的
			var selfTotalStar:int = CDataManager.getInstance().dataOfGameUser.totalStar;
			scoreData.push({fid:DataUtil.instance.myUserID , star:selfTotalStar});
			
			//排序
			__sortArray(scoreData);
			
			var result:Array = new Array();
			for(var j:int =0 ; j< scoreData.length ; j++)
			{
				if(CBaseUtil.toNumber2(scoreData[j].fid) == CBaseUtil.toNumber2(DataUtil.instance.myUserID))
				{
					DataUtil.instance.myRank = j+1;
					
					mc.myranktf.text = "您的名次："+DataUtil.instance.myRank;
				}
				result.push({fid:scoreData[j].fid ,  star:scoreData[j].star , rank:j+1});
			}
			
			this._dataList.setData(result);
			
			this.drawInit();
		}
		
		protected function __onRegister(event:TouchEvent):void
		{
			WebJSManager.loginEnrol();
		}
		
		private function __sortArray(scoreData:Array):void
		{
			scoreData.sort(__mysort , Array.DESCENDING);
		}
		
		private function __mysort(a:Object , b :Object):int
		{
			if(a.star > b.star)
			{
				return 1;
			}
			else if(a.star  == b.star)
			{
				return 0
			}
			else
			{
				return -1;
			}
		}
		
		private function __drawButton():void
		{
			var tf:TextFormat = CFontUtil.textFormatMiddle;
			tf.color = 0xfcf895;
			
			//好友排行
			_friendRankBtn = new CButtonCommon("z_n3_tab" , "好友排行" , tf);
			this.mc.btnfriendrank.addChild(_friendRankBtn);
			_friendRankBtn.selected = true;
			_friendRankBtn.addEventListener(TouchEvent.TOUCH_TAP , __onTab	 , false , 0 , true);
			
			//全部排行
			_allRankBtn = new CButtonCommon("z_n3_tab", "全服排行" , tf);
			this.mc.btnallrank.addChild(_allRankBtn);
			_allRankBtn.selected = !_friendRankBtn.selected;
			_allRankBtn.addEventListener(TouchEvent.TOUCH_TAP , __onTab	 , false , 0 , true);
			
			_allRankBtn.visible = false;
			
			_friendRankBtn.setLabel("friendrank");
			_allRankBtn.setLabel("allrank");
			
			_prevPageBtn = new CButtonCommon("prev");
			this.mc.prevbtnpos.addChild(_prevPageBtn);
			_nextPageBtn = new CButtonCommon("next");
			this.mc.nextbtnpos.addChild(_nextPageBtn);
			
			//翻页
			_prevPageBtn.addEventListener(TouchEvent.TOUCH_TAP , __onFriendListPrev , false , 0 , true);
			_nextPageBtn.addEventListener(TouchEvent.TOUCH_TAP , __onFriendListNext , false , 0 , true);
		}
		
		protected function __onTab(event:TouchEvent):void
		{
			return;
			
			__setTab((event.currentTarget as CButtonCommon).__label);
		}
		
		private function __setTab(l:String):void
		{
			_currentLabel = l;
			
			var data:Array = [];
			if(l == "friendrank")
			{
				_friendRankBtn.selected = true;
				_allRankBtn.selected = false;
				
				for(var i:int = 0 ; i < 25 ; i++)
				{
					var d:Object = {fid:CBaseUtil.fromNumber2(i)  , rank:i};
					data[i] = d;
				}
				
				this._dataList.setData(data);
				
				this.drawInit();
			}
			else
			{
				_friendRankBtn.selected = false;
				_allRankBtn.selected = true;
				for(var j:int = 0 ; j < 25 ; j++)
				{
					var dall:Object = {fid:CBaseUtil.fromNumber2(j)  , rank:j};
					data[j] = dall;
				}
				
				this._dataList.setData(data);
				
				this.drawInit();
			}
		}
		
		protected function __onFriendListNext(event:TouchEvent):void
		{
			this.nextPage();
		}
		
		protected function __onFriendListPrev(event:TouchEvent):void
		{
			this.prevPage();
		}
	}
}