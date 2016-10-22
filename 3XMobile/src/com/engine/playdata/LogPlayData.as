package com.midasplayer.engine.playdata
{

    public class LogPlayData extends Object implements IPlayData
    {
        private var _message:String;

        public function LogPlayData(param1:String)
        {
            this._message = param1.replace(new RegExp("\\|", "/g"), "_");
            return;
        }// end function

        public function getMessage() : String
        {
            return this._message;
        }// end function

        public function toPlayData() : String
        {
            return PlayDataConstants.Log + "|" + this._message;
        }// end function

    }
}
