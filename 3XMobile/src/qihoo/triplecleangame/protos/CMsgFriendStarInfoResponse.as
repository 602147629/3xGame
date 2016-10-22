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
	public dynamic final class CMsgFriendStarInfoResponse extends com.netease.protobuf.Message {
		public static const QID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgFriendStarInfoResponse.qid", "qid", (1 << 3) | com.netease.protobuf.WireType.VARINT);

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

		public static const TOTOALSTAR:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgFriendStarInfoResponse.totoalStar", "totoalStar", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var totoalStar$field:int;

		private var hasField$0:uint = 0;

		public function clearTotoalStar():void {
			hasField$0 &= 0xfffffffe;
			totoalStar$field = new int();
		}

		public function get hasTotoalStar():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set totoalStar(value:int):void {
			hasField$0 |= 0x1;
			totoalStar$field = value;
		}

		public function get totoalStar():int {
			return totoalStar$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasQid) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, qid$field);
			}
			if (hasTotoalStar) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, totoalStar$field);
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
			var totoalStar$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (qid$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgFriendStarInfoResponse.qid cannot be set twice.');
					}
					++qid$count;
					this.qid = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (totoalStar$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgFriendStarInfoResponse.totoalStar cannot be set twice.');
					}
					++totoalStar$count;
					this.totoalStar = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
