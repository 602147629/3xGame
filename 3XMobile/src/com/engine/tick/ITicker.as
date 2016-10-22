package com.midasplayer.engine.tick
{

    public interface ITicker
    {

        public function ITicker();

        function update() : void;

        function getTick() : int;

        function getAlpha() : Number;

        function setHook(param1:ITickerHook) : void;

    }
}
