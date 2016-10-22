package com.midasplayer.engine.replay
{
    import com.midasplayer.engine.playdata.*;

    public interface IRecorder
    {

        public function IRecorder();

        function add(param1:IPlayData) : void;

        function toPlayDataXml(param1:int) : String;

    }
}
