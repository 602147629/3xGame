package com.midasplayer.engine.replay
{
    import __AS3__.vec.*;
    import com.midasplayer.debug.*;
    import com.midasplayer.engine.*;
    import com.midasplayer.engine.comm.*;
    import com.midasplayer.engine.playdata.*;
    import com.midasplayer.engine.render.*;
    import com.midasplayer.engine.tick.*;
    import com.midasplayer.input.*;
    import com.midasplayer.time.*;
    import flash.display.*;

    public class ReplayEngine extends Sprite implements IEngine
    {
        private var _timer:ITimer;
        private var _gameLogic:IGameLogic;
        private var _recorder:IRecorder;
        private var _gameView:IRenderableRoot;
        private var _gameComm:IGameComm;
        private var _ticker:ITicker;
        private var _replayer:IReplayer;
        private var _isDone:Boolean = false;
        private var _first:Boolean = true;
        private var _last:Boolean = false;
        private var _stop:Boolean = false;

        public function ReplayEngine(param1:String, param2:ITimer, param3:int, param4:IGameLogic, param5:MouseInput, param6:KeyboardInput, param7:IGameComm, param8:IRecorder, param9:IRenderableRoot = null)
        {
            Debug.assert(param1 != null, "PlayData must not be null.");
            Debug.assert(param2 != null, "Timer must not be null.");
            Debug.assert(param4 != null, "GameLogic must not be null.");
            Debug.assert(param5 != null, "PlayData must not be null.");
            Debug.assert(param6 != null, "PlayData must not be null.");
            Debug.assert(param8 != null, "Recorder must not be null.");
            this._timer = param2;
            this._gameLogic = param4;
            this._recorder = param8;
            this._gameComm = param7;
            this._gameView = param9;
            var _loc_10:* = new PlayDataParser(param1, new PlayDataFactory(param5, param6)).getEntries();
            this._ticker = new Ticker(param2, param4, param3, 50);
            this._replayer = new Replayer(param4, this._ticker, _loc_10);
            return;
        }// end function

        public function getPlayData() : String
        {
            return this._recorder.toPlayDataXml(this._gameLogic.getFinalScore());
        }// end function

        public function getTimer() : ITimer
        {
            return this._timer;
        }// end function

        public function isDone() : Boolean
        {
            return this._isDone;
        }// end function

        public function stop() : void
        {
            this._stop = true;
            while (!this._last)
            {
                
                this.update();
            }
            return;
        }// end function

        public function getDisplayObject() : DisplayObject
        {
            return this;
        }// end function

        public function update() : void
        {
            if (this._first)
            {
                this._gameComm.gameStart();
                if (this._gameView)
                {
                    addChild(this._gameView.getDisplayObject());
                }
                this._first = false;
            }
            this._replayer.update();
            if (this._gameView)
            {
                this._gameView.render(this._ticker.getTick(), this._ticker.getAlpha());
            }
            if (!this._last && (this._gameLogic.isDone() || this._stop))
            {
                this._gameComm.gameEnd(this._gameLogic.getFinalScore());
                if (this._gameView)
                {
                    removeChild(this._gameView.getDisplayObject());
                }
                this._last = true;
            }
            return;
        }// end function

    }
}
