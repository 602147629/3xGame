package com.midasplayer.engine.tick
{

    public interface ITickerHook
    {

        public function ITickerHook();

        function preTick(param1:int) : void;

        function postTick(param1:int) : void;

    }
}
