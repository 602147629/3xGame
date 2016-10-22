package com.midasplayer.engine.replay
{
    import com.midasplayer.engine.*;

    public interface IReplayEngineFactory
    {

        public function IReplayEngineFactory();

        function create(param1:String, param2:String) : IEngine;

    }
}
