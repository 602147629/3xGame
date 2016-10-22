package com.midasplayer.engine.replay
{
    import __AS3__.vec.*;
    import com.midasplayer.debug.*;
    import com.midasplayer.engine.*;
    import com.midasplayer.engine.playdata.*;
    import com.midasplayer.engine.tick.*;

    public class Replayer extends Object implements IReplayer, ITickerHook
    {
        private var _part:IPart;
        private var _ticker:ITicker;
        private var _playDatas:Vector.<IPlayData>;
        private var _playDataIndex:int = 0;
        private var _started:Boolean = false;

        public function Replayer(param1:IPart, param2:ITicker, param3:Vector.<IPlayData>) : void
        {
            this._part = param1;
            this._ticker = param2;
            this._playDatas = param3;
            this._ticker.setHook(this);
            return;
        }// end function

        public function update() : Boolean
        {
            if (this._part.isDone())
            {
                return true;
            }
            if (!this._started)
            {
                this._part.start();
                this._started = true;
            }
            this._ticker.update();
            if (this._part.isDone())
            {
                this._part.stop();
                return true;
            }
            return false;
        }// end function

        public function preTick(param1:int) : void
        {
            this._tryExecutePlayDatas(param1);
            return;
        }// end function

        public function postTick(param1:int) : void
        {
            return;
        }// end function

        private function _tryExecutePlayDatas(param1:int) : void
        {
            var _loc_2:IExecutablePlayData = null;
            while (true)
            {
                
                if (this._playDataIndex >= this._playDatas.length)
                {
                    return;
                }
                _loc_2 = this._playDatas[this._playDataIndex] as IExecutablePlayData;
                if (_loc_2)
                {
                    Debug.assert(_loc_2.getTick() >= param1, "The playdata seems to be unordered on their tick.");
                    if (_loc_2.getTick() > param1)
                    {
                        return;
                    }
                    _loc_2.execute();
                }
                var _loc_3:String = this;
                var _loc_4:* = this._playDataIndex + 1;
                _loc_3._playDataIndex = _loc_4;
            }
            return;
        }// end function

    }
}
