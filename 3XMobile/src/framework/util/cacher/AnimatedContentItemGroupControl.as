package framework.util.cacher
{
	import framework.client.mechanic.movieclipCacher.CachedMovieClipSynchronous;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	public class AnimatedContentItemGroupControl
	{
		private var statusCommandList:Vector.<AnimatedItemStatus>;
		private var playingStatusMap:Object;
	
		private var animatedItemsGroup:AnimatedContentItemGroup = null;

		private var owner:DisplayObjectContainer;
		
		public function AnimatedContentItemGroupControl(owner:DisplayObjectContainer)
		{
			this.owner = owner;
			
			this.statusCommandList = new Vector.<AnimatedItemStatus>();
			this.playingStatusMap = new Object();
		}
		
		public function getAnimItem(name:String):MovieClip
		{
			if(animatedItemsGroup != null)
			{
				return animatedItemsGroup.getItem(name);
			}
			
			return null;
		}
		
		public function getItemsGroup():Vector.<AnimatedItem>
		{
			if(animatedItemsGroup != null)
			{
				return animatedItemsGroup.getItemsGroup();
			}
			
			return new Vector.<AnimatedItem>();
		}
		
		public function setAnimatedItemsGroup(animatedItemsGroup:AnimatedContentItemGroup):void
		{
			if(this.animatedItemsGroup == null)
			{
				this.animatedItemsGroup = animatedItemsGroup;
				setAnimatedItemsAsChilds();
				
				applyStoreCommand();
			}
		}
		
		private function setAnimatedItemsAsChilds():void
		{
			for each(var item:AnimatedItem in animatedItemsGroup.getItemsGroup())
			{
				owner.addChild(item.movieclip);
			}
		}

		private function applyStoreCommand():void
		{
			CONFIG::debug
			{
				ASSERT(animatedItemsGroup != null, "ASSERT");
			}

			for each(var status:AnimatedItemStatus in statusCommandList)
			{
				applyOneCommand(status);		
			}
			statusCommandList = null;

			refreshAllAnimatedItemPlayingStatusByQualitySetting();
		}
		
		private function applyOneCommand(status:AnimatedItemStatus):void
		{
			if(animatedItemsGroup != null)
			{
				for each(var item:AnimatedItem in animatedItemsGroup.getItemsGroup())
				{
					if(status.canApplyToItem(item.name))
					{
						applyStatusToOneItem(item, status);
						refreshOneAnimatedItemPlayingStatusByQualitySetting(item);
					}
				}
			}
			else
			{
				statusCommandList.push(status);
			}
		}
		
		private function applyStatusToOneItem(item:AnimatedItem, status:AnimatedItemStatus):void
		{
			if(status.dirtyVisible)
			{
				item.movieclip.visible = status.visible;
			}
			
			if(status.dirtyGoToStop)
			{
				item.movieclip.gotoAndStop(status.gotoAndStopFrame);
			}
			
			rememberPlayingStatus(item, status);
			
		}
		
		private function rememberPlayingStatus(item:AnimatedItem, status:AnimatedItemStatus):void
		{
			if(status.dirtyPlaying)
			{
				playingStatusMap[item.name] = status.playing;
			}
		}
		
		private function refreshOneAnimatedItemPlayingStatusByQualitySetting(item:AnimatedItem):void
		{
			var name:String = item.name;
			var playing:Boolean = true;
			
			if(playingStatusMap[name] != null)
			{
				playing &&= playingStatusMap[name];
			}
			
			var mc:MovieClip = item.movieclip;
			if(mc != null)
			{
				if(playing)
				{
					mc.play();
				}
				else
				{
					//TODO We should use isPlaying to determine How to handle it in feature.
					if(mc is CachedMovieClipSynchronous)
					{
						mc.stop();
					}
					else
					{
						mc.gotoAndStop(1);
					}
				}
			}
		}
		
		public function refreshAllAnimatedItemPlayingStatusByQualitySetting():void
		{
			if(animatedItemsGroup != null)
			{
				for each(var item:AnimatedItem in animatedItemsGroup.getItemsGroup())
				{
					refreshOneAnimatedItemPlayingStatusByQualitySetting(item);
				}
			}
		}
		
		
		public function allowAnimationSkipable(skipable:Boolean):void
		{
			if(animatedItemsGroup != null)
			{
				animatedItemsGroup.allowAnimationSkipable(skipable);
			}
		}

		//////////////////////////////////////
		// frame control
		
		public function gotoAndStopItem(name:String, frame:int):void
		{
			var status:AnimatedItemStatus = new AnimatedItemStatus(name);
			status.gotoAndStopFrame = frame;
			
			applyOneCommand(status);
		}
		
		public function hideAnimatedItem(name:String):void
		{
			var status:AnimatedItemStatus = new AnimatedItemStatus(name);
			status.visible = false;
			status.playing = false;
			
			applyOneCommand(status);
		}
		
		public function showAnimatedItem(name:String):void
		{
			var status:AnimatedItemStatus = new AnimatedItemStatus(name);
			status.visible = true;
			
			applyOneCommand(status);
		}
		
		public function playAnimatedItem(name:String):void
		{
			var status:AnimatedItemStatus = new AnimatedItemStatus(name);
			status.playing = true;
			
			applyOneCommand(status);
		}
		
		public function stopAnimatedItem(name:String):void
		{
			var status:AnimatedItemStatus = new AnimatedItemStatus(name);
			status.playing = false;
			
			applyOneCommand(status);
		}
		
		public function showAndPlayAnimatedItem(name:String):void
		{
			var status:AnimatedItemStatus = new AnimatedItemStatus(name);
			status.visible = true;
			status.playing = true;
			
			applyOneCommand(status);
		}
		
		
		public function undisplayAllAnimatedItems():void
		{
			var status:AnimatedItemStatus = new AnimatedItemStatus(AnimatedItemStatus.APPLY_TO_ALL_ITEM);
			status.visible = false;
			status.playing = false;
			applyOneCommand(status);
		}
		
		public function displayAllAnimatedItems():void
		{
			var status:AnimatedItemStatus = new AnimatedItemStatus(AnimatedItemStatus.APPLY_TO_ALL_ITEM);
			status.visible = true;
			status.playing = true;
			applyOneCommand(status);
		}

		
	}
}




