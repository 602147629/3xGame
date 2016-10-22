package com.midasplayer.engine.tick
{
    import com.midasplayer.debug.*;
    import com.midasplayer.time.*;

    public class Ticker extends Object implements ITicker
    {
        private var _timer:ITimer;
        private var _tickable:ITickable;
        private var _tick:int = 0;
        private var _alpha:Number = 1;
        private var _tickInterval:int = 0;
        private var _startTime:int = -1;
        private var _maxTicks:int = 0;
        private var _hasStarted:Boolean = false;
        private var _hook:ITickerHook;

        public function Ticker(param1:ITimer, param2:ITickable, param3:int, param4:int)
        {
            this._timer = param1;
            this._tickable = param2;
            this._tickInterval = int(1000 / param3);
            this._maxTicks = param4;
            return;
        }// end function

        public function getTick() : int
        {
            return (this._tick - 1);
        }// end function

        public function getAlpha() : Number
        {
            return this._alpha;
        }// end function

        public function setHook(param1:ITickerHook) : void
        {
            Debug.assert(this._hook == null, "A hook is already set.");
            this._hook = param1;
            return;
        }// end function

        public function update() : void
        {
            var _loc_1:* = this._timer.getTime();
            if (!this._hasStarted)
            {
                this._startTime = _loc_1 - this._tickInterval;
                this._hasStarted = true;
            }
            var _loc_2:* = _loc_1 - this._startTime;
            var _loc_3:* = this._tick * this._tickInterval;
            if (_loc_2 < _loc_3)
            {
                Debug.assert(false, "The time has decreased since last step call: " + _loc_2 + " < " + _loc_3);
            }
            var _loc_4:* = _loc_2 - _loc_3;
            if (_loc_2 - _loc_3 >= this._tickInterval)
            {
                this._step(_loc_4);
            }
            this._alpha = Math.min(_loc_2 / this._tickInterval - this._tick, 1);
            return;
        }// end function

        private function _step(param1:int) : void
        {
            var _loc_2:* = this._tick + this._maxTicks;
            while (param1 >= this._tickInterval && this._tick < _loc_2)
            {
                
                if (this._tickable.isDone())
                {
                    break;
                }
                param1 = param1 - this._tickInterval;
                if (this._hook != null)
                {
                    this._hook.preTick(this._tick);
                }
                this._tickable.tick(this._tick);
                if (this._hook != null)
                {
                    this._hook.postTick(this._tick);
                }
                var _loc_3:String = this;
                var _loc_4:* = this._tick + 1;
                _loc_3._tick = _loc_4;
            }
            return;
        }// end function

    }
}
