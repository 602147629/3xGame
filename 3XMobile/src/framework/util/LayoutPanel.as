package framework.util
{
	import flash.display.MovieClip;

	public class LayoutPanel
	{
		private var m_mc:MovieClip;
		private var m_children:Vector.<MovieClip>;
		private var m_maxColumn:int;
		private var m_width:Number;
		private var m_height:Number;
		
		private var m_rowGapWidth:Number;
		private var m_columnGapHeight:Number;
		private var m_row:int;
		private var m_column:int;
		
		public function LayoutPanel(mc:MovieClip, maxColumn:int)
		{
			m_mc = mc;
			m_width = m_mc.width;
			m_height = m_mc.height;
			m_maxColumn = maxColumn;
		}
		
		public function setMaxColumn(max:int):void
		{
			m_maxColumn = max;
		}
		
		public function setChildren(array:Vector.<MovieClip>):void
		{
			m_children = array;
			initLayout();
			addChildren();
		}
		
		private function initLayout():void
		{
			var width:Number = m_children[0].width;
			var height:Number = m_children[0].height;
			m_row = Math.ceil(m_children.length / m_maxColumn);
			m_columnGapHeight = (m_height - m_row * height) / (m_row + 1);
			var total:int = m_children.length;
			while(total % m_row != 0)
			{
				++total;
			}
			m_column = total / m_row;
			m_rowGapWidth = (m_width - m_column * width) / (m_column + 1);
		}
		
		private function addChildren():void
		{
			var width:Number = m_children[0].width;
			var height:Number = m_children[0].height;
			DisplayUtil.removeAllChildren(m_mc);
			var y:Number = m_columnGapHeight;
			var x:Number = m_rowGapWidth;
			for(var i:int = 0, count:int = 0; i < m_children.length; ++i, ++count)
			{
				if(count == m_column)
				{
					x = m_rowGapWidth;
					count = 0;
					y += m_columnGapHeight + height;
				}
				m_mc.addChild(m_children[i]);
				m_children[i].x = x + width / 2;
				m_children[i].y = y + height / 2;
				x += width + m_rowGapWidth;
			}
		}
		
		public function getMCChildren():Vector.<MovieClip>
		{
			return m_children;
		}
	}
}