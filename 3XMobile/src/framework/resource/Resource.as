package framework.resource 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.utils.getQualifiedClassName;
	
	import framework.client.mechanic.movieclipCacher.MovieClipCacherUtility;
	import framework.util.XmlUtil;
	import framework.util.cacher.CachePlaceholder;
	import framework.util.cacher.ResCacher;
	import framework.util.rsv.Rsv;
	import framework.util.rsv.RsvFile;


	/**
	 * comments by Ding Ning
	 * resource is a wrapper to resourceFile
	 * different query to access to resourceFile will have different resource, i.e.
	 * A and B want to access same resourceFile, then
	 * A will get resourceA, and B will get resourceB, alrough both resource A &amp; B point to same resourceFile
	 */


	public class Resource
	{
		protected var _id:String;
//		private var _childList:Vector.<Resource>;
		public var className:String;
		private var _isCache:Boolean;
		private var _isCacheBitmap:Boolean;

		protected var _file:ResourceFile;
		protected var _parent:Resource;
		protected var _langReady:Boolean;

		// special for swf exported class
		private var _swfClass:Class=null;
        public var ctype:String=null;
        public var needCache:Boolean=false;
		private var classType:String;
		
		public var idPrimitive:String;
		
		public var placeHolderType:int;
		
		public function get swfClass():Class
		{
			return _swfClass;
		}
		
		public function Resource()
		{

			
		}
		
		public function init(xml:XML, file:ResourceFile, parent:Resource, resId:String = null):void
		{
			
			_file = file;
			_parent = parent;
			
			//			if (parent != null)
			//			{
			//				parent.addChild(this);
			//			}
			
			if(xml != null)
			{				
				_id = XmlUtil.attrString(xml, "id");
				
				if (_id == null)
				{
					/*CONFIG::debug
					{
						ASSERT(file == null, "pointless to define id without path id:" + xml);
					}*/
					
					if(_file != null)
					{
						_id = _file.pathId;
					}
					else
					{
						_id = xml.name();
					}
					
				}
				
				className = getPropString(xml, "class");
				
				if(className == null)
				{
					className = getPropString(xml, "className");
				}
				
	 			classType = getPropString(xml, "classType", "MovieClip", true);
				
				_isCache = getPropString(xml, "isCache", "false") == "true";
				_isCacheBitmap = getPropString(xml, "isCacheBitmap", "false") == "true";
				
				idPrimitive = XmlUtil.attrString(xml, "idPrimitive");
				if(idPrimitive == "AUTO")
				{
					idPrimitive = _id + "_primitive";
				}
				
			}
			else
			{
				_id = resId;
				
				//todo hide placeholder;
				//idPrimitive = RsvFile.getFileName(_id) + "_thumb.jpg"; 
			}
			
			if(_file != null)
			{
				var rsvFile:RsvFile = Rsv.getFile_s(_file.pathId);
				CONFIG::debug
				{
					ASSERT(rsvFile != null, "can't find path define " + _file.pathId);
				}
				_file.fileType = ResourceFile.getFileType(rsvFile.extension);
			}
			
			initData();
		}
		
		
/*		protected function addChild(child:Resource):void
		{
			if (_childList == null)
			{
				_childList = new Vector.<Resource>;
			}
			_childList.push(child);
		}
*/
		
		// called by ResourceManager
		public function initData():void 
		{
			if (_file == null)
			{
				return;
			}

			// default
//			_swfClass = null;

			if (_file.fileType == ResourceFile.FILETYPE_SWF) 
			{
				ctype = classType;
			}
		}
		
		public function notifyResReady():void
		{
			
			if (_file == null)
			{
				return;
			}

			// default
			_swfClass = null;

			if (_file.fileType == ResourceFile.FILETYPE_SWF)
			{
				if (className != null)
				{
					try
					{
						_swfClass = _file.swfLib.getDefinition(className) as Class;
					}
					catch(e:Error)
					{
						if(_file.pathId.indexOf("file_sound") < 0)
						{
							ASSERT(false, className + " not found !");
						}
						else
						{
							/*TRACE_SOUND_ERROR("sound class " + className + " not found !");*/
						}
					}

				}
			}
		}
		
		public function getLoadType():String
		{
			if(_file != null)
			{
				var rsv:RsvFile = Rsv.getFile_s(_file.pathId);
				if(rsv != null)
				{
					return rsv.getLoadType(); 
				}
			}
			
			return null;
		}

		public function notifyLangChange():void
		{
			_langReady = true;
		}

		public function getClass(clsname:String):Class
		{
			return _file.swfLib.getDefinition(clsname) as Class;
		}

		public function getPropNumber(xml:XML, name:String, defaultValue:Number = 0, recursive:Boolean = false):Number
		{
			return XmlUtil.attrNumber(xml, name, defaultValue, recursive);
		}

		public function getPropString(xml:XML, name:String, defaultValue:String = null, recursive:Boolean = false):String
		{
			return XmlUtil.attrString(xml, name, defaultValue, recursive);
		}


		public function getContent(frame:String="1", cbReady:Function=null, isMapTile:Boolean = false):Object 
		{
			
			if (_file == null)
			{
				return null;
			}

			if (_file.fileType == ResourceFile.FILETYPE_BITMAP) 
			{
				var bitMap:DisplayObject = ResCacher.getVectorBitMapAsset(this, cbReady, isMapTile);
				
				return bitMap;
			} 
			else if (_file.fileType == ResourceFile.FILETYPE_SWF)
			{
				if (ctype == "MovieClip") 
				{
					if(needCache && true)
					{
						var sh:DisplayObject = ResCacher.getCachedAssets(this, 1, "1", cbReady, false, true);
						return (sh as CachePlaceholder).content as MovieClip;
					}
					else
					{
						var mc:DisplayObject = ResCacher.getVectorSwfAsset(this, "1",cbReady);
						if(_isCache)
						{				
							mc.cacheAsBitmap = true;
						}
						else if(_isCacheBitmap)
						{
							mc = MovieClipCacherUtility.createMovieClipCacherSynchronous(mc as MovieClip, _id);
							(mc as MovieClip).gotoAndPlay(1);
						}
						return mc;
					}
				} 
				else if(ctype == "mp3")
				{
                    var sound:Sound = new swfClass();
                    return sound;
				}
				else if(ctype == "BitmapData")
				{
					var bitmapData:BitmapData = new swfClass(0,0) as BitmapData;
					return bitmapData;
				}
				else
				{
					return _file.content;
				}
			} 
			else 
			{
				return _file.content;
			}
		}

//		public function getStaticContent(frame:String=null) : Object
//		{
//			if(_staticContent == null)
//			{
//				_staticContent = getContent(frame);
//			}
//			return _staticContent;
//		}

		public function getThumbnail(w:Number=-1, h:Number=-1, frame:String="1",noNeedRefresh:Boolean = false):DisplayObject
		{
			var loadCompleteCallBack:Function = function(displayObject:DisplayObject):void
			{
				if(displayObject.parent != null && displayObject.parent is CachePlaceholder)
				{					
					displayObject.parent.x = 0;
					displayObject.parent.y = 0;
					displayObject.parent.scaleX = 1;
					displayObject.parent.scaleY = 1;
					
					createThumbnailFromSpaceholder(w, h, frame, noNeedRefresh, displayObject);
				}
			};

			var obj:Object = getContent(frame, loadCompleteCallBack);
			
			if(obj is CachePlaceholder || obj is Bitmap)
			{
				return createThumbnailFromSpaceholder(w, h, frame, noNeedRefresh, obj as DisplayObject);
			}
			else if(obj is MovieClip)
			{
				return obj as Sprite;
			}
			else if(obj is Sprite)
			{
				return obj as Sprite;
			}
			else
			{
				CONFIG::debug
				{
					ASSERT(false, "class: " + getQualifiedClassName(obj));
				}
				return null;
			}
		}

		
		protected function createThumbnailFromSpaceholder(width:Number, height:Number, frame:String, noNeedRefresh:Boolean, dspo:DisplayObject):DisplayObject
		{
			return getSizeImage(width, height, dspo);
		}
		
		public static function getSizeImage(width:Number, height:Number, dspo:DisplayObject):DisplayObject
		{
			if(width != -1 || height != -1)
			{
				var scale:Number = 1;
				
				if(dspo.width != 0 && dspo.height != 0)
				{
					scale = Math.max(width / dspo.width, height / dspo.height);
				}
				
				//for cache movieClip
				/*	if(scale != 1)
				{
				dspo = getContent(frame, scale, null, noNeedRefresh) as DisplayObject;
				}*/
				
				dspo.scaleX = scale;
				dspo.scaleY = scale;
				
				var bounds:Rectangle = dspo.getBounds(null);
				dspo.x -= bounds.x * scale;
				dspo.y -= bounds.y * scale;
				
				dspo.x += (width - dspo.width) / 2;
				dspo.y += (height - dspo.height) / 2;
			}
			
			//			CommandMakeCachedHolderIdle.execute(dspo, this);
			return dspo;
		}

		public function get id():String
		{
			return _id;
		}
		
		public function get file():ResourceFile
		{
			return _file;
		}
	}
}
