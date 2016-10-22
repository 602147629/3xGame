package com.midasplayer.engine
{
    import com.midasplayer.time.*;
    import flash.display.*;

    public interface IEngine
    {

        public function IEngine();

        function isDone() : Boolean;

        function update() : void;

        function getTimer() : ITimer;

        function getPlayData() : String;

        function stop() : void;

        function getDisplayObject() : DisplayObject;

    }
}
