package framework.util.geom
{
	public class Rhombus extends Parallelogram
	{
		public function Rhombus(width:Number=0, height:Number=0)
		{
			super(width, height, width>>1, height>>1);
		}
		
	}
}