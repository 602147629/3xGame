package framework.util.backgroundloadmovieclip
{
	import framework.client.mechanic.movieclipCacher.MovieClipCacherUtility;
	import framework.model.BackgroundLoadProxy;
	import framework.resource.Resource;
	import framework.resource.ResourceManager;
	import framework.util.DisplayUtil;
	import framework.util.ResHandler;
	import framework.util.cacher.CachePlaceholder;
	import framework.util.cacher.ResCacher;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public dynamic class BackGroundLoadMovieClip extends MovieClip
	{
		private var _className:String;
		private var _useCache:Boolean;
		private var _cbComplete:Function;

		private var _tempContent:DisplayObject;
		private var _realContent:MovieClip;
		private var _loadDone:Boolean;
		
		public function BackGroundLoadMovieClip(className:String, cbComplete:Function, useCache:Boolean, loadPriority:int)
		{
			super();

			_useCache = useCache;
			_className = className;
			_cbComplete = cbComplete;
			
			var res:Resource = ResourceManager.getInstance().getResource(className);
			
			CONFIG::debug
			{
				ASSERT(res != null, className + " missing");
			}

			_tempContent = ResCacher.getVectorSwfAsset(res, null, onLoadComplete);
			
			if(res.swfClass == null && loadPriority > 0)
			{
				BackgroundLoadProxy.inst.increasePriorityToLoadingThread(res.file.pathId, loadPriority);
			}

			if(!_loadDone)
			{
				addChild(_tempContent);
			}
		}
		
		public function getRealContend():MovieClip
		{
			return _realContent;
		}
		
		protected function onLoadComplete(mc:MovieClip):void
		{
			CONFIG::debug
			{
				ASSERT(mc != null, "ASSERT");
			}
			
			_loadDone = true;
			
			if(_useCache)
			{
				_realContent = MovieClipCacherUtility.createMovieClipCacherAsynchronous(mc, _className);
			}
			else
			{
				_realContent = mc;
			}
			
			if(_tempContent != null)
			{
				DisplayUtil.replaceChild(this, _realContent, _tempContent);
				_tempContent = null;
			}
			else
			{
				this.addChild(_realContent);
			}
			
			if(_cbComplete != null)
			{
				_cbComplete(this);
				_cbComplete = null;
			}
		}
		
	}
}