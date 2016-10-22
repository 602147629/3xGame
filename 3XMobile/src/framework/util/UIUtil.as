package framework.util
{

	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import flash.events.TouchEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import framework.core.ObjectPool;
	import framework.datagram.Datagram;
	import framework.fibre.core.Fibre;
	import framework.text.TextHandler;
	import framework.util.playControl.ListenMovieClipToEnd;
	import framework.view.ConstantUI;
	
	public class UIUtil
	{
		public static var cachedStranger:Object = {};

		public static var picLoaderArray:Array = [];
		public static var continerArray:Array = [];
		public static var fillScaleArray:Array = [];
		public static var cachedBitmapData:Object = new Object();
		
		public static const NTF_UI_UTIL_ROLL_OVER:String = "NTF_UI_UTIL_ROLL_OVER";
		public static const NTF_UI_UTIL_ROLL_OUT:String = "NTF_UI_UTIL_ROLL_OUT";

		public static const TYPE_FILTER_BLACK_AND_WHITE:String = "blackAndWhite";
		public static const TYPE_FILTER_BLUR:String = "blur";
		public static const TYPE_FILTER_BLACK_GLOW:String = "black_glow";
		public static const TYPE_FILTER_FACILITY_NO_MAINTENANCE:String = "facility_no_maintenance";

		public static const TYPE_TRAN_DARK:String = "dark";
		public static const TYPE_TRAN_BRIGHT:String = "bright";

		public static const BUTTON_DYN_NAME_SELECTED:String = "BUTTON_DYN_NAME_SELECTED";
		public static const BUTTON_DYN_NAME_DISABLE:String = "BUTTON_DYN_NAME_DISABLE";

		public static var placeholderPool:ObjectPool;
		public static const TWEAK_MATRIX : Matrix = new Matrix(0.969085693359375, 0.2374267578125, 0, 1);
		public static const ICON_DEFAULT_SCALE:Number = 1;
		private static const processingUserInfo : Vector.<String> = new Vector.<String>();
		private static const USE_TWEAK_FOR_TIPS : Boolean = false;
		
		public static var urlImageLoadController:UrlImageLoadController = new UrlImageLoadController();
		
		public function UIUtil()
		{
			
		}
		
		public static function setURLPicture(container:DisplayObjectContainer,url:String, isFillScale:Boolean = false):void
		{
			
			if(container == null||url==null)
				return;
			CONFIG::debug
			{
				ASSERT(url!=null, "ASSERT");
			}
			
			if(isFillScale)
			{
//				saveOldContainerSize(container);
			}
			
			DisplayUtil.removeAllChildren(container);
			var innerContainer:Sprite = new Sprite();
			container.addChild(innerContainer);
			
			if(UrlImageLoadingTask.cachedBitmapData[url] != null)
			{
				var bitmap:Bitmap = UrlImageLoadingTask.createBitmapForUrlImage(container, UrlImageLoadingTask.cachedBitmapData[url], isFillScale);
				innerContainer.addChild(bitmap);

			}
			else
			{
				urlImageLoadController.add(url, container, innerContainer, isFillScale);
				
			}
		}
		
	
		
		public static function suitInRect(dis:DisplayObject,rect:Rectangle):void
		{
			var r:Rectangle = dis.getBounds(dis.parent);
			dis.width += rect.width - r.width;
			dis.height += rect.height - r.height;
			
			r = dis.getBounds(dis.parent);
			dis.x += rect.x - r.x;
			dis.y += rect.y - r.y;
		}
		
		public static function initAssetByOperationArray(mc:DisplayObjectContainer,operation:Array):void
		{
			if(!operation)
				return;
			for(var i:int = 0 ; i < operation.length ; i++)
			{
				var theName:String = operation[i][0];
				var frame:int = operation[i][1];
				
				var m:MovieClip = mc.getChildByName(theName) as MovieClip;
				m.gotoAndStop(frame);
			}
		}
		
		private static function tipModeObjRollOverHandle(e:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(NTF_UI_UTIL_ROLL_OVER,new Datagram());
		}

		private static function tipModeObjRollOutHandle(e:TouchEvent):void
		{
			Fibre.getInstance().sendNotification(NTF_UI_UTIL_ROLL_OUT,new Datagram());
		}
		
		public static function getSetBackgroundIconCenterCallback():Function
		{
			var onLoadIconDone:Function = function(icon:MovieClip):void
			{
				makeIconInCenter(icon);
			}
			
			return onLoadIconDone;
		}
		
		public static function setIconInCenter(mc : DisplayObjectContainer, icon : DisplayObject, scale:Number = ICON_DEFAULT_SCALE) : void
		{
			setIcon(mc,icon,scale);
			makeIconInCenter(icon);
		}
		
		public static function makeIconInCenter(icon:DisplayObject):void
		{
			if(icon.parent != null)
			{
				var rect:Rectangle = icon.getBounds(icon.parent);
				icon.x += (-rect.width / 2 - rect.x);
				icon.y += (-rect.height / 2 - rect.y);	
			}
		}
		
		public static function setIcon(mc : DisplayObjectContainer, icon : DisplayObject, scale:Number = ICON_DEFAULT_SCALE) : void
		{
			if(scale != ICON_DEFAULT_SCALE)
			{
				icon.scaleX = icon.scaleY = scale;
			}
			DisplayUtil.removeAllChildren(mc);
			mc.addChild(icon); 
		}
		
		
		private static const KEY_OF_DRAW_CONTENT_TICKET:String = "KEY_OF_DRAW_CONTENT_TICKET";
		
		public static function tryIncreaseContainerVersion(dis:DisplayObject):void
		{
			var containerMc:MovieClip = dis as MovieClip;
			if(containerMc != null)
			{
				if(containerMc[KEY_OF_DRAW_CONTENT_TICKET] != null)
				{
					containerMc[KEY_OF_DRAW_CONTENT_TICKET] ++;
				}
				else
				{
					containerMc[KEY_OF_DRAW_CONTENT_TICKET] = 0;
				}
			}
		}

		
		
		
		private static function setScale(m:DisplayObject, hintWidth:Number, hintHeight:Number):void
		{
			var width:int = m.width;
			var height:int = m.height;
			
			var r:Rectangle = m.getRect(null);
			var picHeight:int = -r.top + height;//m.height;
			
			var scale:Number = hintWidth / width;
			
			if(picHeight * scale > hintHeight)
			{
				var scale2:Number = hintHeight / (picHeight * scale);
				if(scale2 < 1)
				{
					scale = scale * scale2;
				}
			}
			
			if(scale > 1)
			{
				scale = 1;
			}
			
			m.scaleX = scale;
			m.scaleY = scale;

		}

		
		
		public static function getFilters(type:String):Array
		{
			var resultFilters:Array = ResHandler.getMcFirstLoad("FilterSamples").getChildByName(type).filters;
			return resultFilters;
		}
		
		public static function clearFilter(mc:DisplayObject):void
		{
			mc.filters = [];
		}
		
		public static function setFilter(mc:DisplayObject, type:String):void
		{
			if(type == "")
			{
				mc.filters = [];
			}
			else
			{
				var resultFilters:Array = ResHandler.getMcFirstLoad("FilterSamples").getChildByName(type).filters;
				mc.filters = resultFilters;
			}	
		}
		
		public static function setFilters(mc:DisplayObject, filters:Array):void
		{
			CONFIG::debug
			{
				ASSERT(mc != null, "ASSERT");
				ASSERT(filters != null, "ASSERT");
			}
			
			mc.filters = filters;
		}
		
		
		public static function setTran(mc:DisplayObject, type:String):void
		{
			if(type == "")
			{
				mc.transform.colorTransform = new ColorTransform();
			}else
			{
				var col:ColorTransform = ResHandler.getMcFirstLoad("TransformSamples").getChildByName(type).transform.colorTransform;
				mc.transform.colorTransform = col;
			}	
		}
				
	    public static function isButtonDisable(button:MovieClip):Boolean
		{
			return button[BUTTON_DYN_NAME_DISABLE];
		}
		
		public static function setButtonDisable(button:MovieClip,on:Boolean):void
		{
			button[BUTTON_DYN_NAME_DISABLE] = on;
			button.enabled = !on;
			button.mouseEnabled = !on;
			if(!button[BUTTON_DYN_NAME_DISABLE])
			{
				if(button[BUTTON_DYN_NAME_SELECTED])
				{
					button.gotoAndStop("selected");
				}
				else
				{
					button.gotoAndStop("up");
				}
					
			}else
			{
				button.gotoAndStop("disable");
			}
		}
		
		public static function setButtonSelected(button:MovieClip,on:Boolean):void
		{
			button[BUTTON_DYN_NAME_SELECTED] = on;
			if(button[BUTTON_DYN_NAME_SELECTED])
			{
				button.gotoAndStop("selected");
			}
			else
			{
				button.gotoAndStop("up");
			}
				
		}
		
		public static function isButtonSlected(button : MovieClip) : Boolean
		{
			return button[BUTTON_DYN_NAME_SELECTED];
		}
		
		public static function setButtonTextByID(button:MovieClip, textID:String,rank:int = 1):void
		{
			if (textID != "")
			{
				var textfield:TextField = findTextField(button,{rank:rank});
				if (textfield)
				{
					TextHandler.setTextByID(textfield, textID);
				}
			}			
		}
		
		public static function findTextField(con:DisplayObject,rankObj:Object):TextField
		{
			if(con is DisplayObjectContainer)
			{
				var c:DisplayObjectContainer = con as DisplayObjectContainer;
				for(var i:int = 0 ; i < c.numChildren ; i++)
				{
					var result:TextField = findTextField(c.getChildAt(i),rankObj);
					if(result != null)
					{
						return result;
					}
				}
			}
			else if(con is TextField)
			{
				if(-- rankObj.rank == 0)
				{
					return con as TextField;
				}
			}
			return null;
		}
		
		public static function setButtonMode(button : MovieClip,on:Boolean=true,label:String = "",mouseChildren:Boolean = false):void
		{
			if ( button != null )
			{	
				setButtonTextByID(button,label);
				
				if ( on )
				{
					button.gotoAndStop("up");
						
					button.buttonMode = true;
					button.enabled = true;
					
					button.addEventListener(TouchEvent.TOUCH_END, buttonUpListener, false, 0, true);
					button.addEventListener(TouchEvent.TOUCH_BEGIN, buttonDownListener, false, 0, true);
					button.addEventListener(TouchEvent.TOUCH_ROLL_OVER, buttonOverListener, false, 0, true);
					button.addEventListener(TouchEvent.TOUCH_ROLL_OUT, buttonOutListener, false, 0, true);
					button.mouseChildren = mouseChildren;
				}
				else
				{
					button.gotoAndStop("disable");
					button.buttonMode = false;
					button.enabled = false;
					button.removeEventListener(TouchEvent.TOUCH_END, buttonUpListener);
					button.removeEventListener(TouchEvent.TOUCH_BEGIN, buttonDownListener);
					button.removeEventListener(TouchEvent.TOUCH_ROLL_OVER, buttonOverListener);
					button.removeEventListener(TouchEvent.TOUCH_ROLL_OUT, buttonOutListener);
				}
			}
			
			
		}
		
		
		
		private static function buttonUpListener(e:TouchEvent):void
		{
			var button:MovieClip = e.currentTarget as MovieClip;
			if(!button[BUTTON_DYN_NAME_DISABLE])
			{
				if(button[BUTTON_DYN_NAME_SELECTED])
				{
					if(haveFrameLable(button,"selected"))
						button.gotoAndStop("selected");
				}
				else
					button.gotoAndStop("up");
			}
		}
		
		private static function buttonDownListener(e : TouchEvent):void
		{
			var button:MovieClip = e.currentTarget as MovieClip;
			if(!button[BUTTON_DYN_NAME_DISABLE])
			{
				if(button[BUTTON_DYN_NAME_SELECTED])
				{
					if(haveFrameLable(button,"selectedDown"))
						button.gotoAndStop("selectedDown");
				}
				else
					button.gotoAndStop("down");
			}
		}
		
		private static function buttonOverListener(e : TouchEvent):void
		{
			var button:MovieClip = e.currentTarget as MovieClip;
			if(!button[BUTTON_DYN_NAME_DISABLE])
			{
				if(button[BUTTON_DYN_NAME_SELECTED])
				{
					if(haveFrameLable(button,"selectedOver"))
						button.gotoAndStop("selectedOver");
				}
				else
					button.gotoAndStop("over");
			}
		}
		
		private static function buttonOutListener(e : TouchEvent):void
		{
			var button:MovieClip = e.currentTarget as MovieClip;
			if(!button[BUTTON_DYN_NAME_DISABLE])
			{
				if(button[BUTTON_DYN_NAME_SELECTED])
				{
					if(haveFrameLable(button,"selected"))
						button.gotoAndStop("selected");
				}
				else
					button.gotoAndStop("up");
			}
		}
		
		public static function haveFrameLable(mc:MovieClip,frameName:String):Boolean
		{
			for(var i:int = 0 ; i < mc.currentLabels.length ; i++)
			{
				var frameLabel :FrameLabel =  mc.currentLabels[i];
				if(frameLabel.name == frameName)
					return true;
			}
			return false;
		}
		
		public static function setButtonModeForSprite(button : MovieClip,on:Boolean=true,label:String = "",mouseChildren:Boolean = false):void
		{
			if ( button != null )
			{	
				setButtonTextByID(button,label);
				
				if ( on )
				{
					button.mouseChildren = mouseChildren;
					
					// Store scale
					if(button["_____buttonOldScaleX"] == null)
					{
						button["_____buttonOldScaleX"] = button.scaleX;
						button["_____buttonOldScaleY"] = button.scaleY;
					}
					
					button.buttonMode = true;
					button.addEventListener(TouchEvent.TOUCH_END, buttonUpListenerForSprite, false, 0, true);
					button.addEventListener(TouchEvent.TOUCH_BEGIN, buttonDownListenerForSprite, false, 0, true);
					button.addEventListener(TouchEvent.TOUCH_ROLL_OVER, buttonOverListenerForSprite, false, 0, true);
					button.addEventListener(TouchEvent.TOUCH_ROLL_OUT, buttonOutListenerForSprite, false, 0, true);
				}
				else
				{
					button.buttonMode = false;
					button.removeEventListener(TouchEvent.TOUCH_END, buttonUpListenerForSprite);
					button.removeEventListener(TouchEvent.TOUCH_BEGIN, buttonDownListenerForSprite);
					button.removeEventListener(TouchEvent.TOUCH_ROLL_OVER, buttonOverListenerForSprite);
					button.removeEventListener(TouchEvent.TOUCH_ROLL_OUT, buttonOutListenerForSprite);
				}
			}
		}
		
		private static function buttonUpListenerForSprite(e:TouchEvent):void
		{
			var button:MovieClip = e.currentTarget as MovieClip;
			button.scaleX = button["_____buttonOldScaleX"] * 1.05;
			button.scaleY = button["_____buttonOldScaleY"] * 1.05;	
		}
		
		private static function buttonDownListenerForSprite(e : TouchEvent):void
		{
			var button:MovieClip = e.currentTarget as MovieClip;
			button.scaleX = button["_____buttonOldScaleX"] * 1.02;
			button.scaleY = button["_____buttonOldScaleY"] * 1.02;	
		}
		
		private static function buttonOverListenerForSprite(e : TouchEvent):void
		{
			var button:MovieClip = e.currentTarget as MovieClip;
			button.scaleX = button["_____buttonOldScaleX"] * 1.05;
			button.scaleY = button["_____buttonOldScaleY"] * 1.05;	
		}
		
		private static function buttonOutListenerForSprite(e : TouchEvent):void
		{
			var button:MovieClip = e.currentTarget as MovieClip;
			button.scaleX = button["_____buttonOldScaleX"] * 1;
			button.scaleY = button["_____buttonOldScaleY"] * 1;	
		}
		
		public static function cs_Batch(maxIndex:int,container:MovieClip,fun:Function):void
		{
			for(var i:int = 0 ; i <= maxIndex; i ++)
			{
				container["cs_"+i].index = i;
				fun(container["cs_"+i]);
			}
		}
		
		public static function setDisplayDisplayObjects(str:String, len:int, mo:DisplayObjectContainer, index:int=-1,startIndex:int=0,display:Boolean = false):DisplayObject {
			for (var i:uint=startIndex; i < len+startIndex; i++)
			{
				mo[str + i].visible=display;
			}
			if (index != -1)
			{
				mo[str + index].visible=!display;
				return mo[str + index];
			}
			return null;
		}
		
		public static function setDisplayArray(parent:DisplayObjectContainer,childrenNames:Array,index:int = -1,isDisplay:Boolean = false):DisplayObject
		{
			for(var i:int=0; i < childrenNames.length; i++)
			{
				parent[childrenNames[i]].visible = isDisplay;
			}
			if(index != -1)
			{
				parent[childrenNames[index]].visible = !isDisplay;
				return 	parent[childrenNames[index]];
			}
			return null;
		}
		
		public static function setVisible(obj:MovieClip,on:Boolean):void
		{
			if (obj != null)
				obj.visible = on;
			return;
			
			
/*			if(placeholderPool == null)
				placeholderPool = new ObjectPool(Placeholder);
			//if(getVisible(obj) == on)
			//return;
			var index:int;
			if(!on)
			{
				if(obj.placeholder)
					return;
				obj.placeholder = placeholderPool.query();
				
				if(obj.hasOwnProperty("_z_value"))
				{
					obj.placeholder._z_value = obj._z_value;
				}
				else
				{
					delete obj.placeholder._z_value;
				}
				
				index = obj.parent.getChildIndex(obj);
				obj.parent.addChildAt(obj.placeholder,index);
				obj.parent.removeChild(obj);
			}else
			{
				if(obj.placeholder == null)
					return;
				index =obj.placeholder.parent.getChildIndex(obj.placeholder);
				obj.placeholder.parent.addChildAt(obj,index);
				obj.placeholder.parent.removeChild(obj.placeholder);
				placeholderPool.free(obj.placeholder);
				obj.placeholder = null;
			}
*/			
		}

		
		
		public static function simpleSetVisible(obj:DisplayObject, visible:Boolean):void
		{
			if(obj != null)
			{
				obj.visible = visible;
			}
		}
		
		public static function isVisible(obj:MovieClip):Boolean
		{
			return obj.visible;
			
//			return (obj.parent != null);
		}
		
		public static function warpTip(tip:DisplayObject):void
		{
			
			//var m:Matrix = new Matrix(2, 0, 0, 2)
			if(USE_TWEAK_FOR_TIPS)
			{
				var m0:Matrix = tip.transform.matrix;
				if(m0 == null)
				{
					m0 = new Matrix();	
				}
				m0.concat(TWEAK_MATRIX);
				tip.transform.matrix = m0;				
			}
		}
		
		public static function scaleToFitIn(displayObject : DisplayObject , width : Number , height : Number) : void
		{
			var realWidth : Number = displayObject.width / displayObject.scaleX;
			var realHeight : Number = displayObject.height / displayObject.scaleY;
			
			var ratioX : Number = width / realWidth;
			var ratioY : Number = height / realHeight;
			
			var scaleX : Number = displayObject.scaleX;
			var scaleY : Number = displayObject.scaleY;
			
			if(realWidth * ratioY > width)
			{
				scaleX = scaleY = ratioX;
			}else{
				scaleX = scaleY = ratioY;
			}
			
			displayObject.scaleX = scaleX;
			displayObject.scaleY = scaleY;
		}
		
/*		public static function setTipPosition(mapObject : MapObject , tip : DisplayObject) : void
		{
			var  iconPosition:AssetIconPositionDefine = StaticIconDefine.instance.getIconDefineByName(mapObject.res.className,mapObject.getDisplayFrame());
			if(iconPosition != null)
			{
				tip.x = mapObject.x - iconPosition.xOffset;
				tip.y = mapObject.y - iconPosition.yOffset;
			}
			else
			{				
				var effectObjectPosition : Point = Camera.instance.getWorldPositionByCellPosition(mapObject.frame.columnNum , mapObject.frame.rowNum);
				tip.x = mapObject.x - effectObjectPosition.x / 2;
				tip.y = mapObject.y - (mapObject.resObject.height > 0 ? mapObject.resObject.height : effectObjectPosition.y / 2);
			}
			
//			if(hasFloatingAnimation && QualityManager.instance.isShowTipFloatingAnimation())
//			{
//				tip.y += int(Math.sin(getTimer() / 500) * 10);
//			}
		}
*/
		public static function getColorHtml(str:* , col:String = "#ff0000" , on:Boolean = true):String
		{
			str = String(str)
			
			if(on)
				str = "<FONT COLOR='" +col+ "'><B>" + str + "</B></FONT>";
			return str;
		}
		
		public static function getBoldHtml(str:*,on:Boolean=true):String
		{
			str = String(str)
			if(on)
			{
				str = "<b>" + str + "</b>"
			}
			return str;
		}
		
		
		public static function getRootNameByAssetAllocationString(assetAllocationString:String):String
		{
			var jinghao_index:int = assetAllocationString.indexOf("#");
			var assetAllocationString_root_class_name:String = assetAllocationString.substr(0,jinghao_index );
			return assetAllocationString_root_class_name;
		}
		
		
		public static function findChildByChildNameArray(nameArray:Array,from:DisplayObjectContainer):DisplayObject
		{
			var current:DisplayObject = from;
			for(var i :int = 0 ; i < nameArray.length ; i++)
			{
				if(i < nameArray.length - 1)
				{
					if(current is DisplayObjectContainer)
					{
						current = (current as DisplayObjectContainer).getChildByName(nameArray[i]) as DisplayObjectContainer;
					}
					else
					{
						current = null;
						break;
					}
				}
				else if(current is DisplayObjectContainer)
				{
					current = (current as DisplayObjectContainer).getChildByName(nameArray[i]) as DisplayObject;
				}
				else
				{
					current = null;
					break;
				}
			}
			return current;
		}
		
		//WorldFriendUI#instance77.cs_123
		public static function getSpecChildByAssetAllocationString(assetAllocationString:String,root:DisplayObjectContainer):DisplayObject
		{
			var jinghao_index:int = 	assetAllocationString.indexOf("#");
			var rootClassName:String = getQualifiedClassName(root);
				
				var assetAllocationString_root_class_name:String = assetAllocationString.substr(0,jinghao_index );
				var otherString:String = assetAllocationString.substr(jinghao_index + 1);
				if(rootClassName.indexOf(assetAllocationString_root_class_name) == -1)
				{
					return null; // not in my root
				}
				else
				{
					var containerNameArr:Array = otherString.split(".");
					return findChildByChildNameArray(containerNameArr,root);
					
				}
				return null;
				}
		
		
		public static function isRootName(name:String,instName:String):Boolean
		{
			if(name.indexOf("UI")!= -1)
			{
				if(name.indexOf("fla") == -1 )
				{
					return true;
				}
			}
			
			if(instName!= null)
			{
				if(instName.indexOf("UI")!= -1)
				{
//					if(instName.indexOf("Panel") != -1 || instName.indexOf("World") != -1)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public static function popUpError(errorMessage:String):void
		{
			var text:TextField = new TextField();
			text.text = errorMessage;
			text.width = 200;
			text.wordWrap =  true;
			text.x = 46;
			text.y = 85;
			GameEngine.getInstance().stage.addChild(text);
		}
		
		public static function hideAfterPlayOnce(movieclip:MovieClip):void
		{
			new ListenMovieClipToEnd(
				movieclip,
				function(target:MovieClip):void
				{
					movieclip.stop();
					movieclip.visible = false
				});
		}
		
		public static function drawDarkBG(bg:Sprite):void
		{
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000,1);
			bg.graphics.drawRect(0,0,GameEngine.getInstance().stage.stageWidth,GameEngine.getInstance().stage.stageHeight);
			
			bg.graphics.endFill();
			bg.alpha = 0.4;
		}
		
		public static function drawDarkMask(bg:Sprite, x:Number, y:Number):void
		{
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000,1);
			bg.graphics.drawRect(0,0,GameEngine.getInstance().stage.stageWidth,GameEngine.getInstance().stage.stageHeight);
			bg.graphics.drawRect(x, y, ConstantUI.WIDTH, ConstantUI.HEIGHT);
			bg.graphics.endFill();
			bg.alpha = 1;
			
			
			
			//cover.x = FullScreenHandler.instance.getScreenXOffset()
			//cover.y = FullScreenHandler.instance.getScreenYOffset()
			
		}

		
		public static function isDisplayObjectVisible(object:DisplayObject):Boolean
		{
			if(!object.visible)
			{
				return false;
			}
			
			while(object.parent != null)
			{
				if(!object.parent.visible)
				{
					return false;
				}
				
				object = object.parent;
			}
			return true;
		}
		
		
		public static function fadeInOut(fadeInObj:DisplayObject, fadeOutObj:DisplayObject, duration:Number = 0.3):void
		{
			TweenLite.killTweensOf(fadeInObj, true);
			TweenLite.killTweensOf(fadeOutObj, true);
			fadeInObj.visible = true;
			fadeOutObj.visible = true;
			fadeInObj.alpha = 0;
			fadeOutObj.alpha = 1;
			TweenLite.to(fadeInObj, duration, {alpha: 1});
			TweenLite.to(fadeOutObj, duration, {alpha: 0, 
				onComplete: function():void
				{
					fadeOutObj.visible = false;
				}
			});
		}
		
		public static function getFrameBegin(labels:Array,labelName:String):int
		{
			for(var i:int = 0 ; i < labels.length ; i ++)
			{
				if(labels[i].name == labelName)
				{
					return labels[i].frame; 
				}
			}
			
			return -1;
		}
		
		public static const NOT_IN_DISPLAY_LIST_NOT_ALLOCATION_STRING:String = "NOT_IN_DISPLAY_LIST_NOT_ALLOCATION_STRING";
		public static function generateAssetAllocationString(tf:DisplayObject):String
		{
			if(tf == GameEngine.getInstance())
			{
				return "clickOnStage";
			}
			var keyStr:String = "";
			var currentLvl:DisplayObject = tf;
			
			keyStr = currentLvl.name;
			
			while(true)
			{
				currentLvl = currentLvl.parent;
				if(currentLvl == null)
				{
					return NOT_IN_DISPLAY_LIST_NOT_ALLOCATION_STRING;
				}
				
				var defName:String = getQualifiedClassName(currentLvl);
				if(!isRootName(defName,currentLvl.name)) // used package
				{
					keyStr =  currentLvl.name +"."+keyStr;
				}
				else //default package
				{
					keyStr = defName +"#" + keyStr;
					break;
				}
			}
			
			return keyStr;
		}
	}
}		
		
		
	