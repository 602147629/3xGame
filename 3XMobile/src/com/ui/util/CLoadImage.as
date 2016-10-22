package com.ui.util
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import framework.util.ResHandler;
	import framework.view.ConstantUI;

	/**
	 * @author caihua
	 * @comment 图像延迟加载
	 * 创建时间：2014-7-4  下午6:10:38 
	 */
	final public class CLoadImage extends Sprite
	{
		private var _url:String; //图片url
		private var _width:Number = 0; //图片宽
		private var _height:Number = 0; //图片高
		private var _isLoading:Boolean; //是否显示loading

		private var _tip:String; //tip文字
		private var _bitmap:Bitmap; //图像
		private var _loading:MovieClip; //loading动画
		private var _tag:int; //标志位
		private var _size:int; //
		private var _cacheTime:int;

		/**
		 * 图像类
		 */
		public function CLoadImage(url:String = null, width:Number = 0, height:Number = 0, isLoading:Boolean = false, cacheTime:int = 0)
		{
			this.mouseChildren = false;
			this._cacheTime = cacheTime;
			this._url = url;
			this._width = width;
			this._height = height;
			this._isLoading = isLoading;
			this.draw();
		}

		public function draw():void
		{
			if (this._isLoading)
			{
				var cls:Class = ResHandler.getClass(ConstantUI.ICON_LOADING);
				this._loading = new cls();
				if (this._width > 0 && this._height > 0)
				{
					this._loading.width = this._width ;
					this._loading.height = this._height;
				}
				this.addChild(this._loading);
			}
			var needLoad:Boolean = this.checkNeedReload();
			if (needLoad)
			{
				var ldr:Loader = new Loader();
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);

				var urlReq:URLRequest = new URLRequest(this._url);
				var lc:LoaderContext = new LoaderContext(true);
				ldr.load(urlReq, lc);
			}
			else
			{
				this._bitmap = new Bitmap(CBitmapData.o().getCompose(this._url));
				this.completeHandler();
			}
		}

		private function onError(e:IOErrorEvent):void
		{
			trace('CLoadImage IO Error');
		}

		/**
		 * 检查是否需要重新加载
		 */
		private function checkNeedReload():Boolean
		{
			if (0 == this._cacheTime)
			{
				return true;
			}
			var key:String = this._url;
			if (!CBitmapData.o().has(key))
			{
				return true;
			}
			else
			{
				var obj:Object = CBitmapData.o().getData(key);
				var date:Date = new Date();
				var elapsedTime:int = date.getTime() - int(obj["lasttime"]);
				if (elapsedTime < this._cacheTime * 1000)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
		}

		private function completeHandler(e:Event = null):void
		{
			//清空loading动画
			if (null != this._loading)
			{
				if (this.contains(this._loading))
				{
					this.removeChild(this._loading);
				}
				this._loading = null;
			}
			if (e != null)
			{
				this._bitmap = new Bitmap(Bitmap(e.target.content).bitmapData);
				if (0 != this._cacheTime)
				{
					CBitmapData.o().setCompose(this._url, Bitmap(e.target.content).bitmapData);
				}
			}
			if (this._width > 0 && this._height > 0)
			{
				var scale:Number = Math.min(this._width / this._bitmap.width, this._height / this._bitmap.height);
				if (scale < 1)
				{

					var bitmapData:BitmapData = new BitmapData(this._bitmap.bitmapData.width * scale, this._bitmap.bitmapData.height * scale, true, 0);
					var matrix:Matrix = new Matrix();
					matrix.scale(scale, scale);
					bitmapData.draw(this._bitmap.bitmapData, matrix, null, null, null, true);
					if (0 == this._cacheTime)
					{
						this._bitmap.bitmapData.dispose();
					}
					this._bitmap.bitmapData = bitmapData;
				}
				this._bitmap.x = (this._width - this._bitmap.width) / 2;
				this._bitmap.y = (this._height - this._bitmap.height) / 2;
			}
			else
			{
				this._width = this._bitmap.width;
				this._height = this._bitmap.height;
			}
			this._bitmap.smoothing = true;
			this.addChildAt(this._bitmap, 0);
			if (null != e)
			{
				e.target.loader.unload();
				this.dispatchEvent(e);
			}
			else
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		public function setTag(tag:int):void
		{
			this._tag = tag;
		}

		public function get __tag():int
		{
			return this._tag;
		}

		public function setTip(tip:String):void
		{
			this._tip = tip;
		}

		public function setSize(size:int):void
		{
			this._size = size;
		}

		public function get __tip():String
		{
			return this._tip;
		}

		public function get __url():String
		{
			return this._url;
		}

		public function get __size():int
		{
			return this._size;
		}
	}
}
