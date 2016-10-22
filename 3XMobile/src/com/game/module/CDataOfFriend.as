package com.game.module
{
	import com.netease.protobuf.UInt64;

	/**
	 * @author caihua
	 * @comment 单个好友
	 * 创建时间：2014-7-4 下午4:35:16 
	 */
	public class CDataOfFriend extends CDataBase
	{
		private var _fid:UInt64;
		private var _icon:String = "";
		private var _name:String =  "";
		private var _score:Number = 0 ;
		
		public function CDataOfFriend(fid:UInt64 = null)
		{
			if(fid)
			{
				_fid = fid;
			}
			super("CDataOfFriend");
		}

		public function get icon():String
		{
			return _icon;
		}

		public function set icon(value:String):void
		{
			_icon = value;
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get score():Number
		{
			return _score;
		}

		public function set score(value:Number):void
		{
			_score = value;
		}

		public function get fid():UInt64
		{
			return _fid;
		}

		public function set fid(value:UInt64):void
		{
			_fid = value;
		}
	}
}