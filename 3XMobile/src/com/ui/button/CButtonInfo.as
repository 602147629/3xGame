package com.ui.button
{
	import flash.geom.*;
	
	/**
	 * @author caihua
	 * @comment 按钮信息描述
	 * 创建时间：2014-6-10 上午11:32:10 
	 */
	public class CButtonInfo extends Object
	{
		protected var _size:Point;
		protected var _upPos:Point;
		protected var _overPos:Point;
		protected var _downPos:Point;
		protected var _disabledPos:Point;
		protected var _selectedPos:Point;
	
		/*size - 按钮大小*/
		public function CButtonInfo(size:Point , upPos:Point , overPos:Point=null , downPos:Point=null , disabledPos:Point=null , selectedPos:Point=null)
		{
			this._size = size;
			this._upPos = upPos;
			this._overPos = overPos;
			this._downPos = downPos;
			this._disabledPos = disabledPos;
			this._selectedPos = selectedPos;
		}
		
		/**
		 *	按钮尺寸
		 */
		public function get __size():Point
		{
			return this._size;
		}
		
		/**
		 *	按钮弹起状态图片位置
		 */
		public function get __upPos():Point
		{
			return this._upPos;
		}
		
		/**
		 *	按钮鼠标滑过状态图片位置
		 */
		public function get __overPos():Point
		{
			return this._overPos;
		}
		
		/**
		 *	按钮按下状态图片位置
		 */
		public function get __downPos():Point
		{
			return this._downPos;
		}
		
		/**
		 *	按钮disabled状态图片位置
		 */
		public function get __disabledPos():Point
		{
			return this._disabledPos;
		}
		
		/**
		 *	按钮选中状态图片位置
		 */
		public function get __selectedPos():Point
		{
			return this._selectedPos;
		}
	}
}
