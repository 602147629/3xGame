package com.midasplayer.engine.playdata
{

    public interface IExecutablePlayData extends IPlayData
    {

        public function IExecutablePlayData();

        function getTick() : int;

        function execute() : void;

    }
}
