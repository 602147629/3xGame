package qihoo.triplecleangame.protos {
	import com.netease.protobuf.*;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CMsgRestartMatchRequest extends com.netease.protobuf.Message {
		public static const MATCHID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgRestartMatchRequest.matchID", "matchID", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var matchID$field:int;

		private var hasField$0:uint = 0;

		public function clearMatchID():void {
			hasField$0 &= 0xfffffffe;
			matchID$field = new int();
		}

		public function get hasMatchID():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set matchID(value:int):void {
			hasField$0 |= 0x1;
			matchID$field = value;
		}

		public function get matchID():int {
			return matchID$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasMatchID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, matchID$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var matchID$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (matchID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgRestartMatchRequest.matchID cannot be set twice.');
					}
					++matchID$count;
					this.matchID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
