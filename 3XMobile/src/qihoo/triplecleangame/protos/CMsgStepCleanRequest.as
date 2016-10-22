package qihoo.triplecleangame.protos {
	import com.netease.protobuf.*;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import qihoo.triplecleangame.protos.PBMatrix;
	import qihoo.triplecleangame.protos.PBCleanResult;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CMsgStepCleanRequest extends com.netease.protobuf.Message {
		public static const X:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanRequest.x", "x", (1 << 3) | com.netease.protobuf.WireType.VARINT);

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

		public static const Y:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanRequest.y", "y", (2 << 3) | com.netease.protobuf.WireType.VARINT);

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

		public static const DIRECTION:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanRequest.direction", "direction", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var direction$field:int;

		public function clearDirection():void {
			hasField$0 &= 0xfffffffb;
			direction$field = new int();
		}

		public function get hasDirection():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set direction(value:int):void {
			hasField$0 |= 0x4;
			direction$field = value;
		}

		public function get direction():int {
			return direction$field;
		}

		public static const SCORE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanRequest.score", "score", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var score$field:int;

		public function clearScore():void {
			hasField$0 &= 0xfffffff7;
			score$field = new int();
		}

		public function get hasScore():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set score(value:int):void {
			hasField$0 |= 0x8;
			score$field = value;
		}

		public function get score():int {
			return score$field;
		}

		public static const CURLEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanRequest.curLevel", "curLevel", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var curLevel$field:int;

		public function clearCurLevel():void {
			hasField$0 &= 0xffffffef;
			curLevel$field = new int();
		}

		public function get hasCurLevel():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set curLevel(value:int):void {
			hasField$0 |= 0x10;
			curLevel$field = value;
		}

		public function get curLevel():int {
			return curLevel$field;
		}

		public static const TOTALSCORE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanRequest.totalScore", "totalScore", (6 << 3) | com.netease.protobuf.WireType.VARINT);

		private var totalScore$field:int;

		public function clearTotalScore():void {
			hasField$0 &= 0xffffffdf;
			totalScore$field = new int();
		}

		public function get hasTotalScore():Boolean {
			return (hasField$0 & 0x20) != 0;
		}

		public function set totalScore(value:int):void {
			hasField$0 |= 0x20;
			totalScore$field = value;
		}

		public function get totalScore():int {
			return totalScore$field;
		}

		public static const SILVERNUM:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanRequest.silverNum", "silverNum", (7 << 3) | com.netease.protobuf.WireType.VARINT);

		private var silverNum$field:int;

		public function clearSilverNum():void {
			hasField$0 &= 0xffffffbf;
			silverNum$field = new int();
		}

		public function get hasSilverNum():Boolean {
			return (hasField$0 & 0x40) != 0;
		}

		public function set silverNum(value:int):void {
			hasField$0 |= 0x40;
			silverNum$field = value;
		}

		public function get silverNum():int {
			return silverNum$field;
		}

		public static const ISSUBSTEP:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("qihoo.triplecleangame.protos.CMsgStepCleanRequest.isSubStep", "isSubStep", (8 << 3) | com.netease.protobuf.WireType.VARINT);

		private var isSubStep$field:Boolean;

		public function clearIsSubStep():void {
			hasField$0 &= 0xffffff7f;
			isSubStep$field = new Boolean();
		}

		public function get hasIsSubStep():Boolean {
			return (hasField$0 & 0x80) != 0;
		}

		public function set isSubStep(value:Boolean):void {
			hasField$0 |= 0x80;
			isSubStep$field = value;
		}

		public function get isSubStep():Boolean {
			return isSubStep$field;
		}

		public static const CLEANRESULT:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgStepCleanRequest.cleanResult", "cleanResult", (9 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBCleanResult);

		[ArrayElementType("qihoo.triplecleangame.protos.PBCleanResult")]
		public var cleanResult:Array = [];

		public static const MATRIX:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgStepCleanRequest.matrix", "matrix", (10 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBMatrix);

		[ArrayElementType("qihoo.triplecleangame.protos.PBMatrix")]
		public var matrix:Array = [];

		public static const ONCECLEANRESULT:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgStepCleanRequest.onceCleanResult", "onceCleanResult", (11 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBCleanResult);

		[ArrayElementType("qihoo.triplecleangame.protos.PBCleanResult")]
		public var onceCleanResult:Array = [];

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
			if (hasDirection) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, direction$field);
			}
			if (hasScore) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, score$field);
			}
			if (hasCurLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, curLevel$field);
			}
			if (hasTotalScore) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, totalScore$field);
			}
			if (hasSilverNum) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 7);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, silverNum$field);
			}
			if (hasIsSubStep) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 8);
				com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, isSubStep$field);
			}
			for (var cleanResult$index:uint = 0; cleanResult$index < this.cleanResult.length; ++cleanResult$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 9);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.cleanResult[cleanResult$index]);
			}
			for (var matrix$index:uint = 0; matrix$index < this.matrix.length; ++matrix$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 10);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.matrix[matrix$index]);
			}
			for (var onceCleanResult$index:uint = 0; onceCleanResult$index < this.onceCleanResult.length; ++onceCleanResult$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 11);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.onceCleanResult[onceCleanResult$index]);
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
			var direction$count:uint = 0;
			var score$count:uint = 0;
			var curLevel$count:uint = 0;
			var totalScore$count:uint = 0;
			var silverNum$count:uint = 0;
			var isSubStep$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (x$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanRequest.x cannot be set twice.');
					}
					++x$count;
					this.x = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (y$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanRequest.y cannot be set twice.');
					}
					++y$count;
					this.y = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (direction$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanRequest.direction cannot be set twice.');
					}
					++direction$count;
					this.direction = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (score$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanRequest.score cannot be set twice.');
					}
					++score$count;
					this.score = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (curLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanRequest.curLevel cannot be set twice.');
					}
					++curLevel$count;
					this.curLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 6:
					if (totalScore$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanRequest.totalScore cannot be set twice.');
					}
					++totalScore$count;
					this.totalScore = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 7:
					if (silverNum$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanRequest.silverNum cannot be set twice.');
					}
					++silverNum$count;
					this.silverNum = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 8:
					if (isSubStep$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanRequest.isSubStep cannot be set twice.');
					}
					++isSubStep$count;
					this.isSubStep = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 9:
					this.cleanResult.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBCleanResult()));
					break;
				case 10:
					this.matrix.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBMatrix()));
					break;
				case 11:
					this.onceCleanResult.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBCleanResult()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
