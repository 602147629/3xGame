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
	public dynamic final class PBStarArray extends com.netease.protobuf.Message {
		public static const LEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBStarArray.level", "level", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var level$field:int;

		private var hasField$0:uint = 0;

		public function clearLevel():void {
			hasField$0 &= 0xfffffffe;
			level$field = new int();
		}

		public function get hasLevel():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set level(value:int):void {
			hasField$0 |= 0x1;
			level$field = value;
		}

		public function get level():int {
			return level$field;
		}

		public static const MAXSTAR:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBStarArray.maxStar", "maxStar", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var maxStar$field:int;

		public function clearMaxStar():void {
			hasField$0 &= 0xfffffffd;
			maxStar$field = new int();
		}

		public function get hasMaxStar():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set maxStar(value:int):void {
			hasField$0 |= 0x2;
			maxStar$field = value;
		}

		public function get maxStar():int {
			return maxStar$field;
		}

		public static const MAXSCORE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBStarArray.maxScore", "maxScore", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var maxScore$field:int;

		public function clearMaxScore():void {
			hasField$0 &= 0xfffffffb;
			maxScore$field = new int();
		}

		public function get hasMaxScore():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set maxScore(value:int):void {
			hasField$0 |= 0x4;
			maxScore$field = value;
		}

		public function get maxScore():int {
			return maxScore$field;
		}

		public static const TIMES:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBStarArray.times", "times", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var times$field:int;

		public function clearTimes():void {
			hasField$0 &= 0xfffffff7;
			times$field = new int();
		}

		public function get hasTimes():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set times(value:int):void {
			hasField$0 |= 0x8;
			times$field = value;
		}

		public function get times():int {
			return times$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, level$field);
			}
			if (hasMaxStar) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, maxStar$field);
			}
			if (hasMaxScore) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, maxScore$field);
			}
			if (hasTimes) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, times$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var level$count:uint = 0;
			var maxStar$count:uint = 0;
			var maxScore$count:uint = 0;
			var times$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (level$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBStarArray.level cannot be set twice.');
					}
					++level$count;
					this.level = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (maxStar$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBStarArray.maxStar cannot be set twice.');
					}
					++maxStar$count;
					this.maxStar = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (maxScore$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBStarArray.maxScore cannot be set twice.');
					}
					++maxScore$count;
					this.maxScore = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (times$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBStarArray.times cannot be set twice.');
					}
					++times$count;
					this.times = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
