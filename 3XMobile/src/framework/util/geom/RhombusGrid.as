package framework.util.geom
{	
	public class RhombusGrid extends Grid
	{
		public function RhombusGrid(seed:Rhombus=null, column:int=1, row:int=1)
		{
			super(seed, column, row);
		}	
		
		public override function containsTileCellXY(xx:int,yy:int):Boolean
		{
			if(xx < cellX || xx >= cellX + columnNum || yy < cellY || yy >= cellY + rowNum)
			{
				return false;
			}
			
			return true;
		}
		
		public override function setPosCell(cx:int, cy:int, parent:Grid):void
		{
			cellX = cx;
			cellY = cy;
			x = parent.xoffset + (cx - cy) * cell.xoffset - this.xoffset;
			y = (cx + cy) * cell.yoffset;
		}
	}
}