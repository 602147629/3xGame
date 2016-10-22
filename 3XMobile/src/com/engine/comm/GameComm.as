package com.midasplayer.engine.comm
{
    import flash.external.*;
    import flash.system.*;
    import flash.utils.*;

    public class GameComm extends Object implements IGameComm
    {
        private const _validator:Validator;

        public function GameComm()
        {
            this._validator = new Validator();
            return;
        }// end function

        public function getGameData() : String
        {
            this._validator.getGameData();
            var _loc_1:* = ExternalInterface.call("getGameData");
            if (_loc_1 == null)
            {
                throw new Error("The getGameData external interface call returned null.");
            }
            if (_loc_1.success == false)
            {
                throw new Error("The getGameData returned object is not success.");
            }
            if (_loc_1.message == null)
            {
                throw new Error("The GameData returned object has a null message.");
            }
            return _loc_1.message;
        }// end function

        public function addPlayData(param1:String) : void
        {
            this._validator.addPlayData(param1);
            ExternalInterface.call("playData", param1);
            return;
        }// end function

        public function gameStart() : void
        {
            this._validator.gameStart();
            fscommand("gameStart", "");
            return;
        }// end function

        public function gameEnd(param1:int) : void
        {
            this._validator.gameEnd(param1);
            fscommand("gameEnd", "" + param1);
            return;
        }// end function

        public function gameQuit() : void
        {
            this._validator.gameQuit();
            setTimeout(this._quit, 2000);
            return;
        }// end function

        private function _quit() : void
        {
            fscommand("gameQuit", "");
            return;
        }// end function

        public static function isAvailable() : Boolean
        {
            if (!ExternalInterface.available)
            {
                return false;
            }
            try
            {
                new GameComm.getGameData();
                return true;
            }
            catch (e:Error)
            {
            }
            return false;
        }// end function

    }
}
