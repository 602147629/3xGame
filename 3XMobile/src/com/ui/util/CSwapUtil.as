package com.ui.util
{
	/**
	 * @author caihua
	 * @comment 交换方向 
	 * 创建时间：2014-7-4 下午2:18:54 
	 */
	public class CSwapUtil
	{
		public static function getDirection(srcX:int, srcY:int, dstX:int, dstY:int):int
		{
			var direction:int = 0;
			
			if(srcX !=  dstX)
			{
				if(dstX < srcX)
				{
					direction = 3;
				}
				else
				{
					direction = 4;
				}
			}
			else if(srcY != dstY)
			{
				if(dstY < srcY)
				{
					direction = 1;
				}
				else
				{
					direction = 2;	
				}
			}
			
			return direction;
		}
	}
}