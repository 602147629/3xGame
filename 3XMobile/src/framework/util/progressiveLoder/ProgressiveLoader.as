package framework.util.progressiveLoder
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import framework.resource.Resource;
	
	/**
	 * 开始下载时触发该事件.
	 * @eventType OPEN
	 */
	[Event(name="open", type="flash.events.Event")]
	
	/**
	 * 正在下载时触发该事件.
	 * @eventType PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * 下载完成时触发该事件.
	 * @eventType COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * 当服务器有状态码返回时触发该事件.
	 * @eventType HTTP_STATUS
	 */
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	/**
	 * 文件不存在时触发该事件.
	 * @eventType IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 安全沙箱异常时触发该事件.
	 * @eventType SECURITY_ERROR
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * <code>ProgressiveLoader</code> 类用于下载渐进式图片, 实际效果为下载时图片是模糊的, 然后渐渐的会清晰起来.
	 * 注意: 下载的图片需为渐进式格式的 <code>JEPG</code> 类型的图片才行.
	 * @author wizardc
	 */
	public class ProgressiveLoader extends Bitmap 
	{
		
		/*
		* 如果直接用 Loader.loadBytes 载入数据流会有以下两个 bug.
		* bug1(加载时图片会闪烁):
		* 直接显示用于加载的 loader 对象会在加载时出现闪烁, 解决方法就是用 bitmap 
		* 对象来进行显示, 在每一次加载完成时取出位图数据到显示的 bitmap 中即可.
		* bug2(加载后显示不完整):
		* 之所以用两个 loader 对象来加载是由于如果只用一个 loader 来加载会出现最终
		* 显示的图片是某一缓冲中的图片, 而此时其实图片是加载完成的, 解决该 bug 的关
		* 键就是分别用两个 loader 对象来处理, 一个专用于显示缓冲中的图片, 另一个专
		* 用于显示加载完成时的图片.
		*/
		private var _bufferLoader:Loader;                                                                                //用于显示缓冲中的图片的 loader 对象
		private var _completeloader:Loader;                                                                                //用于显示最终加载完成的图片
		
		private var _stream:URLStream;                                                                                        //载入流对象
		private var _bytes:ByteArray;                                                                                        //记录载入的字节对象
		
		private var _cbReady:Function;
		private var _owner:Resource;
		/**
		 * 创建一个 <code>ProgressiveLoader</code> 对象.
		 */
		public function ProgressiveLoader(owner:Resource, cbReady:Function)
		{
			_owner = owner;
			_cbReady = cbReady;
			
			load(new URLRequest(owner.file.referenceRsvFile.getUrl()));
		}
		
		/**
		 * 开始载入渐进式图片.
		 * @param $request 要加载的文件的绝对或相对路径.
		 */
		public function load(request:URLRequest):void
		{
			_bufferLoader = new Loader();
			_completeloader = new Loader();
			_stream = new URLStream();
			_bytes = new ByteArray();
			addEventHandler();
			_stream.load(request);
		}
		
		/**
		 * 取消当前的下载.
		 */
		public function close():void
		{
			removeEventHandler();
			cleanup();
		}
		
		/**
		 * 卸载掉加载的图片.
		 */
		public function unload():void
		{
			super.bitmapData = null;
		}
		
		/*
		* 核心处理方法.
		*/
		private function onLoading(event:ProgressEvent):void
		{
			if(_stream.bytesAvailable>0)
				_stream.readBytes(_bytes, _bytes.length);
			if(_bytes.length>0)
			{
				_bufferLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDrawBufferPicture);
				_bufferLoader.loadBytes(_bytes);
			}
			dispatchEvent(event);
		}
		private function onDrawBufferPicture(event:Event):void
		{
			super.bitmapData = ((event.target as LoaderInfo).content as Bitmap).bitmapData;
		}
		private function onComplete(event:Event):void
		{
			if(_stream.bytesAvailable>0)
				_stream.readBytes(_bytes, _bytes.length);
			if(_bytes.length>0)
			{
				_completeloader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDrawCompletePicture);
				_completeloader.loadBytes(_bytes);
			}
			removeEventHandler();
			dispatchEvent(event);
		}
		private function onDrawCompletePicture($event:Event):void{
			super.bitmapData = (($event.target as LoaderInfo).content as Bitmap).bitmapData;
			_owner.file.content = this.bitmapData;
			if(_cbReady != null)
			{
				_cbReady(this);
			}
			
			cleanup();
		}
		
		private function cleanup():void{
			if(_stream.connected)
				_stream.close();
			_stream = null;
			_bytes = null;
			_bufferLoader.unload();
			_bufferLoader = null;
			_completeloader.unload();
			_bufferLoader = null;
		}
		
		/*
		* 完善事件.
		*/
		private function addEventHandler():void{
			_stream.addEventListener(Event.OPEN, onOpen);
			_stream.addEventListener(ProgressEvent.PROGRESS, onLoading);
			_stream.addEventListener(Event.COMPLETE, onComplete);
//			_stream.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
//			_stream.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
//			_stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		private function removeEventHandler():void{
			_stream.removeEventListener(Event.OPEN, onOpen);
			_stream.removeEventListener(ProgressEvent.PROGRESS, onLoading);
			_stream.removeEventListener(Event.COMPLETE, onComplete);
//			_stream.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
//			_stream.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
//			_stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		private function onOpen(event:Event):void{
			dispatchEvent(event);
		}
		/*private function onHttpStatus($event:HTTPStatusEvent):void{
			dispatchEvent($event);
		}
		private function onIoError($event:IOErrorEvent):void{
			removeEventHandler();
			dispatchEvent($event);
		}
		private function onSecurityError($event:SecurityErrorEvent):void{
			removeEventHandler();
			dispatchEvent($event);
		}*/
		
	}
}