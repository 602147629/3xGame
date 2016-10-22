package framework.util.cacher
{
	import framework.resource.Resource;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class CachePlaceholder extends Sprite
	{
		public var owner:Resource = null;
		public var initParameter:Object = null;
		public var beNotAffectedByChangeScale:Boolean = false;
		public var isLoaded:Boolean = false;
		public var content:DisplayObject = null;
		public var cbReady:Function = null;

		private var animatedContentControl:AnimatedContentItemGroupControl;

		public function CachePlaceholder(owner:Resource, parameter:Object)
		{
			super();
			
			this.owner=owner;
			this.initParameter=parameter;
			
			animatedContentControl = new AnimatedContentItemGroupControl(this);
		}
		
		public function isItBelongToOwner(owner:Resource):Boolean
		{
			return (this.owner==owner);
		}
		
		public function setContent(d:DisplayObject):void
		{
			if (content != null && this == content.parent)
			{
				var idx:int = this.getChildIndex(content);
				this.removeChildAt(idx);
				this.addChildAt(d, idx);
				content = d;
			}
			else
			{
				this.addChild(d);
				content = d;
			}
		}
		
		public function refreshAnimatedItemPlayingStatusByQualitySetting():void
		{
			if(animatedContentControl != null)
			{
				animatedContentControl.refreshAllAnimatedItemPlayingStatusByQualitySetting();
			}
		}
		
		public function getAnimatedItemGroup():Vector.<AnimatedItem>
		{
			return this.animatedContentControl.getItemsGroup();
		}

		
		public function setAnimatedItemsGroup(animatedItemsGroup:AnimatedContentItemGroup):void
		{
			this.animatedContentControl.setAnimatedItemsGroup(animatedItemsGroup);
		}

		
		public function gotoAndStopItem(name:String, frame:int):void
		{
			this.animatedContentControl.gotoAndStopItem(name, frame);
		}
		
		public function showAndPlayAnimatedItem(name:String):void
		{
			this.animatedContentControl.showAndPlayAnimatedItem(name);
		}
		
		public function hideAnimatedItem(name:String):void
		{
			this.animatedContentControl.hideAnimatedItem(name);
		}
		
		public function playAnimatedItem(name:String):void
		{
			this.animatedContentControl.playAnimatedItem(name);
		}
		public function stopAnimatedItem(name:String):void
		{
			this.animatedContentControl.stopAnimatedItem(name);
		}
			

		public function getAnimatedItem(name:String):MovieClip
		{
			return this.animatedContentControl.getAnimItem(name);
		}
		
		public function displayAllAnimatedItems():void
		{
			this.animatedContentControl.displayAllAnimatedItems();
		}
		
		public function undisplayAllAnimatedItems():void
		{
			this.animatedContentControl.undisplayAllAnimatedItems();
		}
		
		
		public function allowAnimationSkipable(skipable:Boolean):void
		{
			if(animatedContentControl != null)
			{
				animatedContentControl.allowAnimationSkipable(skipable);
			}
		}

	}
}

