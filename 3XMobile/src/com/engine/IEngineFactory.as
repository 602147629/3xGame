package com.midasplayer.engine
{

    public interface IEngineFactory
    {

        public function IEngineFactory();

        function create() : IEngine;

    }
}
