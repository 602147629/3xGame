package com.midasplayer.engine.tick
{

    public interface ITickable
    {

        public function ITickable();

        function tick(param1:int) : void;

        function isDone() : Boolean;

    }
}
