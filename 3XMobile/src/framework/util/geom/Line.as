package framework.util.geom
{
	public class Line
	{
		public function Line()
		{
		}
		
		public static function pointOnLine(x:int, y:int, x1:int, y1:int, x2:int, y2:int, lineCheck:Boolean=true):int
		{
			// return value
			// -1 not on line
			// 0 on line, but not between
			// 1 is the first point(x1, y1)
			// 2 is the second point(x2, y2)
			// 3 between piont1 and point2
			
			if(lineCheck && (x-x1) * (y2-y1) != (y-y1) * (x2-x1))
			{
				return -1;
			}
			if(x == x1)
			{
				return 1;
			}
			else if(x == x2)
			{
				return 2;
			}
			else
			{
				if((x-x1) * (x-x2) < 0)
					return 3;
				else
					return 0;
			}
		}
		
		public static function intersectPoint(x1:int, y1:int, x2:int, y2:int, x3:int, y3:int, x4:int, y4:int, result:Array=null):Array
		{
			if(result == null)
				result = new Array(3);
				
			// equation
			// (x-x1)/(x2-x1) = (y-y1)/(y2-y1)
			x2 = x2 - x1;
			y2 = y2 - y1;
			x4 = x4 - x3;
			y4 = y4 - y3;
			// equation changed to
			// (x-x1)/x2 = (y-y1)/y2

			var m1:int = x2 * y4;
			var m2:int = x4 * y2;
			var ymul:int = m1 - m2;
			if(ymul == 0)
			{
				if(m1 != 0)
				{
					// parallel
					result[0] = 0;
				}
				// x2 * y4 == 0, x4 * y2 == 0
				else if(x2 == 0)
				{
					if(x4 == 0)
					{
						// two lines in parallel with y-axis
						if(x1 == x3)
						{
							// overlapped
							result[0] = 2;
						}
						else
						{
							// parallel
							result[0] = 0;
						}
					}
					else	// y2 == 0
					{
						// only a point
						if(y4 * (x1-x3) == (y1-y3) * x4)
						{
							// on the line
							result[0] = 1;
							result[1] = x1;
							result[2] = y1;
						}
						else
						{
							// not on the line
							result[0] = 0;
						}
					}
				}
				else // if(y4 == 0)
				{
					if(y2 == 0)
					{
						// two lines in parallel with x-axis
						if(y1 == y3)
						{
							// overlapped
							result[0] = 2;
						}
						else
						{
							// parallel
							result[0] = 0;
						}
					}
					else	// x4 == 0
					{
						// only a point
						if(y2 * (x3-x1) == (y3-y1) * x2)
						{
							// on the line
							result[0] = 1;
							result[1] = x3;
							result[2] = y3;
						}
						else
						{
							// not on the line
							result[0] = 0;
						}
					}
				}
			}
			else
			{
				// solve the equation
				result[0] = 1;
				if(y2 != 0)
				{
					result[2] = ((x3-x1) * y2 * y4 + y1 * m1 - y3 * m2) / ymul;
					result[1] = ((result[2]-y1) * x2 + x1 * y2) / y2;
				}
				else
				{
					// here y4 can't be 0, otherwise ymul must be 0 too
					result[2] = y1;
					result[1] = ((y1 - y3) * x4 + x3 * y4) / y4;
				}
			}
			return result;
		}

	}
}