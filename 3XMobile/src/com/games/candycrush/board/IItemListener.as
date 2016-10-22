package com.games.candycrush.board
{

    public interface IItemListener
    {
        function beginMove(item:Item, dstX:int, dstY:int, moveComplete:Function) : void;

        function bounced(param1:Boolean) : void;

    }
}
