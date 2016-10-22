package framework.util
{
	import flash.display.MovieClip;

	public dynamic class Placeholder extends MovieClip
	{
//		public var _z_value:Number=0;

		public function Placeholder()
		{
			super();
			graphics.beginFill(0xFF0000)
			graphics.drawCircle(0,0,10);
			graphics.endFill();
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.visible =false;
		}
		
	}
}