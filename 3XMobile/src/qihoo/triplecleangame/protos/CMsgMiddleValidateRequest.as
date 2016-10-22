package qihoo.triplecleangame.protos {
	import com.netease.protobuf.*;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	import qihoo.triplecleangame.protos.PBMatrix;
	import qihoo.triplecleangame.protos.PBScoreItem;
	import qihoo.triplecleangame.protos.PBRandomList;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class CMsgMiddleValidateRequest extends com.netease.protobuf.Message {
		public static const SCORE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgMiddleValidateRequest.score", "score", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var score$field:int;

		private var hasField$0:uint = 0;

		public function clearScore():void {
			hasField$0 &= 0xfffffffe;
			score$field = new int();
		}

		public function get hasScore():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set score(value:int):void {
			hasField$0 |= 0x1;
			score$field = value;
		}

		public function get score():int {
			return score$field;
		}

		public static const TIMES:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgMiddleValidateRequest.times", "times", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var times$field:int;

		public function clearTimes():void {
			hasField$0 &= 0xfffffffd;
			times$field = new int();
		}

		public function get hasTimes():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set times(value:int):void {
			hasField$0 |= 0x2;
			times$field = value;
		}

		public function get times():int {
			return times$field;
		}

		public static const CURLEVEL:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgMiddleValidateRequest.curLevel", "curLevel", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var curLevel$field:int;

		public function clearCurLevel():void {
			hasField$0 &= 0xfffffffb;
			curLevel$field = new int();
		}

		public function get hasCurLevel():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set curLevel(value:int):void {
			hasField$0 |= 0x4;
			curLevel$field = value;
		}

		public function get curLevel():int {
			return curLevel$field;
		}

		public static const MATRIX:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgMiddleValidateRequest.matrix", "matrix", (4 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBMatrix);

		[ArrayElementType("qihoo.triplecleangame.protos.PBMatrix")]
		public var matrix:Array = [];

		public static const RANDOMINDEX:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgMiddleValidateRequest.randomIndex", "randomIndex", (5 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBRandomList);

		[ArrayElementType("qihoo.triplecleangame.protos.PBRandomList")]
		public var randomIndex:Array = [];

		public static const SCOREITEM:RepeatedFieldDescriptor$TYPE_MESSAGE = new RepeatedFieldDescriptor$TYPE_MESSAGE("qihoo.triplecleangame.protos.CMsgMiddleValidateRequest.scoreItem", "scoreItem", (6 << 3) | com.netease.protobuf.WireType.LENGTH_DELIMITED, qihoo.triplecleangame.protos.PBScoreItem);

		[ArrayElementType("qihoo.triplecleangame.protos.PBScoreItem")]
		public var scoreItem:Array = [];

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasScore) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, score$field);
			}
			if (hasTimes) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, times$field);
			}
			if (hasCurLevel) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, curLevel$field);
			}
			for (var matrix$index:uint = 0; matrix$index < this.matrix.length; ++matrix$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.matrix[matrix$index]);
			}
			for (var randomIndex$index:uint = 0; randomIndex$index < this.randomIndex.length; ++randomIndex$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.randomIndex[randomIndex$index]);
			}
			for (var scoreItem$index:uint = 0; scoreItem$index < this.scoreItem.length; ++scoreItem$index) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.LENGTH_DELIMITED, 6);
				com.netease.protobuf.WriteUtils.write$TYPE_MESSAGE(output, this.scoreItem[scoreItem$index]);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var score$count:uint = 0;
			var times$count:uint = 0;
			var curLevel$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (score$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgMiddleValidateRequest.score cannot be set twice.');
					}
					++score$count;
					this.score = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (times$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgMiddleValidateRequest.times cannot be set twice.');
					}
					++times$count;
					this.times = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (curLevel$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgMiddleValidateRequest.curLevel cannot be set twice.');
					}
					++curLevel$count;
					this.curLevel = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					this.matrix.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBMatrix()));
					break;
				case 5:
					this.randomIndex.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBRandomList()));
					break;
				case 6:
					this.scoreItem.push(com.netease.protobuf.ReadUtils.read$TYPE_MESSAGE(input, new qihoo.triplecleangame.protos.PBScoreItem()));
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
