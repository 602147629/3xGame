package framework.view
{
	public class UILayer
	{
		private var _name:String;
		private var _mouseEnabled:Boolean;
		private var _mouseChildren:Boolean;
		private var _containUI:Vector.<String>;
		
		public function UILayer(name:String, mouseEnabled:Boolean, mouseChildren:Boolean, containUI:Vector.<String>)
		{
			_name = name;
			_mouseEnabled = mouseEnabled;
			_mouseChildren = mouseChildren;
			_containUI = containUI;
		}

		public function get name():String
		{
			return _name;
		}

		public function get mouseEnabled():Boolean
		{
			return _mouseEnabled;
		}

		public function get mouseChildren():Boolean
		{
			return _mouseChildren;
		}

		public function get containUI():Vector.<String>
		{
			return _containUI;
		}


	}
}