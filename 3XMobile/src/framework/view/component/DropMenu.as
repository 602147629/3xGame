package framework.view.component
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import framework.util.DisplayUtil;
	import framework.view.mediator.pack.ClickItemSingleMenu;
	import framework.view.mediator.pack.ItemBackGround;

	public class DropMenu extends Sprite
	{
		private var _menuBg:ItemBackGround;
		
		private const SPACE:int = 10;
		private const SPACEHEIGHT:int = 3;
		public var currentTarget:MovieClip;
		private static var _instance:DropMenu;
		
		public var list:Vector.<ClickItemSingleMenu>;
		
		
		public function DropMenu()
		{
			init();
		}
		
		public static function getInstance():DropMenu
		{
			if(_instance == null)
			{
				_instance = new DropMenu();
			}
			return _instance;
		}
		
		private function init():void
		{
			list = new Vector.<ClickItemSingleMenu>;
		}
		
		public function push(label:String,data:*,clickHandle:Function):void
		{
			var option:ClickItemSingleMenu  = new ClickItemSingleMenu(label);
			option.data = data;
			option.clickHandle = clickHandle;
			option.addEventListener(ClickItemSingleMenu.CLICK_MENU,onClick);
			var content:Sprite = new Sprite();
			this.addChild(content);
			content.x = SPACE;
			content.y = SPACE>>1;
			
			option.y = this.height;
			content.addChild(option);
			list.push(option);
		}
		
		private function onClick(e:Event):void
		{
			if(e.target.data)
			{
				trace("@!#^%$#^$(&*^(*^&%$%^#$%@#@%$@%$&%$&^%(*&^*&%!!%&^^*(^(%$#");
				(e.target as ClickItemSingleMenu).clickHandle(e);
			}
		}
		
		public function setBackGround():void
		{
			if(_menuBg)
			{
				_menuBg.removeSelf();
			}
			_menuBg = new ItemBackGround(this.width,this.height);
			this.addChildAt(_menuBg,0);
		}
		
		public function clear():void
		{
			for each(var option:ClickItemSingleMenu in list)
			{
				if(option.hasEventListener(ClickItemSingleMenu.CLICK_MENU))
				{
					option.removeEventListener(ClickItemSingleMenu.CLICK_MENU,onClick);
				}
			}
			DisplayUtil.removeAllChildren(this);
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}
}