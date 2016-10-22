package com.midasplayer.engine.comm
{
    import com.midasplayer.engine.playdata.*;
    import com.midasplayer.engine.replay.*;

    public class RemoteAssertHandler extends Object implements IAssertHandler
    {
        private var _recorder:IRecorder;
        private var _sentAsserts:int = 0;
        private const _maxAsserts:int = 100;

        public function RemoteAssertHandler(param1:IRecorder)
        {
            this._recorder = param1;
            return;
        }// end function

        public function assert(param1:String) : void
        {
            if (this._sentAsserts >= this._maxAsserts)
            {
                return;
            }
            var _loc_2:String = this;
            var _loc_3:* = this._sentAsserts + 1;
            _loc_2._sentAsserts = _loc_3;
            this._recorder.add(new LogPlayData(param1));
            return;
        }// end function

    }
}
