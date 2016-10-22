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
	public dynamic final class CMsgSendPlayerOrigin extends com.netease.protobuf.Message {
		public static const QID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgSendPlayerOrigin.qid", "qid", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var qid$field:UInt64;

		public function clearQid():void {
			qid$field = null;
		}

		public function get hasQid():Boolean {
			return qid$field != null;
		}

		public function set qid(value:UInt64):void {
			qid$field = value;
		}

		public function get qid():UInt64 {
			return qid$field;
		}

		public static const ORIGIN:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgSendPlayerOrigin.origin", "origin", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var origin$field:int;

		private var hasField$0:uint = 0;

		public function clearOrigin():void {
			hasField$0 &= 0xfffffffe;
			origin$field = new int();
		}

		public function get hasOrigin():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set origin(value:int):void {
			hasField$0 |= 0x1;
			origin$field = value;
		}

		public function get origin():int {
			return origin$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasQid) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, qid$field);
			}
			if (hasOrigin) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, origin$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var qid$count:uint = 0;
			var origin$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (qid$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgSendPlayerOrigin.qid cannot be set twice.');
					}
					++qid$count;
					this.qid = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (origin$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgSendPlayerOrigin.origin cannot be set twice.');
					}
					++origin$count;
					this.origin = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
