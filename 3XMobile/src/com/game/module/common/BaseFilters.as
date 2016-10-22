package com.game.module.common
{
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;//发光包
	
	/**
	 * @author melody
	 **/
	public class BaseFilters
	{
		public function BaseFilters()
		{
		}
		
		/**
		 * 添加投影滤镜...
		 **/
		public static function addDropShadow(distance:Number,angle:Number,color:uint,alpha:Number,blurX:Number,blurY:Number,strength:Number,inner:Boolean = false,quality:String = "high"):Array
		{
			var _quality:int;
			if(quality == "high") _quality = BitmapFilterQuality.HIGH;
			else if(quality == "low") _quality = BitmapFilterQuality.LOW;
			else _quality = BitmapFilterQuality.MEDIUM;
			var filter:BitmapFilter = BitmapFilter(new DropShadowFilter(distance,angle,color,alpha,blurX,blurY,strength,_quality,inner));
			var filterA:Array = new Array();
			filterA.push(filter);
			return filterA;
		}
		
		/**
		 * 添加外发光滤镜...
		 * low:1,middle:2,high:3
		 **/
		public static function addGlow(color:uint,alpha:Number,blurX:uint,blurY:uint,strength:Number,inner:Boolean = false,quality:int = 1):Array
		{
			var filter:BitmapFilter = BitmapFilter(new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner));
			var filterA:Array = new Array();
			filterA.push(filter);
			return filterA;
		}
		
		/**
		 * 添加模糊滤镜...
		 **/
		public static function addBlur(blurX:uint,blurY:uint):Array
		{
			var filter:BitmapFilter = BitmapFilter(new BlurFilter(blurX, blurY, BitmapFilterQuality.HIGH));
			var filterA:Array = new Array();
			filterA.push(filter);
			return filterA;
		}
	}
}