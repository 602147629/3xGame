package framework.model
{

	public class Enum
	{
		private static var em_enumMap:Object = new Object();
		
		private var em_name:String;
		private var em_ordinal:uint;
		
		protected var isInit:Boolean;
		
		public function Enum(name:String)
		{
			if(name != null)
			{
				em_name = name;
				var list:Vector.<Enum> = em_enumMap[em_name];
				if(!list)
				{
					list = new Vector.<Enum>();
					em_enumMap[em_name] = list;
				}
				em_ordinal = list.length;
				list.push(this);
			}
		}
		
		public function ordinal():uint
		{
			return em_ordinal;			
		}
		
		public static function values(name:String):Vector.<Enum>
		{
			return em_enumMap[name];
		}
	}
}