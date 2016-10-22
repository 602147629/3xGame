package qihoo.triplecleangame.protos {
	import com.netease.protobuf.*;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import qihoo.triplecleangame.protos.PBItemInfo;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CMsgStartGameResponse extends com.netease.protobuf.Message {
		public static const SEED:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStartGameResponse.seed", "seed", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var seed$field:int;

		private var hasField$0:uint = 0;

		public function clearSeed():void {
			hasField$0 &= 0xfffffffe;
			seed$field = new int();
		}

		public function get hasSeed():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set seed(value:int):void {
			hasField$0 |= 0x1;
			seed$field = value;
		}

		public function get seed():int {
			return seed$field;
		}

		public static const RESULT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStartGameResponse.result", "result", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var result$field:int;

		public function clearResult():void {
			hasField$0 &= 0xfffffffd;
			result$field = new int();
		}

		public function get hasResult():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set result(value:int):void {
			hasField$0 |= 0x2;
			result$field = value;
		}

		public function get result():int {
			return result$field;
		}

		public static const GIFTITEMID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStartGameResponse.giftItemID", "giftItemID", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var giftItemID$field:int;

		public function clearGiftItemID():void {
			hasField$0 &= 0xfffffffb;
			giftItemID$field = new int();
		}

		public function get hasGiftItemID():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set giftItemID(value:int):void {
			hasField$0 |= 0x4;
			giftItemID$field = value;
		}

		public function get giftItemID():int {
			return giftItemID$field;
		}

		public static const ITEMARRAY:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgStartGameResponse.itemArray", "itemArray", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBItemInfo);

		[ArrayElementType("qihoo.triplecleangame.protos.PBItemInfo")]
		public var itemArray:Array = [];

		public static const SEEDARRAY:RepeatedFieldDescriptor$TYPE_UINT32 = new RepeatedFieldDescriptor$TYPE_UINT32("qihoo.triplecleangame.protos.CMsgStartGameResponse.seedArray", "seedArray", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		[ArrayElementType("uint")]
		public var seedArray:Array = [];

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasSeed) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, seed$field);
			}
			if (hasResult) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, result$field);
			}
			if (hasGiftItemID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, giftItemID$field);
			}
			for (var itemArray$index:uint = 0; itemArray$index < this.itemArray.length; ++itemArray$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.itemArray[itemArray$index]);
			}
			for (var seedArray$index:uint = 0; seedArray$index < this.seedArray.length; ++seedArray$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_UINT32(output, this.seedArray[seedArray$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var seed$count:uint = 0;
			var result$count:uint = 0;
			var giftItemID$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (seed$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStartGameResponse.seed cannot be set twice.');
					}
					++seed$count;
					this.seed = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStartGameResponse.result cannot be set twice.');
					}
					++result$count;
					this.result = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (giftItemID$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStartGameResponse.giftItemID cannot be set twice.');
					}
					++giftItemID$count;
					this.giftItemID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					this.itemArray.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBItemInfo()));
					break;
				case 5:
					if ((tag & 7) == com.netease.protobuf.WireType.LENGTH_DELIMITED) {
						com.netease.protobuf.ReadUtils.readPackedRepeated(input, com.netease.protobuf.ReadUtils.read$TYPE_UINT32, this.seedArray);
						break;
					}
					this.seedArray.push(com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
