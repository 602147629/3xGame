package com.games.candycrush.board
{
    import __AS3__.vec.*;
    import com.games.candycrush.board.match.*;
    import com.games.candycrush.input.*;
    import com.math.*;

    public interface IBoardListener
    {
        function addItemToUI(item:Item, gridX:int, gridY:int) : void;

        function removeItemUI(param1:Item, param2:int, param3:int) : void;

        function destroyItem(param1:Item) : void;

        function switchMade(swapInfo:SwapInfo, state:int) : void;

        function addScore(param1:Number, param2:Number, param3:int, param4:int, param5:Item = null, param6:IDestructionPlan = null) : void;

        function hasMatched(param1:Match, param2:int, param3:int) : void;

        function boardStabilized(param1:int, param2:int) : void;

        function specialGridCreated(param1:int, param2:Item) : void;

        function powerupExploded(param1:int, param2:int, param3:int, param4:Item, param5:Vector.<IntCoord> = null, param6:Vector.<Item> = null) : void;

        function specialMixed(param1:int, param2:SwapInfo, param3:Vector.<Item> = null, param4:IntCoord = null) : void;

    }
}
