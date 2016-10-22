package framework.util.rsv
{
	/**
	 * comments by Ding Ning
	 * used to organize a set of RsvObject
	 * it supply *batch* method to load them together, or something else 
	 */
	 
	
	public class RsvGroup extends RsvObject
	{
		protected var _list:Array;
		
		public function RsvGroup(id:String, autoRegist:Boolean=true)
		{
			super(id, autoRegist);
			
			_list = new Array();
		}
		
		public function add(o:Object):void
		{
			_list.push(o);
		}
		
		public function contains(o:Object):Boolean
		{
			return _list.indexOf(o) != -1;
		}
		
//		public function remove(o:Object):void
//		{
//			var i:int = _list.indexOf(o);
//			if(i >= 0)
//				_list.splice(i, 1);
//		}
		
		public function total():int
		{
			return _list.length;
		}
		
		public function all():Array
		{
			return _list;
		}
		
		public function search(attr:String, comp:Object):Array
		{
			var a:Array = new Array();
			for each(var o:Object in _list)
			{
				if(o[attr] == comp)
					a.push(o);
			}
			return a;
		}
		
		public function searchCount(attr:String, comp:Object):int
		{
			var v:int = 0;
			for each(var o:Object in _list)
			{
				if(o[attr] == comp)
					++v;
			}
			return v;
		}
		
		public function searchPercent(attr:String, comp:Object):Number
		{
			return total() == 0 ? 1 : searchCount(attr, comp) * 100 / total();
		}
		
		public static function batchCall_s(callerlist:Object, funcname:String, args:Array=null):void
		{
			for each(var o:Object in callerlist)
			{
				if(o != null)
					o[funcname].apply(o, args);
			}
		}
		
		public static function batchCallArgs_s(caller:Object, funcname:String, arglist:Object, args:Array=null):void
		{
			// alloc a place for arg oject
			if(args != null)
			{
				args = [null].concats(args);
			}	
			var func:Function = caller[funcname] as Function;
			for each(var o:Object in arglist)
			{
				if(args == null)
				{
					func.call(caller, o);
				}
				else
				{
					args[0] = o;
					func.apply(caller, args);
				}
			}
		}
		
	}
}