package com.midasplayer.engine
{
    import flash.display.*;
    import flash.events.*;

    public class GameMain extends Sprite
    {
        private var start:int = 1;
        protected var _engineFactory:IEngineFactory;
        protected var _engine:IEngine;

        public function GameMain(param1:IEngineFactory)
        {
            this._engineFactory = param1;
            addEventListener(Event.ADDED_TO_STAGE, this._onInitialize);
            return;
        }// end function

        protected function _onInitialize(event:Event) : void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this._onInitialize);
            addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            stage.showDefaultContextMenu = false;
            this._engine = this._engineFactory.create();
            addChild(this._engine as Sprite);
            return;
        }// end function

        protected function _onEnterFrame(event:Event) : void
        {
            if (!this._engine.isDone())
            {
                this._engine.update();
            }
            return;
        }// end function

    }
}
