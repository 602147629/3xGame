package com.ui.util
{
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;

	/**
	 * @author caihua
	 * @comment 滤镜类
	 * 创建时间：2014-7-24 下午1:46:26 
	 */
	public class CFilterUtil
	{
		public function CFilterUtil()
		{
			throw new Error("FilterUtils can not be Instantiated!");
		}
		
		/**
		 * 变灰滤镜 
		 * @return 
		 * 
		 */		
		public static function get grayFilter() : ColorMatrixFilter
		{
			return new ColorMatrixFilter( [ 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0 ] );
		}
		
		/**
		 *  
		 * @return 
		 * 
		 */		
		public static function get soulFilter() : ColorMatrixFilter
		{
			return new ColorMatrixFilter( [ 0.3086, 0.2, 0.082, 0, 0, 0.3086, 0.2, 0.082, 0, 0, 0.3086, 0.2, 0.082, 0, 0, 0, 0, 0, 1, 0 ] );
		}
		
		/**
		 * 内发光滤镜 
		 * @return 
		 * 
		 */		
		public static function get innerGlowFilter() : GlowFilter 
		{
			return new GlowFilter( 0xff00, 1.0, 4, 4, 4, 1,  true );
		}
		
		/**
		 * 发光滤镜 
		 * @return 
		 */		
		public static function get glowFilter() : GlowFilter 
		{
			return new GlowFilter( 0xff00, 1.0, 4, 4, 4, 1, false );
		}
		
		/**
		 * 描边
		 * @return 
		 */		
		public static function get glowFilter2() : GlowFilter 
		{
			return new GlowFilter(0x000000,1,2,2,20);
		}
		
		/**
		 * 文本发光滤镜 
		 * @return 
		 */		
		public static function getTextGlowFilter(color:int = 0x8f0600) : GlowFilter
		{
			return new GlowFilter( color, 1,2,2,20);
		}
		
		/**
		 * 模糊滤镜 
		 * @return 
		 */		
		public static function get blurFilter() : BlurFilter		
		{
			return new BlurFilter( 3, 3, 1 );
		}
		
		/**
		 * 斜角滤镜 
		 * @return 
		 */		
		public static function get bevelFilter() : BevelFilter
		{
			return new BevelFilter( 1, 45, 0xf0f0f0, 1.0, 0x808080, 1.0, 2, 2, 2, 2, BitmapFilterType.INNER );
		}
	}
}