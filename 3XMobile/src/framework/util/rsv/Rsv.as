package framework.util.rsv
{
	import framework.util.map.Map;
	
	import flash.display.MovieClip;
	
	
	/**
	 * comments by Ding Ning
	 * it is just a pool to save key - RsvObject pair
	 * pairs been registered in the CONSTRUCTION of RsvObject
	 * each RsvObject can be
	 * - RsvFile, each one is corresponding to a single file
	 * - RsvGroup, each one is a logic file group
	 */
	
	public class Rsv
	{
		protected static var _inst:Rsv;
		
		protected var _idmap:Map;
		
		public function Rsv()
		{
			_idmap = new Map();
		}
		
		public static function get inst():Rsv
		{
			if(_inst == null)
				_inst = new Rsv();
			return _inst;
		}
		
		public static function add_s(id:String, o:Object):Object
		{
			return inst.add(id, o);
		}
		
		public static function addow_s(id:String, o:Object):Object
		{
			return inst.addow(id, o);
		}
		
		public static function geto_s(id:String):Object
		{
			return inst.geto(id);
		}
		
		public static function remove_s(id:String, call:String=null):Object
		{
			return inst.remove(id, call);
		}
		
		public static function getFile_s(id:String):RsvFile
		{
			return inst.getFile(id);
		}
		
/*		public static function getDefinitionMc_s(fid:String, name:String):MovieClip
		{
			var rf:RsvFile = getFile_s(fid);
			return rf != null ? rf.getDefinitionMc(name) : null;
		}
*/
		
		public static function getGroup_s(id:String):RsvGroup
		{
			return inst.getGroup(id);
		}
				
		public function add(id:String, o:Object):Object
		{				
			_idmap.push(id, o)
			return o;
		}
		
		public function addow(id:String, o:Object):Object
		{
			if(_idmap.contains(id))
				remove(id, "destroy");	// auto destroy
				
			return add(id, o);
		}
		
		public function remove(id:String, call:String=null):Object
		{
			var o:Object = _idmap.pop(id);
			if(o != null && call != null && o.hasOwnProperty(call))
				o[call]();
			return o;
		}
		
		public function geto(id:String):Object
		{
			return _idmap.getValue(id);	
		}
		
		public function getFile(id:String):RsvFile
		{
			return geto(id) as RsvFile;
		}
		
		public function getGroup(id:String):RsvGroup
		{
			return geto(id) as RsvGroup;
		}
		
		//
		
		private static const DONT_FREE_XML_UNTIL_GAME_LOADED:Vector.<String> = Vector.<String>([
		]);
		
		private static const DONT_FREE_XML_EVEN_GAME_LOADED:Vector.<String> = Vector.<String>([
		]);
		
		public static function releaseXmlOnceResLoaded(rsvFile:RsvFile):void
		{
			if(rsvFile.xml != null &&
				DONT_FREE_XML_UNTIL_GAME_LOADED.indexOf(rsvFile.id) < 0)
			{
				rsvFile.destroy();
			}
		}
		
		public static function releaseAllXmlData():void
		{
			var files:Vector.<Object> = inst._idmap.getValues();
			for each(var file:Object in files)
			{
				if(file is RsvFile)
				{
					var rsvFile:RsvFile = file as RsvFile;
					if(rsvFile.xml != null &&
						DONT_FREE_XML_EVEN_GAME_LOADED.indexOf(rsvFile.id) == -1)
					{
						rsvFile.destroy();
					}
				}
			}
		}
		


	}
}