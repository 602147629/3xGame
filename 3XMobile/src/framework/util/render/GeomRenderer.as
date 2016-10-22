package framework.util.render
{
	import flash.display.Graphics;
	import framework.util.geom.ConvexPolygon;
	import framework.util.geom.Grid;
	
	public class GeomRenderer
	{
		public function GeomRenderer()
		{
		}
	
		public static function drawPolygon(gfx:Graphics, poly:ConvexPolygon,
											color:uint=0, thickness:int=1, 
											xoffset:Number=0, yoffset:Number=0):void
		{
			gfx.lineStyle(thickness, color);
			
			var coords:Array = poly.getPoints();
			var len:int = coords.length;
			
			gfx.moveTo(coords[len-2]+xoffset, coords[len-1]+yoffset); 
			for(var i:int=0; i<len; i+=2)
				gfx.lineTo(coords[i]+xoffset, coords[i+1]+yoffset); 
		}
		
		public static function fillPolygon(gfx:Graphics, poly:ConvexPolygon,
											fillcolor:uint=0, xoffset:Number=0, yoffset:Number=0 ,alpha:Number=0.5):void
		{
			gfx.beginFill(fillcolor,alpha);
			drawPolygon(gfx, poly, fillcolor, 1, xoffset, yoffset);
			gfx.endFill();
		}
		
		public static function drawGrid(gfx:Graphics, grid:Grid,
										color:uint=0, thickness:int=1, includeBounds:Boolean=true):void
		{
			gfx.lineStyle(thickness, color);

			var dx:Number, dy:Number;			
			var x:Number = grid.x + grid.xoffset;
			var y:Number = grid.y; 
			
			// column lines
			dx = -grid.cell.xoffset;
			dy = grid.cell.yoffset;
			if(includeBounds)
			{
				drawParallelLines(gfx, x, y, grid.width-grid.xoffset, grid.height-grid.yoffset,
								dx, dy, grid.rowNum+1);
			}
			else
			{
				drawParallelLines(gfx, x+dx, y+dy, grid.width-grid.xoffset, grid.height-grid.yoffset,
								dx, dy, grid.rowNum-1);
			}
			
			// row lines
			dx = grid.cell.width - grid.cell.xoffset;
			dy = grid.cell.height - grid.cell.yoffset;
			if(includeBounds)
			{
				drawParallelLines(gfx, x, y, -grid.xoffset, grid.yoffset,
								dx, dy, grid.columnNum+1);
			}
			else
			{
				drawParallelLines(gfx, x+dx, y+dy, -grid.xoffset, grid.yoffset,
								dx, dy, grid.columnNum-1);
			}
		}
		
		public static function drawParallelLines(gfx:Graphics, x:Number, y:Number,
												nextXoffset:Number, nextYoffset:Number, 
												dx:Number, dy:Number, total:int):void
		{
			for(var i:int=0; i<total; i++)
			{
				gfx.moveTo(x, y);
				gfx.lineTo(x+nextXoffset, y+nextYoffset);
				x += dx;
				y += dy;
			}
		}

	}
}