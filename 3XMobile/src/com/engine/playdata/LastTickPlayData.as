package com.midasplayer.engine.playdata
{

    public class LastTickPlayData extends Object implements IPlayData
    {
        private var _tick:int;
        private var _finalScore:int;
        private var _musicOn:Boolean = true;
        private var _soundOn:Boolean = true;
        private var _fps:int;

        public function LastTickPlayData(param1:int, param2:int, param3:Boolean, param4:Boolean, param5:int)
        {
            this._tick = param1;
            this._finalScore = param2;
            this._musicOn = param3;
            this._soundOn = param4;
            this._fps = param5;
            return;
        }// end function

        public function toPlayData() : String
        {
            return PlayDataConstants.LastTick + "|" + this._tick + "|" + this._finalScore + "|" + int(this._musicOn) + "|" + int(this._soundOn) + "|" + this._fps;
        }// end function

        public function getTick() : int
        {
            return this._tick;
        }// end function

        public function getFinalScore() : int
        {
            return this._finalScore;
        }// end function

        public function getMusicOn() : Boolean
        {
            return this._musicOn;
        }// end function

        public function getSoundOn() : Boolean
        {
            return this._soundOn;
        }// end function

        public function getFps() : int
        {
            return this._fps;
        }// end function

    }
}
