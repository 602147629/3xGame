package framework.view.animation
{
	import com.game.consts.ResourceConst;
	import com.game.utils.Gutils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.utils.getQualifiedClassName;
	
	import framework.model.BackgroundLoadProxy;
	import framework.model.StaticResProxy;
	import framework.resource.ResourceFactory;
	import framework.resource.ResourceManager;
	import framework.resource.faxb.animation.Animation;
	import framework.resource.faxb.animation.Frame;
	import framework.resource.faxb.animation.Part;
	import framework.resource.faxb.animation.Resource;
	import framework.resource.faxb.imageClip.Clip;
	import framework.resource.faxb.imageClip.ImageClip;
	import framework.util.ResHandler;
	import framework.util.cacher.CachePlaceholder;
	import framework.util.cacher.PlaceholderHelper;
	import framework.util.faxb.FAXB;
	import framework.util.rsv.Rsv;
	import framework.util.rsv.RsvEvent;
	import framework.util.rsv.RsvFile;

	public class FrameCache
	{
		private var _images:Vector.<DisplayObject>;
		public var name:int;
		private var _frameData:Frame;
		private var _imageDatas:Object;
		private var _animationDatas:Object;
		private var _isLoadNumber:int;
		
		
		public var repeatNumber:int;
		
		public function FrameCache(frameData:Frame, animation:Animation)
		{
			name = int(frameData.name);
			_frameData = frameData;
			_images = new Vector.<DisplayObject>();
			
			repeatNumber = _frameData.repeatNum;
			
			_isLoadNumber = 0;
			
			initImages(frameData, animation);
		}
		
		public function get frameData():Frame
		{
			return _frameData;
		}

		public function get images():Vector.<DisplayObject>
		{
			return _images;
		}
		
		private function initImages(frameData:Frame, animation:Animation):void
		{
			for(var i:int = 0; i < frameData.part.length; i++)
			{
				var imageData:Part = frameData.part[i];
				var imageId:String = animation.resourceIdentityList.resource[imageData.resIdentity].identity;
				
				var fileType:String = RsvFile.fileExtension(imageId);
				
				if(fileType == ResourceConst.TAIL_ICSX)
				{					
				/*	if(Rsv.inst.getFile(imageId) == null)
					{
						ResourceFactory.createRsvFile(imageId, StaticResProxy.inst.getPath(imageId));	
					}*/
					

				/*	ResHandler.loadXmlHandler(imageId, loadXmlComplete);
					
					if(_animationDatas == null)
					{
						_animationDatas = new Object();
					}
					
					_animationDatas[imageId] = imageData;*/
				}
				else
				{
					if(frameData.part.length > 1 && i != 0)
					{
						ResourceManager.getInstance().getResource(imageId).placeHolderType = PlaceholderHelper.PLACEHOLDER_TYPE_NONE;
					}
					
					initImage(imageData, imageId);
				}
				
			}			
		}
		
		/*private function loadXmlComplete(id:String):void
		{1
			var rsv:RsvFile = Rsv.inst.getFile(id);
			var xml:XML = rsv.xml;
			
			var imageClip:ImageClip = FAXB.unmarshal(xml, getQualifiedClassName(ImageClip));
			
			var res:Resource = imageClip.resourceIdentityList.resource[0];
			
			ResourceFactory.createSimpleResource(res.identity, StaticResProxy.inst.getPath(res.identity));
			
			
			if(Rsv.inst.getFile(res.identity).content == null)
			{
				Rsv.inst.getFile(res.identity).parameters = id;
				//load Image
				BackgroundLoadProxy.inst.increasePriorityToLoadingThread(res.identity, 0, loadComplete);
			}
			else
			{
				initClipImage(rsv.bitmapData, _animationDatas[id], imageClip);
			}
			
			if(_imageDatas == null)
			{
				_imageDatas = new Object();
			}
			_imageDatas[id] = imageClip;
		}*/
		
		/*private function loadComplete(rsvEvent:RsvEvent):void
		{
			if(rsvEvent.type == ""+RsvEvent.CONTENTREADY)
			{
				var rsv:RsvFile = rsvEvent.from as RsvFile;
				
				if(rsv.bitmapData != null)
				{					
					initClipImage(rsv.bitmapData, _animationDatas[rsv.parameters], _imageDatas[rsv.parameters]);
				}
				
			}
			
		}
		
		private function initClipImage(bitmapData:BitmapData, imageData:Part, imageClip:ImageClip):void
		{
			var clip:Clip;
			for each(var clipData:Clip in imageClip.clipList.clips)
			{
				if(clipData.uid == imageData.imageClipUid)
				{
					clip = clipData;
					break;
				}
			}

			var w:Number = clip.r - clip.l;
			var h:Number = clip.b - clip.t;
			
			var image:Bitmap = new Bitmap(Gutils.cutImge(bitmapData, clip.l, clip.t, w, h));
			addImage(image);
			
			image.x = imageData.posX - image.width / 2;
			image.y = imageData.posY - image.height / 2;
			
			image.scaleX = imageData.scaleX;
			image.scaleY = imageData.scaleY;
			image.alpha = imageData.alpha;
			image.rotation = imageData.rotate;
			if (imageData.flipX != 0)
			{
				image.scaleX =  -  image.scaleX;
			}
			if (imageData.flipY != 0)
			{
				image.scaleY =  -  image.scaleY;
			}
		}*/
		
		public function isLoadComplete():Boolean
		{
			return _isLoadNumber == frameData.part.length;
		}
		
		private function initImage(imageData:Part, imageId:String):void
		{
			var poistionX:Number = imageData.posX;
			var positionY:Number = imageData.posY;
			var xOff:Number = frameData.posX;
			var yOff:Number = frameData.posY;
			
			function contentReadyCallBack(bitMap:DisplayObject):void
			{
				if(bitMap.parent != null && bitMap.parent is CachePlaceholder)
				{					
					bitMap.parent.x = 0;
					bitMap.parent.y = 0;
					
					bitMap.scaleX = bitMap.parent.scaleX;
					bitMap.scaleY = bitMap.parent.scaleY;
					
					bitMap.parent.scaleX = 1;
					bitMap.parent.scaleY = 1;
					
					bitMap.x = (poistionX + xOff) * frameData.scaleX - (bitMap.width/2);
					bitMap.y = (positionY + yOff) * frameData.scaleY - (bitMap.height/2);
					
					_isLoadNumber++;
				}
			}
			
			var image:DisplayObject = ResourceManager.getInstance().getResource(imageId).getContent("1", contentReadyCallBack) as DisplayObject;
			
			if(!(image is CachePlaceholder))
			{
				_isLoadNumber++;
			}
			
			image.scaleX = imageData.scaleX;
			image.scaleY = imageData.scaleY;
			
			image.scaleX *= frameData.scaleX;
			image.scaleY *= frameData.scaleY;
			
			image.x = (poistionX + xOff) * frameData.scaleX - image.width / 2;
			image.y = (positionY + yOff) * frameData.scaleY - image.height / 2;

			image.alpha = imageData.alpha * frameData.alpha;
			image.rotation = imageData.rotate;
			
			if (imageData.flipX != 0)
			{
				image.scaleX =  -  image.scaleX;
			}
			if (imageData.flipY != 0)
			{
				image.scaleY =  -  image.scaleY;
			}
			
			
			
			
			
			addImage(image);
		}
		
		private function addImage(image:DisplayObject):void
		{
			_images.push(image);
		}
	}
}