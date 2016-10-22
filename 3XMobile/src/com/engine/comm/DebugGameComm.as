package com.midasplayer.engine.comm
{
    import __AS3__.vec.*;

    public class DebugGameComm extends Object implements IGameComm
    {
        private var _gameData:String;
        private const _playDatas:Vector.<String>;
        private const _validator:Validator;

        public function DebugGameComm(param1:String)
        {
            this._playDatas = new Vector.<String>;
            this._validator = new Validator();
            this._gameData = param1;
            return;
        }// end function

        public function getGameData() : String
        {
            this._validator.getGameData();
            return this._gameData;
        }// end function

        public function addPlayData(param1:String) : void
        {
            this._validator.addPlayData(param1);
            this._playDatas.push(param1);
            return;
        }// end function

        public function gameStart() : void
        {
            this._validator.gameStart();
            return;
        }// end function

        public function gameEnd(param1:int) : void
        {
            this._validator.gameEnd(param1);
            return;
        }// end function

        public function gameQuit() : void
        {
            this._validator.gameQuit();
            return;
        }// end function

        public function getPlayDatas() : Vector.<String>
        {
            return this._playDatas;
        }// end function

        public function getValidatorState() : int
        {
            return this._validator.getState();
        }// end function

    }
}
