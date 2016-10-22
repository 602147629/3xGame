package framework.model
{
	/**
	 * @author caihua
	 * @comment 翻页数据控制类
	 * 创建时间：2014-6-10 上午10:10:10 
	 */
	
	public class ListInfo
	{
		private var _start:int = 0; //当前显示列表的第一个位置
		private var _movenum:int = 0; //item移动数量
		private var _total:int; //总数
		private var _data:Array = new Array(); //数据
		private var _numPerPage:int;
		//最后一页不足填满
		public static const MODE_KEEP_FULL:String = "keep_full";
		//最后一页不足不填满
		public static const MODE_KEEP_REMAIN:String = "keep_remain";
		private var _lastPageMode:String;
		
		private var _currentPage:int = 1;
		private var _totalPage:int = 1;
		
		public function ListInfo(numPerPage:int = 8, lastPageMode:String = MODE_KEEP_FULL)
		{
			this._lastPageMode = lastPageMode;
			this._numPerPage = numPerPage;
		}
		
		public function get __numPerPage():int
		{
			return this._numPerPage;
		}
		
		public function setCurrentPage(page:int):void
		{
			this._currentPage = page;
			var start:int = page* this._numPerPage;
			if (start >= 0 && start < this._total) 
			{
				this._start = start;
			}
		}
		
		/**
		 * 初始化列表数据
		 */
		public function setData(data:Object):void
		{
			if (data == null)
			{
				return;
			}
			var idx:int = 0;
			this._data = new Array();
			for each (var item:*in data)
			{
				this._data[idx] = item;
				idx++;
			}
			this._start = 0;
			this._total = idx;
			this._currentPage = 1;
			this._totalPage = Math.ceil(this._total/this._numPerPage);
		}
		
		/**
		 * 向上翻一个数据
		 */
		public function prevOne():void
		{
			var start:int = this._start - 1;
			if (start < 0)
			{
				start = 0;
			}
			this._movenum = start - this._start;
			this._start = start;
		}
		
		/**
		 * 向翻页数据
		 */
		public function prev():void
		{
			var start:int = this._start - this._numPerPage;
			if (start < 0)
			{
				start = 0;
			}
			this._movenum = start - this._start;
			this._start = start;
			this._currentPage = ((this._currentPage - 1 ) > 0 ? this._currentPage - 1 :  this._currentPage) ;
		}
		
		/**
		 * 向下翻一个数据
		 */
		public function nextOne():void
		{
			var start:int = this._start + 1;
			if (start > this._total - this._numPerPage)
			{
				start = this._total - this._numPerPage;
			}
			this._movenum = start - this._start;
			this._start = start;
		}
		
		/**
		 * 向下翻页数据
		 */
		public function next():void
		{
			var start:int = this._start + this._numPerPage;
			if (start > this._total - this._numPerPage)
			{
				//保持最后一页满项
				if (this._lastPageMode == MODE_KEEP_FULL) 
				{
					start = this._total - this._numPerPage;
				}
			}
			this._movenum = start - this._start;
			this._start = start;
			this._currentPage = ((this._currentPage + 1 ) > this._totalPage ? this._totalPage :  (this._currentPage + 1 )) ;
		}
		
		/**
		 * 翻到第一页
		 */
		public function head():void
		{
			var start:int = 0;
			this._movenum = start - this._start;
			this._movenum = this._movenum < -this._numPerPage ? -this._numPerPage : this._movenum;
			this._start = start;
			this._currentPage = 1;
		}
		
		/**
		 * 翻到最后一页
		 */
		public function tail():void
		{
			var num:int = Math.floor(this._total / this._numPerPage);
			var start:int = num * this._numPerPage ;
			if (start == this._total)
			{
				start = this._total - this._numPerPage;
			}
			this._movenum = start - this._start;
			this._movenum = this._movenum > this._numPerPage ? this._numPerPage : this._movenum ;
			this._start = start;
			this._currentPage = this._totalPage ;
		}
		
		/**
		 * 翻到某页
		 */
		public function turnTo(pageNum:int):void
		{
			if (pageNum >=1 && pageNum <= this._totalPage) 
			{
				this._currentPage = pageNum;
			}
			var start:int = this._numPerPage * pageNum;
			if (start > this._total - this._numPerPage)
			{
				//保持最后一页满项
				if (this._lastPageMode == MODE_KEEP_FULL) 
				{
					start = this._total - this._numPerPage;
				}
			}
			this._movenum = start - this._start;
			if (this._movenum >= 0)
			{
				this._movenum = this._movenum > this._numPerPage ? this._numPerPage : this._movenum ;
			}
			else
			{
				this._movenum = this._movenum < -this._numPerPage ? -this._numPerPage : this._movenum;
			}
			this._start = start;
		}
		
		
		/**
		 * 读取数据
		 */
		public function getCurrentPageData():Array
		{
			var list:Array = new Array();
			for (var i:int = this._start; i < this._start + this._numPerPage; i++)
			{
				if (undefined == this._data[i])
				{
					continue;
				}
				list.push(this._data[i]);
			}
			return list;
		}
		
		public function get canNextOne():Boolean
		{
			return (this._start + this._numPerPage + 1) > _total ? false : true;
		}
		
		public function get canNextPage():Boolean
		{
			return (this._start + this._numPerPage) < _total ? true : false;
		}
		
		public function canGotoPage(pageNum:int):Boolean
		{
			return (pageNum*this._numPerPage) < _total ? true : false;
		}
		
		public function get canToLast():Boolean
		{
			return this._start + this._numPerPage >= _total ? false : true;
		}
		
		public function get canPrevOne():Boolean
		{
			return this._start > 0 ? true : false;
		}
		
		public function get canPrevPage():Boolean
		{
			return this._start > 0 ? true : false;
		}
		
		public function get canToHead():Boolean
		{
			return this._start <= 0 ? false : true;
		}
		
		public function get __start():int
		{
			return this._start;
		}
		
		public function get __total():int
		{
			return this._total;
		}
		
		public function get __movenum():int
		{
			return this._movenum;
		}
		
		public function get __data():Array
		{
			return this._data;
		}
		
		public function set __start(start:int):void
		{
			this._start = start;
		}
		
		public function get currentPage():int 
		{
			return _currentPage;
		}
		
		public function get totalPage():int 
		{
			return _totalPage;
		}
	}
}