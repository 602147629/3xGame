package framework.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getQualifiedClassName;

	public class ValidateUtil
	{
		public function ValidateUtil()
		{
		}
		
		
		public static function validateDisplayObjectContainerNameDefinationAboutRootName(root:DisplayObjectContainer):void
		{
			if(root != null)
			{
				TRACE_VALIDATE("validateDisplayObjectContainerNameDefinationAboutRootName : " + getQualifiedClassName(root));
				var func:Function = function(target:DisplayObjectContainer, shouldBeRoot:Boolean, locator:String):void
				{
					var defineName:String = getQualifiedClassName(target);
					var isCorrect:Boolean = shouldBeRoot ? true : !UIUtil.isRootName(defineName, target.name);
					var childCount:int = target.numChildren;
					locator += "." + defineName;
					//					ASSERT(isCorrect, locator + " has a wrong defination or instance name!");
					if(!isCorrect)
					{
						TRACE_VALIDATE(locator + " has a wrong defination or instance name!");
					}
					
					for(var i:int = 0; i < childCount; ++i)
					{
						var child:DisplayObject = target.getChildAt(i);
						if(child is DisplayObjectContainer)
						{
							func(child, false, locator);
						}
					}
				}
				func(root, true, "");
			}
		}
		
		public static function validateDisplayObjectContainerAboutDuplicateNamedChildren(root:DisplayObjectContainer):void
		{
			if(root == null) 
				return;
			var childrenCount:int = root.numChildren;
			if(root.numChildren > 0)
			{
				//validate on this layer
				var targetList:Vector.<DisplayObject> = new Vector.<DisplayObject>;
				var target:DisplayObject;
				for( var i:int = 0; i < childrenCount; ++i)
				{
					target = root.getChildAt(i);
					if(target.name.indexOf("instance") == -1)
					{
						if(!isHaveDuplicateName(targetList, target.name))
						{
							targetList.push(target);
						}
						else
						{
							//ASSERT(false, "DisplayObject Name is Duplicated : " + getTreePathByDisplayObject(target));
							TRACE_VALIDATE("DisplayObject Name is Duplicated : " + getTreePathByDisplayObject(target));
						}
					}
				}
				//traverse children
				for each(target in targetList)
				{
					if(target is DisplayObjectContainer)
					{
						validateDisplayObjectContainerAboutDuplicateNamedChildren(target as DisplayObjectContainer);
					}
				}
			}
		}
		
		public static function getTreePathByDisplayObject(target:DisplayObject, root:DisplayObjectContainer = null):String
		{
			var path:String = "";
			while(target != root && target != null)
			{
				path = "->{ClassName : " + getQualifiedClassName(target) + " , Name : " + target.name + " }" + path;
				target = target.parent;
			}
			return path;
		}
		
		private static function isHaveDuplicateName(list:Vector.<DisplayObject>, name:String):Boolean
		{
			for each(var object:DisplayObject in list)
			{
				if(name == object.name)
				{
					return true;
				}
			}
			return false;
		}
	}
}