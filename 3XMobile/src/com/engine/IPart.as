package com.midasplayer.engine
{

    public interface IPart extends ITickable
    {

        public function IPart();

        function start() : void;

        function stop() : void;

    }
}
