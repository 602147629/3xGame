package framework.util
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class DisplayUtil
	{
		
		private static var colorMatrixFilters : Array;

		public function DisplayUtil()
		{
		}

		public static function drawCross(sp:Sprite, x:int, y:int, color:uint):void
		{
			var gfx:Graphics=sp.graphics;
			gfx.lineStyle(1, color);
			gfx.moveTo(x - 10, y);
			gfx.lineTo(x + 10, y);
			gfx.moveTo(x, y - 10);
			gfx.lineTo(x, y + 10);
		}
		
		public static function getThumbnailDirect(origin:DisplayObject, w:int=-1, h:int=-1):Sprite
		{
			var p:Number;
			if (w <= 0)
				w = origin.width;
			if (h <= 0)
				h = origin.height;
			if (w < origin.width || h < origin.height)
			{
				// scale
				p=Math.min(w / origin.width, h / origin.height);
			}
			else
			{
				p=1;
			}
			origin.scaleX = p;
			origin.scaleY = p;
			
			var sp:Sprite=new Sprite();
			sp.addChild(origin);
			return sp;
		}

		public static function getThumbnail(origin:DisplayObject, w:int=-1, h:int=-1):Sprite
		{
			// thumbnail frame
			var sp:Sprite=new Sprite();
			var mat:Matrix=new Matrix();
			var p:Number;
			if (w <= 0)
				w=origin.width;
			if (h <= 0)
				h=origin.height;
			if (w < origin.width || h < origin.height)
			{
				// scale
				p=Math.min(w / origin.width, h / origin.height);
				mat.scale(p, p);
			}
			else
			{
				p=1;
			}

			// add content
			var nw:Number = Math.max(p * origin.width, 1);
			var nh:Number = Math.max(p * origin.height, 1);
			var bmpdata:BitmapData=new BitmapData(nw, nh, true, 0x00000000);
			var bounds:Rectangle=origin.getBounds(origin);
			mat.tx=-bounds.x * p;
			mat.ty=-bounds.y * p;
			bmpdata.draw(origin, mat);
			sp.addChild(new Bitmap(bmpdata));
			return sp;
		}

		public static function switchGroup(array:Array, current:Object, asName:Boolean=false, step:int=1, prop:String="visible"):Object
		{
			var len:int=array.length;
			var obj:Object;
			var found:Boolean=false;
			var result:Object=null;
			var next:int;

			for (var i:int=0; i < len; i++)
			{
				obj=array[i];
				if (obj != null)
				{
					if (current == null)
					{
						// get first available
						if (found)
						{
							obj[prop]=false;
						}
						else
						{
							obj[prop]=true;
							found=true;
							result=obj;
						}
					}
					else
					{
						if ((asName && obj.name == (current as String)) || (!asName && obj == current))
						{
							if (!found)
							{
								// current
								obj[prop]=false;

								// next
								next=loopNum(i + step, 0, len);
								while (array[next] == null)
									next=loopNum(next + (step >= 0 ? 1 : -1), 0, len);
								obj=array[next];
								obj[prop]=true;
								found=true;
								result=obj;
								current=obj;
							}
						}
						else
						{
							obj[prop]=false;
						}
					}
				}
			}
			return result;
		}

		public static function loopNum(i:int, min:int, len:int):int
		{
			if (i < min)
			{
				do
				{
					i+=len;
				} while (i < min)
				return i;
			}
			else if (i >= min + len)
			{
				min+=len;
				do
				{
					i-=len;
				} while (i >= min)
				return i;
			}
			else
			{
				return i;
			}
		}

/*		public static function removeChildByName(mc:MovieClip, n:String):void
		{
			if (mc.hasOwnProperty(n))
			{
				var p:DisplayObject=mc[n];
				if (p != null)
				{
					mc.removeChild(p);
					mc[n]=null;
				}
			}
		}
*/
		public static function addChildByName(mc:MovieClip, child:DisplayObject, n:String, center:Boolean=true):void
		{
			if (mc[n] != null)
			{
				replaceChild(mc, child, mc[n]);
			}
			else
			{
				mc.addChild(child);
			}
			mc[n]=child;
			if (center)
				alignCenter(child, mc);
		}
		public static function alignCenter(target:DisplayObject, container:DisplayObject=null, width:int=0, height:int=0):void
		{
			if(target == null)
				return;
			
			if(container != null)
			{
				width = container.width;
				height = container.height;
			}
			target.x = (width - target.width) >> 1;
			target.y = (height - target.height) >> 1;
		}
		
		public static function newPlainRectShape(width:int, height:int, color:uint):Shape
		{ 
			return newRectShape(width, height, color, 1, true, color);
		}
		
		public static function newRectShape(width:Number, height:Number, 
											linecolor:uint=0xEEEEEE, thickness:int=1, 
											fill:Boolean=false, fillcolor:uint=0xEEEEEE):Shape
		{
			var shape:Shape = new Shape();
			var gfx:Graphics = shape.graphics;
			if(fill)
				gfx.beginFill(fillcolor);
			gfx.lineStyle(thickness, linecolor);
			gfx.drawRect(0, 0, width-1, height-1);
			if(fill)
				gfx.endFill();
			return shape;
		}
		
		public static function newRoundRectShape(width:Number, height:Number, radius:int,
												 linecolor:uint=0xEEEEEE, thickness:int=1, 
												 fill:Boolean=false, fillcolor:uint=0xEEEEEE):Shape
		{
			var shape:Shape = new Shape();
			var gfx:Graphics = shape.graphics;
			if(fill)
				gfx.beginFill(fillcolor);
			gfx.lineStyle(thickness, linecolor);
			gfx.drawRoundRect(0, 0, width-1, height-1, radius, radius);
			if(fill)
				gfx.endFill();
			return shape;
		}

		public static function removeAllChildrenTree(container:DisplayObjectContainer):void
		{
//			var array:Array = new Array();
			if (container == null||container is Loader)
			{
				return;
			}
			for (var i:int=container.numChildren - 1; i >= 0; i--)
			{
				var node:DisplayObject=container.getChildAt(i);
				if (node is DisplayObjectContainer)
//				if (!container.getChildAt(i) is MovieClip)
				{
					removeAllChildrenTree(node as DisplayObjectContainer);
				}
				if(!(container is Loader))
				{
					container.removeChildAt(i);
				}
//				array.push(container.removeChildAt(i));
			}
//			return array.reverse();
		}

		public static function removeAllChildren(container:DisplayObjectContainer):void//, getRemovedChildren:Boolean = false):Array
		{
//			if(getRemovedChildren)
//			{
//				var array:Array = new Array();
//				while(container.numChildren > 0)
//				{
//					array.push(container.removeChildAt(0));
//				}
//				return array;
//			}
//			else
			{
				while(container.numChildren > 0)
				{
					container.removeChildAt(0);
				}
			}
			
//			return null;
		}

		public static function addAllChildren(container:DisplayObjectContainer, array:Array):void
		{
			for (var i:int=0; i < array.length; i++)
			{
				container.addChild(array[i]);
			}
		}

		public static function fillRect(gfx:Graphics, x:Number, y:Number, width:Number, height:Number, color:uint, thickness:Number=0, linecolor:uint=0):void
		{
			if (thickness <= 0)
			{
				thickness=1;
				linecolor=color;
			}
			gfx.lineStyle(thickness, linecolor);
			gfx.beginFill(color);
			gfx.drawRect(x, y, width - 1, height - 1);
			gfx.endFill();
		}

		public static function fillRoundRect(gfx:Graphics, x:Number, y:Number, width:Number, height:Number, radius:Number, color:uint, thickness:Number=0, linecolor:uint=0):void
		{
			if (thickness <= 0)
			{
				thickness=1;
				linecolor=color;
			}
			gfx.lineStyle(thickness, linecolor);
			gfx.beginFill(color);
			gfx.drawRoundRect(x, y, width - 1, height - 1, radius, radius);
			gfx.endFill();
		}

		public static function setGrayFilter(obj : DisplayObject, percent:Number):void
		{
			if (percent == -1)
			{
				obj.filters=null;
				return;
			}

			// create if necessary
			if (colorMatrixFilters == null)
			{
				colorMatrixFilters=new Array();
				var len:int=10;
				for (var i:int=0; i < len; i++)
				{
					var ary:Array=new Array(0.33, 0.33, 0.33, 0, 0, 0.33, 0.33, 0.33, 0, 0, 0.33, 0.33, 0.33, 0, 0, 0, 0, 0, 1, 0);
					var p:int=-(len - i) * 4;
					ary[4]=p;
					ary[9]=p;
					ary[14]=p;
					colorMatrixFilters.push(new ColorMatrixFilter(ary));
				}
			}
			obj.filters=[colorMatrixFilters[int(percent * colorMatrixFilters.length)]];
		}


		public static function stopAllAnim(root:DisplayObject):void
		{
			var mc:MovieClip=root as MovieClip;
			if(mc)
			{
				mc.stop();
			}
			
			var c:DisplayObjectContainer=root as DisplayObjectContainer;
			if(c)
			{
				var cn:int=c.numChildren;
				for(var i:int=0;i<cn;++i)
				{
					var child:DisplayObject=c.getChildAt(i);
					stopAllAnim(child);
				}
				
			}

		}
		public static function playAllChild(dis:DisplayObjectContainer):void{
			var n:int=dis.numChildren;
			for(var i:uint=0;i<n;i++){
				var child:DisplayObject=dis.getChildAt(i);
				if(child is MovieClip){
					MovieClip(child).play();
				}
			}
		}
		public static function replaceInDisplayTree(root:DisplayObject, display:DisplayObject):void
		{
			var parent:DisplayObjectContainer=root.parent;
			if(parent)
			{
				var idx:int=parent.getChildIndex(root);
				parent.addChildAt(display, idx);
				parent.removeChild(root);
				
				display.transform.matrix=root.transform.matrix;
				//				display.x=root.x;
				//				display.y=root.y;
				//				display.rotation=root.rotation;
				//				display.scaleX=root.scaleX;
				//				display.scaleY=root.scaleY;
			}
		}
		
//		public static function removeAllDisplayChild(container:DisplayObjectContainer):void
//		{
//			while (container.numChildren>0)
//			{
//				container.removeChildAt(0);
//			}
//		}
		public static function removeFromParent(obj:DisplayObject):void
		{
			if(obj && obj.parent)
			{
				obj.parent.removeChild(obj);
			}
		}
		public static function removeFromDisplayTree(obj:DisplayObject):void
		{
			removeFromParent(obj);
			if(obj is DisplayObjectContainer)
			{
				removeAllChildren(DisplayObjectContainer(obj));
			}
		}
		
		public static function replaceChild(container:DisplayObjectContainer, newObj:DisplayObject,
											oldObj:DisplayObject=null, targetIndex:int=-1):DisplayObject
		{
			var oldIndex:int;
			
			if(oldObj == null)
			{
				oldIndex = -1;
			}
			else
			{
				if(container == oldObj.parent)
				{
					oldIndex = container.getChildIndex(oldObj);
				}
				else
				{
					oldIndex = -1;
				}
			}
			
			if(oldIndex>=0)
			{
				container.removeChild(oldObj);
				
				if(newObj != null)
				{					
					container.addChildAt(newObj, oldIndex);
				}
			}
			else
			{
				if(targetIndex>=0)
				{
					container.addChildAt(newObj, targetIndex);
				}
				else
				{
					container.addChild(newObj);
				}
			}
			return newObj;
		}
		
		public static function replacePlaceHolder(container:DisplayObjectContainer, newObj:DisplayObject, oldObj:DisplayObject):DisplayObject
		{
			newObj.x = oldObj.x;
			newObj.y = oldObj.y;
			newObj.width = oldObj.width;
			newObj.height = oldObj.height;
			return replaceChild(container, newObj, oldObj);
		}
		
		public static function changeMcParent(newParent:DisplayObjectContainer,mc:MovieClip):Boolean{
			if(mc.parent && newParent){
				var pt:Point = new Point(mc.x,mc.y);
				pt = mc.parent.localToGlobal(pt);
				pt = newParent.globalToLocal(pt);
				mc.x = pt.x;
				mc.y = pt.y;
				newParent.addChild(mc);
				return true;
			}
			return false;
		}
		
		public static function binarySearchContainer(container:DisplayObjectContainer, compareFunc:Function, object:Object):int
		{
			var start:int = 0;
			var	end:int = container.numChildren - 1;
			var middle:int = 0;
			var compare:Number = 0;
			
			if(start > end)
				return 0;
			
			while(start <= end)
			{
				middle = (start + end) / 2;
				compare = compareFunc(container.getChildAt(middle), object);
				
				if (compare == 0)
				{
					return middle;
				}
				else if(compare > 0)
				{
					end = middle - 1;
				}
				else // if(compare < 0)
				{
					start = middle + 1;
				}
			}
			return compare > 0 ? -middle-1 : -middle-2;
		}
		
		public static function setProgressBar(mc:MovieClip, currentCount:int, totalCount:int):void
		{
			if(currentCount > totalCount)
			{
				currentCount = totalCount;
			}
			
			var progress:int = currentCount * (mc.totalFrames - 1) / totalCount + 1;
			gotoAndStop(mc, progress);
		}
		
	
		
		public static function gotoAndStop(mc:MovieClip, frame:int):void
		{
			if(mc.currentFrame != frame)
			{
				mc.gotoAndStop(frame);
			}
		}
		
		public static function markMovieclipOffset(mc:MovieClip, newX:int, newY:int):void
		{
			mc.markForOriginalX = mc.x;
			mc.markForOriginalY = mc.y;
			mc.markForNewPositionX = newX;
			mc.markForNewPositionY = newY;
		}
		
		public static function markRestorePosition(mc:MovieClip, useNew:Boolean):void
		{
			if(useNew)
			{
				mc.x = mc.markForNewPositionX;
				mc.y = mc.markForNewPositionY;
			}
			else
			{
				mc.x = mc.markForOriginalX;
				mc.y = mc.markForOriginalY;
			}
		}
		
		public static function suitSize(t:DisplayObject,maxWidth:Number,maxHeight:Number):void
		{
			var scale:Number = maxHeight /  t.height;
			t.scaleX = scale;
			t.scaleY = scale;
			
			if(t.width > maxWidth)
			{
				scale = maxWidth / t.width;
				t.scaleX *= scale;
				t.scaleY *= scale;
			}
		}
	}
}


