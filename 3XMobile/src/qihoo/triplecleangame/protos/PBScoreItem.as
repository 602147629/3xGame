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
	public dynamic final class PBScoreItem extends com.netease.protobuf.Message {
		public static const X:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBScoreItem.x", "x", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var x$field:int;

		private var hasField$0:uint = 0;

		public function clearX():void {
			hasField$0 &= 0xfffffffe;
			x$field = new int();
		}

		public function get hasX():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set x(value:int):void {
			hasField$0 |= 0x1;
			x$field = value;
		}

		public function get x():int {
			return x$field;
		}

		public static const Y:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBScoreItem.y", "y", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var y$field:int;

		public function clearY():void {
			hasField$0 &= 0xfffffffd;
			y$field = new int();
		}

		public function get hasY():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set y(value:int):void {
			hasField$0 |= 0x2;
			y$field = value;
		}

		public function get y():int {
			return y$field;
		}

		public static const SCOREID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBScoreItem.scoreID", "scoreID", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var scoreID$field:int;

		public function clearScoreID():void {
			hasField$0 &= 0xfffffffb;
			scoreID$field = new int();
		}

		public function get hasScoreID():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set scoreID(value:int):void {
			hasField$0 |= 0x4;
			scoreID$field = value;
		}

		public function get scoreID():int {
			return scoreID$field;
		}

		public static const EFFECTID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBScoreItem.effectID", "effectID", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var effectID$field:int;

		public function clearEffectID():void {
			hasField$0 &= 0xfffffff7;
			effectID$field = new int();
		}

		public function get hasEffectID():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set effectID(value:int):void {
			hasField$0 |= 0x8;
			effectID$field = value;
		}

		public function get effectID():int {
			return effectID$field;
		}

		public static const SINGLESCORE:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("qihoo.triplecleangame.protos.PBScoreItem.singleScore", "singleScore", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var singleScore$field:Boolean;

		public function clearSingleScore():void {
			hasField$0 &= 0xffffffef;
			singleScore$field = new Boolean();
		}

		public function get hasSingleScore():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set singleScore(value:Boolean):void {
			hasField$0 |= 0x10;
			singleScore$field = value;
		}

		public function get singleScore():Boolean {
			return singleScore$field;
		}

		public static const TIMES:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.PBScoreItem.times", "times", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var times$field:int;

		public function clearTimes():void {
			hasField$0 &= 0xffffffdf;
			times$field = new int();
		}

		public function get hasTimes():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set times(value:int):void {
			hasField$0 |= 0x20;
			times$field = value;
		}

		public function get times():int {
			return times$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasX) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, x$field);
			}
			if (hasY) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, y$field);
			}
			if (hasScoreID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, scoreID$field);
			}
			if (hasEffectID) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, effectID$field);
			}
			if (hasSingleScore) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, singleScore$field);
			}
			if (hasTimes) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
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
			var x$count:uint = 0;
			var y$count:uint = 0;
			var scoreID$count:uint = 0;
			var effectID$count:uint = 0;
			var singleScore$count:uint = 0;
			var times$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (x$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBScoreItem.x cannot be set twice.');
					}
					++x$count;
					this.x = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (y$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBScoreItem.y cannot be set twice.');
					}
					++y$count;
					this.y = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (scoreID$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBScoreItem.scoreID cannot be set twice.');
					}
					++scoreID$count;
					this.scoreID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (effectID$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBScoreItem.effectID cannot be set twice.');
					}
					++effectID$count;
					this.effectID = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (singleScore$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBScoreItem.singleScore cannot be set twice.');
					}
					++singleScore$count;
					this.singleScore = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 6:
					if (times$count != 0) {
						throw new flash.errors.IOError('Bad data format: PBScoreItem.times cannot be set twice.');
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
