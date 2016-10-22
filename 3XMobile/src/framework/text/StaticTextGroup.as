package framework.text
{
	public class StaticTextGroup
	{
		private var staticKeys:Object = {};
		
		public function createStaticTextGroup(content:XML):void
		{
			var textList:XMLList = content["content"][0]["text"];
			for(var i:int = 0 ; i < textList.length() ; i ++)
			{
				var key:String = textList[i].@id.toString();
				var index:int = key.indexOf("#");
				if(index != -1) //static text
				{
					var mediatorUIName:String = key.substring(0,index);
					if(staticKeys[mediatorUIName] == null)
					{
						staticKeys[mediatorUIName] = new Vector.<String>();
					}
					staticKeys[mediatorUIName].push(key);
				}
			}
		}
		
		public function getStaticTextKeyGroup(uiName:String):Vector.<String>
		{
			return staticKeys[uiName];
		}

		public function StaticTextGroup()
		{
		}
	}
}