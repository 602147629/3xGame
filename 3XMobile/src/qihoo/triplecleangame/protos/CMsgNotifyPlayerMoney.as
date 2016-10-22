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
	public dynamic final class CMsgNotifyPlayerMoney extends com.netease.protobuf.Message {
		public static const GOLD:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgNotifyPlayerMoney.gold", "gold", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var gold$field:int;

		private var hasField$0:uint = 0;

		public function clearGold():void {
			hasField$0 &= 0xfffffffe;
			gold$field = new int();
		}

		public function get hasGold():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set gold(value:int):void {
			hasField$0 |= 0x1;
			gold$field = value;
		}

		public function get gold():int {
			return gold$field;
		}

		public static const SILVER:FieldDescriptor$TYPE_UINT64 = new FieldDescriptor$TYPE_UINT64("qihoo.triplecleangame.protos.CMsgNotifyPlayerMoney.silver", "silver", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var silver$field:UInt64;

		public function clearSilver():void {
			silver$field = null;
		}

		public function get hasSilver():Boolean {
			return silver$field != null;
		}

		public function set silver(value:UInt64):void {
			silver$field = value;
		}

		public function get silver():UInt64 {
			return silver$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasGold) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, gold$field);
			}
			if (hasSilver) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT64(output, silver$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var gold$count:uint = 0;
			var silver$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (gold$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgNotifyPlayerMoney.gold cannot be set twice.');
					}
					++gold$count;
					this.gold = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (silver$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgNotifyPlayerMoney.silver cannot be set twice.');
					}
					++silver$count;
					this.silver = com.netease.protobuf.ReadUtils.read$TYPE_UINT64(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
