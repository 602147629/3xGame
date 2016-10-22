package framework.resource
{
	import framework.sound.StaticSoundConfig;
	import framework.util.XmlUtil;

	public class MyFactory extends ResourceFactory
	{
		
		public static const LANG_ROOT_NODE_NAME:String = "contents";
		
		public function MyFactory()
		{
			super();
		}

		override public function isResourceNode(xml:XML):Boolean
		{
			return super.isResourceNode(xml);
		}

		public override function createResource(xml:XML, parent:Resource, rm:ResourceManager):Resource
		{
			var fileId:String = XmlUtil.attrString(xml, "path");
			var filePath:String = XmlUtil.attrString(xml, "class");
			
			if(fileId == null)
			{
				var pathId:String = XmlUtil.attrString(xml, "identity");
				fileId = pathId;
				filePath = pathId;
			}
		/*	else if(filePath == null)
			{
				fileId = XmlUtil.attrString(xml, "key");
				filePath = "./server/"+XmlUtil.attrString(xml, "path");
			}*/
				
			
//			CONFIG::debug
//			{
//				TRACE_LOG("create resource:" + fileId + "/" + filePath);
//			}

			var file:ResourceFile = getResourceFile(fileId, filePath, rm);
			
			var type:String = XmlUtil.attrString(xml, "restype", null, true);
			if (type == null)
			{
				type = xml.name();
			}
			
			var res:Resource;
			switch(type)
			{
				case "gameinfo":
					res = new GameInfo();
					break;
				case "ui":
					res = new GameResource();
					break;
				case "world":
					res = new Resource();
					break;
				case "res":
					res = new Resource();
					break;
				case "sound_config":
					res = new StaticSoundConfig();
					break;
				default:
					res = new Resource();
					break;
			
			}
			
			res.init(xml, file, parent);
			
			return res;
		}
	}
}


