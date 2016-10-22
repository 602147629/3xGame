package framework.util.cacher
{
	import framework.client.mechanic.movieclipCacher.CachedMovieClip;
	import framework.client.mechanic.movieclipCacher.MovieClipCacherUtility;
	
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;

	public class AnimatedContentItemGroup
	{
		private var itemsGroup:Vector.<AnimatedItem> = new Vector.<AnimatedItem>();
		
		private static const PREFIX_ANIMATED_ITEM_NAME1:String = "animated_";
		private static const PREFIX_ANIMATED_ITEM_NAME2:String = "ANIM_";
		private static const SUFFIX_SYNCHRONOUS_ITEM:String = "_SYNCHRONOUS";
		
		public function AnimatedContentItemGroup() 
		{
		}
		
		public function allowAnimationSkipable(skipable:Boolean):void
		{
			for each(var item:AnimatedItem in itemsGroup)
			{
				if(item.movieclip is CachedMovieClip)
				{
					(item.movieclip as CachedMovieClip).canSkipCacheAnimation = skipable;
				}
			}
	
		}

		private function addItem(name:String, item:MovieClip):void
		{
			CONFIG::debug
			{
				ASSERT(getItem(name) == null, "Already in animated group:" + name);
			}
			itemsGroup.push(new AnimatedItem(name, item));
		}
		
		public function getItem(name:String):MovieClip
		{
			for each(var item:AnimatedItem in itemsGroup)
			{
				if(item.name == name)
				{
					return item.movieclip;
				}
			}
			return null;
		}

		public function collectAllAnimatedItemsFromMc(mc:MovieClip):Vector.<MovieClip>
		{
			var movieclips:Vector.<MovieClip> = new Vector.<MovieClip>();
			
			for(var i:int = 0; i < mc.numChildren; ++i)
			{
				var child:MovieClip = mc.getChildAt(i) as MovieClip;
				if(child != null)
				{
					var itemName:String = child.name;

					if(isItAnimatedItem(itemName))
					{
						movieclips.push(child);
					}
					else
					{
						CONFIG::debug
						{
							if(child.totalFrames > 1)
							{
								var msg:String = getQualifiedClassName(mc) + "." + itemName;
								TRACE_VALIDATE("CACHE WARNING!!! NON-animated clip should not have more than 1 frames, name = " + msg);
							}	
						}
					}
					
				}
			}
			
			return movieclips;

		}
		
		public function pickupAllAnimatedItemsFromMc(mc:MovieClip, ownerName:String):int
		{
			var movieclips:Vector.<MovieClip> = collectAllAnimatedItemsFromMc(mc);
			
			for each(var child:MovieClip in movieclips)
			{
				var itemName:String = child.name;
				CONFIG::debug
				{
					ASSERT(isItAnimatedItem(itemName), "ASSERT");
				}
				
				mc.removeChild(child);

				var globalKey:String = getGlobalKey(itemName, ownerName);
				if(isSynchronousItem(itemName))
				{
					child = MovieClipCacherUtility.createMovieClipCacherSynchronous(child, globalKey);
				}
				else
				{
					child = MovieClipCacherUtility.createMovieClipCacherAsynchronous(child, globalKey);	
				}
				
				CONFIG::debug
				{
					ASSERT(getItem(itemName) == null, getQualifiedClassName(mc) + " has duplicated animation: " + itemName);
				}
				
				addItem(itemName, child);
			}
			
			return movieclips.length;
		}
		
		private static function isSynchronousItem(itemName:String):Boolean
		{
			return itemName.indexOf(SUFFIX_SYNCHRONOUS_ITEM) >= 0;
		}
		
		private static function getGlobalKey(name:String, ownerName:String):String
		{
			var key:String = ownerName + "," + name;
			return key;
		}

		public function hideAllItems():void
		{
			for each(var item:AnimatedItem in itemsGroup)
			{
				item.hide();
			}
		}
		
		public function showAllItems():void
		{
			for each(var item:AnimatedItem in itemsGroup)
			{
				item.show();
			}
		}
		
		private static function isItAnimatedItem(itemName:String):Boolean
		{
			if(itemName.toLowerCase().indexOf(PREFIX_ANIMATED_ITEM_NAME1) == 0 ||
				itemName.indexOf(PREFIX_ANIMATED_ITEM_NAME2) == 0)
			{
				return true;
			}

			return false;
			
		}
		
		public function getItemsGroup():Vector.<AnimatedItem>
		{
			return this.itemsGroup;
		}
		
		
	}
}

