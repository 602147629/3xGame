package com.game.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import framework.util.ResHandler;
	import framework.util.rsv.Rsv;

	/**
	 * 图片工具类 
	 * 根据路径得到xml 再拿到整张图然后再根据name切图
	 * @author melody
	 */
	public class CutImage extends Bitmap
	{
		//路径
		private var _imageXmlId:String;
		//名称
		private var _name:String;
		private var _imageName:String;
		private var _xml:XML;
		public function CutImage(imageXmlId:String,name:String)
		{
			this._imageXmlId = imageXmlId;
			this._name = name;
			this.init();
		}
		private function init():void
		{
			ResHandler.loadXmlHandler(_imageXmlId, loadImg);
		}
		private function loadImg(id:String):void
		{
			//这里拿到路径了 加载图片之
			_xml = Rsv.getFile_s(id).xml;
			_imageName = _xml.resList.res[0].@identity.toString();
			
			onImgComplete(new Bitmap(Rsv.inst.getFile(_imageName).bitmapData));
		
		}
		private function onImgComplete(bitMap:DisplayObject):void
		{
			var bm:Bitmap = bitMap as Bitmap;
			var bitmapdata:BitmapData = bm.bitmapData;
			var xmlList:XMLList = _xml.data.clip.(@uid == _name);
			//得到当前要切的图片的宽 高
			var w:Number = xmlList.@r - xmlList.@l;
			var h:Number = xmlList.@b - xmlList.@t;
			this.bitmapData = Gutils.cutImge(bitmapdata,xmlList.@l,xmlList.@t,w,h);
		}
	}
}