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
	public dynamic final class PBInviteInfo extends com.netease.protobuf.Message {
		public static const QID:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.PBInviteInfo.qid", "qid", (1 << 3) | com.netease.protobuf.WireType.VARINT);

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

		public static const ACCEPTINVITE:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("qihoo.triplecleangame.protos.PBInviteInfo.acceptInvite", "acceptInvite", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var acceptInvite$field:Boolean;

		private var hasField$0:uint = 0;

		public function clearAcceptInvite():void {
			hasField$0 &= 0xfffffffe;
			acceptInvite$field = new Boolean();
		}

		public function get hasAcceptInvite():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set acceptInvite(value:Boolean):void {
			hasField$0 |= 0x1;
			acceptInvite$field = value;
		}

		public function get acceptInvite():Boolean {
			return acceptInvite$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasQid) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, qid$field);
			}
			if (hasAcceptInvite) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, acceptInvite$field);
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
			var acceptInvite$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (qid$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBInviteInfo.qid cannot be set twice.');
					}
					++qid$count;
					this.qid = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				case 2:
					if (acceptInvite$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBInviteInfo.acceptInvite cannot be set twice.');
					}
					++acceptInvite$count;
					this.acceptInvite = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
