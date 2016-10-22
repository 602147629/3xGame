package framework.view
{
	public class ConstantLayer
	{
		public static const LAYER_CORE:String = "coreLayer";
		public static const LAYER_BOTTOM:String = "bottomLayer";
		public static const LAYER_GAME_TOP:String = "gameTop";
		
		public static const LAYER_NEW_STYLE_TOP:String = "newStyleTop";
		public static const LAYER_NEW_STYLE_EVENT_NOTIFICATION_LAYER:String = "LAYER_NEW_STYLE_EVENT_NOTIFICATION_LAYER";
		public static const LAYER_TOP_PANEL:String = "topPanelLayer";
		public static const LAYER_HINT:String = "hintLayer";
		public static const LAYER_TIPS:String = "tipsLayer";
		public static const LAYER_TUTORIAL:String = "tutorialLayer";
		public static const LAYER_REQUEST_CONFIRM:String = "LAYER_REQUEST_CONFIRM";
		public static const LAYER_BLUR:String = "blur";
		public static const LAYER_CURSOR:String = "cursor";
		
		public static const LAYER_DEFAULT:String = "no layer found!";
		
		public static const LAYERS:Vector.<UILayer> = Vector.<UILayer>([
			new UILayer(LAYER_BOTTOM, true, true, Vector.<String>([])),
			new UILayer(LAYER_CORE, false, true, Vector.<String>([
				ConstantUI.SCENE_MAIN , ConstantUI.WORLD_GAME_MAIN])),
			new UILayer(LAYER_GAME_TOP, true, true, Vector.<String>([ConstantUI.USER_INFO_PANEL, ConstantUI.PAENL_FLOWTIP_LOGO])),
			new UILayer(LAYER_TOP_PANEL, true, true, Vector.<String>([])),
			new UILayer(LAYER_HINT, false, false, Vector.<String>([])),
			new UILayer(LAYER_TIPS, false, false, Vector.<String>([
				ConstantUI.ITEM_FLOWTIP_UI_SCALE, ConstantUI.PANEL_NOTICE ])),
			new UILayer(LAYER_TUTORIAL, true, true, Vector.<String>([ConstantUI.PANEL_TUTORIAL])),
			new UILayer(LAYER_BLUR, true, true, Vector.<String>([])),
		]);
		
		public static function getLayerIndex(layerName:String):int
		{
			for(var i:int = 0; i < LAYERS.length; ++i)
			{
				if(LAYERS[i].name == layerName)
				{
					return i;
				}
			}
			return 0;
		}
		
		public static function isPanel(viewId:String):Boolean
		{
			var layerName:String = getLayerName(viewId) ;
			return layerName == LAYER_TOP_PANEL || layerName == LAYER_DEFAULT || layerName == LAYER_REQUEST_CONFIRM;
		}
		
		public static function getLayerName(viewId:String):String
		{
			for each(var layer:UILayer in LAYERS)
			{
				if(layer.containUI.indexOf(viewId) != -1)
				{
					return layer.name;
				}
			}
			
			return LAYER_DEFAULT;
		}

	}
}