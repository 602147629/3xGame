package framework.resource
{
	import framework.util.XmlUtil;

	public class ResourceNodeInfo
	{
		private var resourceManager:ResourceManager;
		
		public var xml:XML;
		public var parent:Resource;
		public var resource:Resource;
		
		public function ResourceNodeInfo(resourceManager:ResourceManager)
		{
			this.resourceManager = resourceManager;
		}
		
		internal function createResource():void
		{
			var resId:String = getResourceId(xml);
			if(resourceManager.resMap[resId] != null)
			{
				resource = resourceManager.resMap[resId];
				return;
			}
			resource = resourceManager._factory.createResource(xml, parent, resourceManager);
			CONFIG::debug
			{
				ASSERT(resource != null, "can't create resource from this xml node = \n" + xml.toString());
			}

			resourceManager.validationUniqueResId(resource, xml);
			resourceManager.resMap[resource.id] = resource;

		}
		
		private function getResourceId(xml:XML):String
		{
			var id:String = XmlUtil.attrString(xml, "id");
			var pathId:String = XmlUtil.attrString(xml, "identity");
			
			if (id == null)
			{
				/*CONFIG::debug
				{
				ASSERT(file == null, "pointless to define id without path id:" + xml);
				}*/
				
				if(pathId != null)
				{
					id = pathId;
				}
				else
				{
					id = xml.name();
				}
				
			}
			
			return id;
		}
		
	}
}