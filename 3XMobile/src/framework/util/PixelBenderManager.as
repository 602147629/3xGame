package framework.util
{
	import framework.core.game.sys_map.MapObject;
	import framework.core.game.sys_map.mapObjects.MapObjectHouse;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shader;
	import flash.filters.ShaderFilter;

	public class PixelBenderManager
	{
		
//		[Embed(source="../pbj/rc_filter.pbj", mimeType="application/octet-stream")]
//		public var RC_Filter:Class;
//		[Embed(source="../pbj/ri_filter.pbj", mimeType="application/octet-stream")]
//		public var RI_Filter:Class;
//		[Embed(source="../pbj/ci_filter.pbj", mimeType="application/octet-stream")]
//		public var CI_Filter:Class;
		

		[Embed(source="../pbj/pb_grayBuildingWhenDying.pbj", mimeType="application/octet-stream")]
		public var pb_grayBuildingWhenDying:Class;

		[Embed(source="../pbj/roadIndicator.pbj", mimeType="application/octet-stream")]
		public var pb_roadIndicator:Class;


		
//		public static const F_T_RC:String = "RC";
//		public static const F_T_RI:String = "RI";
//		public static const F_T_CI:String = "CI";
		
		private static var _inst:PixelBenderManager = null;
		public static function get inst():PixelBenderManager
		{
			if(_inst == null) 
				_inst = new PixelBenderManager();
			return _inst;
		}
		
		private var shaderFilterDic:Object=new Object();
		public function PixelBenderManager()
		{
		}
		
		
		/**
		 * 
		 * @param mc
		 * @param filterType (possible value : MapPanel.EFFECT_MODE_RC etc)
		 * 
		 */		
		public function getFilterWithParam(filterType:int,params:Array=null):ShaderFilter
		{
			var bender:Array=getFilter(filterType);
			var shader:Shader=bender[0];
			var filter:ShaderFilter=bender[1];
			if(params)
			{
				for(var i:int=0; i<params.length; i+=2)
				{
					var k:String=params[i+0];
					var v:Number=params[i+1];
					shader.data[k].value=[v];
				}
				
			}
			return filter;
		}
		
		private function getFilter(filterType:int):Array
		{
			if(shaderFilterDic[filterType] == null)
			{
				var cls:Class = getFilterClass(filterType);
				ASSERT(cls!=null);
				var shader:Shader = new Shader(new cls());
				var filter:ShaderFilter = new ShaderFilter(shader);
				shaderFilterDic[filterType] = [shader, filter];
			}
			return shaderFilterDic[filterType];
		}
		
		//
		public static const GRAY_BUILDING_WHEN_DYING:int=0;
		public static const DARK_FIELD_FAR2ROAD:int=1;
		private function getFilterClass(filterType:int):Class
		{
			switch(filterType)
			{
				case GRAY_BUILDING_WHEN_DYING:		return pb_grayBuildingWhenDying;
				case DARK_FIELD_FAR2ROAD:			return pb_roadIndicator;
			}
			return null;
		}
	}
}

