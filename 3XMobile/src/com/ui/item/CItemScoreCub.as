package com.ui.item
{
	import com.game.consts.ConstFlowTipSize;
	import com.game.module.CDataManager;
	import com.game.module.CDataOfLevel;
	import com.greensock.TweenLite;
	import com.ui.util.CBaseUtil;
	import com.ui.util.CScaleImageUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import framework.fibre.core.Notification;
	import framework.rpc.NetworkManager;
	import framework.util.ResHandler;
	import framework.util.playControl.PlayMovieClipToEndAndDestroy;
	import framework.view.notification.GameNotification;

	/**
	 * @author caihua
	 * @comment 游戏分值进度烧杯
	 * 创建时间：2014-6-13 下午4:53:58 
	 */
	public class CItemScoreCub extends CItemAbstract
	{
		private var _score:int = 0 ;
		private static const START_Y:Number = 279.05; 
		private static const END_Y:Number = 140.9; 
		private var _dataOfLevel:CDataOfLevel;
		
		private var _oneStarLogo:Sprite;
		private var _twoStarLogo:Sprite;
		private var _threeStarLogo:Sprite;

		private var starCls:Class;

		private var bgCls:Class;

		private var bg:Bitmap;

		private var lineCls:Class;
		
		private var _selfItem:CItemFriend;
		
		private var _flowTipItem:CItemFlowTip;

		private var line1:Bitmap;

		private var line2:Bitmap;

		private var line3:Bitmap;

		private var oneStarPosY:Number;

		private var twoStarPosY:Number;

		private var threeStarPosY:Number;

		private var oneStarPosX:Number;

		private var twoStarPosX:Number;

		private var threeStarPosX:Number;
		
		private var oneStarPercent:Number;
		private var twoStarPercent:Number;
		private var threeStarPercent:Number;

		private var ceilWidth:Number;

		private var bottomWidth:Number;
		
		private  var haftStarHeight:Number = 8;
		private var _showed:Boolean;
		
		public function CItemScoreCub()
		{
			super("item.barrier.score");
		}
		
		override protected function drawContent():void
		{
			this.mc.cub.stop();
			
			_dataOfLevel = CDataManager.getInstance().dataOfLevel;
			
			oneStarPercent = _dataOfLevel.oneStar / _dataOfLevel.totalScore;
			twoStarPercent = _dataOfLevel.twoStar / _dataOfLevel.totalScore;
			threeStarPercent = _dataOfLevel.threeStar / _dataOfLevel.totalScore;
			
			mc.scoretf = CBaseUtil.getTextField(mc.scoretf , 14 , 0xffffff ,null , false , 0x01);
			mc.scoretftip =  CBaseUtil.getTextField(mc.scoretftip , 14 , 0xffffff ,null , false , 0x01);
			
			mc.warningtip.visible = false;
			mc.warningtip.mouseChildren = false;
			mc.warningtip.mouseEnabled = false;
			
			__drawStars();
			
			__calcStarPos();
			
			__drawLines();
			
			__calcLinePos();
			
			//皇冠下面的头像
			_selfItem = new CItemFriend(CDataManager.getInstance().dataOfGameUser.userId , "item.friend.mini" , new Point(28,28));
			mc.itempos.addChild(_selfItem);
		}
		
		private function __calcStarPos():void
		{
			//杯子距离原点的x,y
			var offX:Number = 73;
			var offY:Number = 46;
			
			//梯形上底和下底
			ceilWidth = 84;
			bottomWidth = 30;
			
			var waterHeight:Number = START_Y - END_Y;
			
			oneStarPosY = twoStarPosY = threeStarPosY = offY;
			
			oneStarPosX = twoStarPosX = threeStarPosX = offX;
			
			oneStarPosY += (1 - oneStarPercent) *  waterHeight;
			twoStarPosY += (1 - twoStarPercent) *  waterHeight;
			threeStarPosY += (1 - threeStarPercent) *  waterHeight;
			
			oneStarPosX += (1 - oneStarPercent) * (ceilWidth - bottomWidth)/2;
			twoStarPosX += (1 - twoStarPercent) * (ceilWidth - bottomWidth)/2;
			threeStarPosX += (1 - threeStarPercent) * (ceilWidth - bottomWidth)/2;
			
			_oneStarLogo.x = oneStarPosX - _oneStarLogo.width;
			//星星要垂直居中
			_oneStarLogo.y = oneStarPosY - haftStarHeight;
			
			_twoStarLogo.x = twoStarPosX - _twoStarLogo.width;
			_twoStarLogo.y = twoStarPosY - haftStarHeight;
			
			_threeStarLogo.x = threeStarPosX - _threeStarLogo.width;
			_threeStarLogo.y = threeStarPosY - haftStarHeight;
		}
		
		private function __calcLinePos():void
		{
			line1.x = oneStarPosX ;
			line1.y = oneStarPosY;
			
			mc.warningtip.y = line1.y - mc.warningtip.height;
			
			line2.x = twoStarPosX ;
			line2.y = twoStarPosY ;
			line3.x = threeStarPosX;
			line3.y = threeStarPosY;
		}
		
		private function __drawStars():void
		{
			starCls = ResHandler.getClass("bmd.common.starmini");
			bgCls = ResHandler.getClass("bmd.common.starbg");
			lineCls = ResHandler.getClass("bmd.common.line");
			
			var star:MovieClip = new starCls();
			bg = new Bitmap(new bgCls());
			
			_oneStarLogo = __drawStarLogo(1);
			_oneStarLogo.mouseChildren = false;
			_twoStarLogo = __drawStarLogo(2);
			_twoStarLogo.mouseChildren = false;
			_threeStarLogo = __drawStarLogo(3);
			_threeStarLogo.mouseChildren = false;
			
			
			mc.linepos.addChild(_oneStarLogo);
			mc.linepos.addChild(_twoStarLogo);
			mc.linepos.addChild(_threeStarLogo);
			
			mc.addEventListener(TouchEvent.TOUCH_OVER , __toggleFlowTip , false , 0 , true);
			mc.addEventListener(TouchEvent.TOUCH_OUT , __toggleFlowTip , false , 0 , true);
			
			CBaseUtil.regEvent(GameNotification.EVENT_GAME_REMOVE_ITEM , update);
		}
		
		private function update(d:Notification):void
		{
			if(_showed)
			{
				return;
			}
			if(_dataOfLevel.isCollectionSatisfied() && !_dataOfLevel.isScoreSatisfied())
			{
				_showed = true;
				if(!NetworkManager.instance.isMatching)
				{
					__showTip();
				}
			}
		}
		
		private function __showTip():void
		{
			mc.warningtip.visible = true;
			CBaseUtil.removeEvent(GameNotification.EVENT_GAME_REMOVE_ITEM , update);
			CBaseUtil.delayCall(function():void{mc.warningtip.visible = false;} , 4 , 1);
		}
		
		override protected function dispose():void
		{
			if(!_showed)
			{
				CBaseUtil.removeEvent(GameNotification.EVENT_GAME_REMOVE_ITEM , update);
			}
		}
		
		private function __drawLines():void
		{
			line1 = CScaleImageUtil.CScaleImageFromClass("bmd.common.line" , new Rectangle(5,0,10,10) , new Point(oneStarPercent * (ceilWidth - bottomWidth) + bottomWidth - 2  , 10));
			line2 = CScaleImageUtil.CScaleImageFromClass("bmd.common.line" , new Rectangle(5,0,10,10) , new Point(twoStarPercent * (ceilWidth - bottomWidth) + bottomWidth -2 , 10));
			line3 = CScaleImageUtil.CScaleImageFromClass("bmd.common.line" , new Rectangle(5,0,10,10) , new Point(threeStarPercent * (ceilWidth - bottomWidth) + bottomWidth -2 , 10));
			
			mc.linepos.addChild(line1);
			mc.linepos.addChild(line2);
			mc.linepos.addChild(line3);
		}
		
		protected function __toggleFlowTip(event:TouchEvent):void
		{
			if(! (event.target is Sprite) || (event.target as Sprite).name.indexOf("star_logo_") == -1)
			{
				return;
			}
			
			var item:Sprite = event.target as Sprite;
			var starNum : int = int(item.name.substr(-1 , 1) );
			var scoreOfStar:Number = _dataOfLevel.getScoreByStar(starNum);
			
			if(!_flowTipItem)
			{
				_flowTipItem = new CItemFlowTip("分值："+ scoreOfStar, ConstFlowTipSize.FLOW_TIP_MIDDLE);
				_flowTipItem.x = item.x;
				_flowTipItem.y = item.y + item.height;
				mc.addChild(_flowTipItem);
			}
			else
			{
				mc.removeChild(_flowTipItem);
				_flowTipItem = null;
			}
		}
		
		private function __drawStarLogo(starNum:int = 1):Sprite
		{
			var s:Sprite = new Sprite();
			
			var bgWidth:Number = starNum *  20 +  7;
			
			var bgScale:Bitmap = CScaleImageUtil.CScaleImageFromClass("bmd.common.starbg" , new Rectangle(10,10,1,1) , new Point(bgWidth , bg.bitmapData.height));
			s.addChild(bgScale);
			
			//20 是星星占用的宽度
			for(var i:int = 0 ; i < starNum ;i ++)
			{
				var star:MovieClip = new starCls();
				star.gotoAndStop(1);
				star.x = 3 + i * 20 ; 
				star.y = 3;
				s.addChild(star);
			}
			
			s.name = "star_logo_" + starNum;
			
			return s;
		}
		
		public function get score():int
		{
			return _score;
		}

		public function set score(value:int):void
		{
			mc.scoretf.text = value;
			_score = value;
			
			var level:CDataOfLevel = CDataManager.getInstance().dataOfLevel;
			
			if(value >= level.oneStar)
			{
				__playStarEffect(_oneStarLogo);
			}
			if(value >= level.twoStar)
			{
				__playStarEffect(_twoStarLogo);
			}
			if(value >= level.threeStar)
			{
				__playStarEffect(_threeStarLogo);
			}
			__update();
		}
		
		private function __playStarEffect(starLayer:Sprite):void
		{
			var child:DisplayObject
			var index:int = 0;
			while (index < starLayer.numChildren)
			{
				
				child = starLayer.getChildAt(index);
				if (child is MovieClip && MovieClip(child).currentFrame != 2)
				{
					var mc:MovieClip = ResHandler.getMcFirstLoad("effect.starliang");
					MovieClip(child).addChild(mc);
					mc.gotoAndPlay(1);
					new PlayMovieClipToEndAndDestroy(mc);
					MovieClip(child).gotoAndStop(2);
				}
				index++;
			}
		}
		
		private function __update():void
		{
			if(CDataManager.getInstance().dataOfLevel == null 
				|| CDataManager.getInstance().dataOfLevel.levelConfig == null
				|| CDataManager.getInstance().dataOfLevel.levelConfig.score == null)
			{
				return;
			}
			var percent:Number = (score/CDataManager.getInstance().dataOfLevel.levelConfig.score.totalStar);
			percent = percent >= 1 ? 1 : percent;
			var y_dist:int = percent * (START_Y - END_Y);
			TweenLite.to(mc.cub.mc_mask , 0.5 , {x:mc.cub.mc_mask.x , y:START_Y - y_dist });
		}
	}
}