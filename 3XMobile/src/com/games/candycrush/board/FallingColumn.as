package com.games.candycrush.board
{
	import framework.model.EmptyGrid;

    public class FallingColumn
    {
        private var _items:Vector.<Item>;
		
		/**
			order from high to low 8 --> 0
		*/
		public var emptyGrids:Vector.<EmptyGrid>;
		public var needCreateNewItemNumber:int;
		
//		private var _emptyLength:int;
//		private var _startEmptyIndex:int;

        public function FallingColumn()
        {       
            reset();
        }
		
		public function reset():void
		{
			_items = new Vector.<Item>();
			emptyGrids = new Vector.<EmptyGrid>();
		/*	_emptyLength = 0;
			_startEmptyIndex = -1;*/
		}

        public function isEmpty() : Boolean
        {
            return _items.length == 0;
        }// end function

        public function getItems() : Vector.<Item>
        {
            return this._items;
        }// end function

        public function getSize() : int
        {
            return this._items.length;
        }// end function
		
		public function isNotPushed(item:Item):Boolean
		{
			var index:int = _items.indexOf(item);
			return index < 0 ;
		}
		
        public function insertItem(item:Item) : void
        {
			if(!item.isCanMove)
			{
				if(item.getAcanMoveBasic() == null)
				{
					
					CONFIG::debug
					{
						ASSERT(false, "can not move can not be pushed to fall column!");
					}
				}
			}
			
			var index:int = _items.indexOf(item);
			if(index < 0)
			{
				CONFIG::debug
				{
					TRACE_ANIMATION_MOVE("falling Column  insert Position: " + " srcX: "+item.srcX +  " srcY: "+item.srcY + "dstx: "+ item.x +" dsty: "+ item.y );
				}
				_items.push(item);
				
			}
			else
			{
				CONFIG::debug
				{
					TRACE_LOG("try to insert falling Column  fail!  insert Position: " + "dstx: "+ item.x +" dsty: "+ item.y + " srcX: "+item.srcX +  " srcY: "+item.srcY);
				}
			}
         /*   var length:int = this._items.length;
            var index:int = length;
            while (index > 0)
            {
                
                if (item.y > this._items[(index - 1)].y)
                {
                    break;
                }
                --index;
            }
            this._items.splice(index, 0, item);*/
           //sort  y from  small to big
        }// end function

        public function getLowestInsertionPoint() : Number
        {
			if (this.isEmpty() || this._items[0].y >= 1)
			{
				return 0;
			}
			CONFIG::debug
			{
				TRACE_LOG("item0 y: "+ _items[0].y);
				ASSERT(_items[0].y > 0, "y must bigger than 0");
			}
			
			return this._items[0].y - 1;
       /*     if (this.isEmpty() || this._items[0].y >= 0.5)
            {
                return -0.51;
            }
            return this._items[0].y - 1.01;*/
        }// end function

        public function getCloseItems(startIndex:Number, length:Number) : Vector.<Item>
        {
            var items:Vector.<Item> = new Vector.<Item>;
            var index:int = 0;
            while (index < this._items.length)
            {
                
                if (Math.abs(startIndex - this._items[index].y) <= length)
                {
                    items.push(this._items[index]);
                }
                index++;
            }
            return items;
        }

        public function remove(item:Item) : void
        {
            var index:int = this._items.indexOf(item);
//            Debug.assert(_loc_2 >= 0, "Column::remove, trying to remove an item not in list: " + param1.id);
            this._items.splice(index, 1);
            return;
        }// end function

     
/*		public function get emptyLength():int
		{
			return _emptyLength;
		}

		public function set emptyLength(value:int):void
		{
			_emptyLength = value;
		}

		public function get startEmptyIndex():int
		{
			return _startEmptyIndex;
		}

		public function set startEmptyIndex(value:int):void
		{
			_startEmptyIndex = value;
		}*/

    }
}
