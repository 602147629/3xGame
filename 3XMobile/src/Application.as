package
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	
	import engine_starling.SApplicationLauch;
	import engine_starling.SApplicationLauchParams;
	import engine_starling.utils.Logger;
	import engine_starling.utils.SPlatformUtils;
	
	[SWF(width = 960, height = 640, backgroundColor = 0xFFFFFF, frameRate = 30)]
	public class Application extends Sprite
	{
		private var _lauch:SApplicationLauch;
		
		public static var as3Root:Sprite;
		
		
		public function Application()
		{
			super();
			
			as3Root = this;
			
			if(SPlatformUtils.isReleaseBuild())
			{
				Logger.enable = false;
			}
			var params:SApplicationLauchParams  = new SApplicationLauchParams();
			
			SApplicationLauch.Lauch(GameElimation,this,params);
			
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
	}
}