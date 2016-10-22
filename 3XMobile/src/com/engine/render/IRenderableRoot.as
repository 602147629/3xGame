package com.midasplayer.engine.render
{
    import flash.display.*;

    public interface IRenderableRoot extends IRenderable
    {

        public function IRenderableRoot();

        function getDisplayObject() : DisplayObject;

    }
}
