package com.midasplayer.engine.replay
{
    import __AS3__.vec.*;
    import com.midasplayer.debug.*;
    import com.midasplayer.engine.comm.*;
    import com.midasplayer.engine.playdata.*;

    public class Recorder extends Object implements IRecorder
    {
        private var _communicator:IGameComm;
        private const _playDatas:Vector.<IPlayData>;

        public function Recorder(param1:IGameComm)
        {
            this._playDatas = new Vector.<IPlayData>;
            this._communicator = param1;
            return;
        }// end function

        public function add(param1:IPlayData) : void
        {
            Debug.assert(param1 != null, "Trying to add a null play data.");
            this._playDatas.push(param1);
            this._communicator.addPlayData(param1.toPlayData() + "\n");
            return;
        }// end function

        public function toPlayDataXml(param1:int) : String
        {
            var _loc_4:IPlayData = null;
            var _loc_2:* = "<client action=\"gameover\" slotId=\"57788732\" playId=\"0\" request=\"3\" magic=\"813666108\">\n" + "<gameover time=\"2009-05-29 11:40:16\" lastplaydataid=\"" + this._playDatas.length + "\">\n" + "<result><![CDATA[" + param1 + "]]></result>\n";
            var _loc_3:int = 1;
            for each (_loc_4 in this._playDatas)
            {
                
                _loc_2 = _loc_2 + ("  <entry id=\"" + _loc_3 + "\" time=\"2009-05-24 01:34:00\"><![CDATA[" + _loc_4.toPlayData() + "]]></entry>\n");
                _loc_3++;
            }
            _loc_2 = _loc_2 + ("</gameover>\n" + "<process total=\"1\" method=\"1\">\n" + "  <p time=\"2009-05-29 11:36:03\" action=\"error\" code=\"107\" pid=\"0\" />\n" + "</process>\n" + "<focus total=\"1\">\n" + "  <switch time=\"2009-05-29 11:36:03\" pid=\"5768\" title=\"King&#x2e;com &#x28;jk&#x2e;dev&#x2e;midasplayer&#x2e;com&#x29; &#x2d; Microsoft Internet Explorer\" process=\"C&#x3a;&#x5c;Program&#x5c;Internet Explorer&#x5c;iexplore&#x2e;exe\" />\n" + "</focus>\n" + "</client>\n");
            return _loc_2;
        }// end function

    }
}
