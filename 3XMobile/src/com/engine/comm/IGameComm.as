package com.midasplayer.engine.comm
{

    public interface IGameComm
    {

        public function IGameComm();

        function getGameData() : String;

        function addPlayData(param1:String) : void;

        function gameStart() : void;

        function gameEnd(param1:int) : void;

        function gameQuit() : void;

    }
}
