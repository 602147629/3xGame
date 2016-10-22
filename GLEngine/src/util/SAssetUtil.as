package util
{
//	import flash.display.Bitmap;
//	import flash.display.BitmapData;
//	import flash.display.MovieClip;
//	import flash.geom.Matrix;
//	import flash.geom.Point;
//	import flash.geom.Rectangle;
//	import flash.utils.getDefinitionByName;
//	
//	import starling.utils.AssetManager;
//	
	public class SAssetUtil{}
//	{
//		/**
//		 * TexturePacker中选择none模式，即不裁剪透明区域
//		 * @default
//		 */
//		public static const DRAW_NONE : String = "none";
//		/**
//		 * TexturePacker中选择trim模式，即将每一帧的透明区域剪裁掉
//		 * @default
//		 */
//		public static const DRAW_TRIM : String = "trim";
//		
//		private var _assets : AssetManager = new AssetManager();
//		
//		/**
//		 * 准备可缩放的位图
//		 * @param name      名称
//		 * @param atlasXML  Starling描述文件
//		 * @param scale     缩放系数，可以是小数
//		 * @drawMode        trim占用的空间更小，none更整齐
//		 * @return
//		 */
//		public function prepare(name : String, atlasXML : XML, scale : Number = 1, drawMode = "trim") : Bitmap
//		{
//			var xmlParser : AtlasXMLParser = new AtlasXMLParser(atlasXML);
//			
//			var scaleXML : XML = xmlParser.getScaleXML(scale);
//			
//			var linkNames : Array = xmlParser.getLinks();
//			
//			// 准备一块大位图
//			var bd : BitmapData = new BitmapData(xmlParser.getMaxWidth(scaleXML), xmlParser.getMaxHeight(scaleXML), true, 0x00000000);
//			var bitmap : Bitmap = new Bitmap(bd);
//			
//			// 原始MovieClip
//			var _oMovie : flash.display.MovieClip;
//			for each (var aLinkName : String in linkNames)
//			{
//				_oMovie = new (getDefinitionByName(aLinkName) as Class) as flash.display.MovieClip;
//				_oMovie.scaleX = _oMovie.scaleY = scale;
//				
//				drawMovieClipToBitmapData(_oMovie, bd, scaleXML, aLinkName);
//			}
//			
//			
//			// 如果sd卡有缓存，从sd卡读取
//			
//			addTextureAtlasFromBitmapData(name, bd, scaleXML);
//			
//			// 将bitmap写入文件系统
//			// bitmap
//			
//			/**
//			 *
//			 * @param _oMovie   原始MovieClip
//			 * @param bd        一张很大的位图
//			 * @param scaleXML  位图对应的描述XML
//			 * @param linkName  链接名
//			 */
//			function drawMovieClipToBitmapData(_oMovie : flash.display.MovieClip, bd : BitmapData, scaleXML : XML, linkName : String) : void
//			{
//				// 将动画放大指定倍数,并绘制到到BitmapData
//				var frameLen : int = _oMovie.totalFrames;
//				var line : XMLList;
//				var bounds : Rectangle;
//				var sBounds : Rectangle;
//				
//				var matrix : Matrix
//				var lineName : String;
//				
//				// 每一帧的小图
//				var sbd : BitmapData;
//				
//				for (var i : int = 0; i < frameLen; i++)
//				{
//					_oMovie.gotoAndStop(i + 1);
//					
//					lineName = linkName + StringUtil.uniformNumber(i + 1, 4);
//					line = xmlParser.getAtalsXMLLine(scaleXML, lineName);
//					bounds = _oMovie.getBounds(_oMovie);
//					matrix = _oMovie.transform.matrix;
//					
//					// 绘制单帧
//					if (drawMode == DRAW_TRIM)
//					{
//						matrix.tx = -bounds.x * scale;
//						matrix.ty = -bounds.y * scale;
//						sbd = new BitmapData(bounds.width * scale, bounds.height * scale, true, 0x00000000);
//						sbd.draw(_oMovie, matrix);
//						sBounds = sbd.getColorBoundsRect(0xffffffff, 0x00000000, true);
//						bd.copyPixels(sbd, new Rectangle(-sBounds.x, -sBounds.y, sBounds.width, sBounds.height), new Point(Number(line.
//							attribute("x")), Number(line.attribute("y"))));
//					}
//					else if (drawMode == DRAW_NONE)
//					{
//						matrix.tx = -bounds.x * scale + Number(line.attribute("x"));
//						matrix.ty = -bounds.y * scale + Number(line.attribute("y"));
//						bd.draw(_oMovie, matrix);
//					}
//					else
//					{
//					}
//				}
//			} // end drawMovieClipToBitmapData
//			
//			return bitmap;
//		}
//	}
//}
//
//
//
//
///**
// * XML处理器
// * @author peng
// */
//class AtlasXMLParser
//{
//	private var bodder : Number = 2;
//	
//	private var _xml : XML;
//	
//	public function AtlasXMLParser(atlasXML : XML)
//	{
//		_xml = atlasXML;
//	}
//	
//	public function getMaxHeight(scaleXML : XML) : Number
//	{
//		var max : Number = 0;
//		for each (var element : XML in scaleXML.elements())
//		{
//			max = Math.max(Number(element.attribute("y")) + Number(element.attribute("height")), max);
//		}
//		return max + bodder;
//	}
//	
//	public function getMaxWidth(scaleXML : XML) : Number
//	{
//		var max : Number = 0;
//		for each (var element : XML in scaleXML.elements())
//		{
//			max = Math.max(Number(element.attribute("x")) + Number(element.attribute("width")), max);
//		}
//		return max + bodder;
//	}
//	
//	/**
//	 * 获得xml内定义的链接名
//	 * 规范：链接名中不能包含数字
//	 * @param atlasXML
//	 * @return
//	 */
//	public function getLinks() : Array
//	{
//		var ret : Array = [];
//		var tmpName : String;
//		var nameSet : Set = new Set();
//		for each (var element : XML in _xml.elements())
//		{
//			tmpName = element.attribute("name");
//			tmpName = tmpName.replace(/\d*/gi, "");
//			nameSet.set(tmpName);
//		}
//		
//		return nameSet.toArray();
//	}
//	
//	/**
//	 *
//	 * @param xml   位图描述xml
//	 * @param name  SubTexture行的名字
//	 * @return
//	 */
//	public function getAtalsXMLLine(scaleXML : XML, name : String) : XMLList
//	{
//		return scaleXML.SubTexture.(@name == name);
//	}
//	
//	/**
//	 * 将输入的XML放大指定倍数
//	 * @param ratio
//	 * @return 返回指定放大倍数的XML
//	 */
//	public function getScaleXML(ratio : Number) : XML
//	{
//		var ret : XML = <TextureAtlas/>;
//		
//		var line : XML;
//		for each (var element : XML in _xml.elements())
//		{
//			line = <SubTexture/>;
//			line.@name = element.attribute("name");
//			line.@x = element.attribute("x") * ratio;
//			line.@y = element.attribute("y") * ratio;
//			line.@width = element.attribute("width") * ratio;
//			line.@height = element.attribute("height") * ratio;
//			line.@frameX = element.attribute("frameX") * ratio;
//			line.@frameY = element.attribute("frameY") * ratio;
//			line.@frameWidth = element.attribute("frameWidth") * ratio;
//			line.@frameHeight = element.attribute("frameHeight") * ratio;
//			ret.appendChild(line);
//		}
//		
//		return ret;
//	}
}

