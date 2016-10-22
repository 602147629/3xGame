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
	public dynamic final class CMsgStepCleanResponse extends com.netease.protobuf.Message {
		public static const RESULT:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanResponse.result", "result", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		private var result$field:int;

		private var hasField$0:uint = 0;

		public function clearResult():void {
			hasField$0 &= 0xfffffffe;
			result$field = new int();
		}

		public function get hasResult():Boolean {
			return (hasField$0 & 0x1) != 0;
		}

		public function set result(value:int):void {
			hasField$0 |= 0x1;
			result$field = value;
		}

		public function get result():int {
			return result$field;
		}

		public static const ISOVERGAME:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanResponse.isOverGame", "isOverGame", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		private var isOverGame$field:int;

		public function clearIsOverGame():void {
			hasField$0 &= 0xfffffffd;
			isOverGame$field = new int();
		}

		public function get hasIsOverGame():Boolean {
			return (hasField$0 & 0x2) != 0;
		}

		public function set isOverGame(value:int):void {
			hasField$0 |= 0x2;
			isOverGame$field = value;
		}

		public function get isOverGame():int {
			return isOverGame$field;
		}

		public static const SCORE:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanResponse.score", "score", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		private var score$field:int;

		public function clearScore():void {
			hasField$0 &= 0xfffffffb;
			score$field = new int();
		}

		public function get hasScore():Boolean {
			return (hasField$0 & 0x4) != 0;
		}

		public function set score(value:int):void {
			hasField$0 |= 0x4;
			score$field = value;
		}

		public function get score():int {
			return score$field;
		}

		public static const ADDENERGY:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanResponse.addEnergy", "addEnergy", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		private var addEnergy$field:int;

		public function clearAddEnergy():void {
			hasField$0 &= 0xfffffff7;
			addEnergy$field = new int();
		}

		public function get hasAddEnergy():Boolean {
			return (hasField$0 & 0x8) != 0;
		}

		public function set addEnergy(value:int):void {
			hasField$0 |= 0x8;
			addEnergy$field = value;
		}

		public function get addEnergy():int {
			return addEnergy$field;
		}

		public static const ADDSTEPS:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("qihoo.triplecleangame.protos.CMsgStepCleanResponse.addSteps", "addSteps", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		private var addSteps$field:int;

		public function clearAddSteps():void {
			hasField$0 &= 0xffffffef;
			addSteps$field = new int();
		}

		public function get hasAddSteps():Boolean {
			return (hasField$0 & 0x10) != 0;
		}

		public function set addSteps(value:int):void {
			hasField$0 |= 0x10;
			addSteps$field = value;
		}

		public function get addSteps():int {
			return addSteps$field;
		}

		/**
		 *  @private
		 */
		override public final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			if (hasResult) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, result$field);
			}
			if (hasIsOverGame) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, isOverGame$field);
			}
			if (hasScore) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, score$field);
			}
			if (hasAddEnergy) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, addEnergy$field);
			}
			if (hasAddSteps) {
				com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
				com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, addSteps$field);
			}
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override public final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var result$count:uint = 0;
			var isOverGame$count:uint = 0;
			var score$count:uint = 0;
			var addEnergy$count:uint = 0;
			var addSteps$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (result$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanResponse.result cannot be set twice.');
					}
					++result$count;
					this.result = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (isOverGame$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanResponse.isOverGame cannot be set twice.');
					}
					++isOverGame$count;
					this.isOverGame = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (score$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanResponse.score cannot be set twice.');
					}
					++score$count;
					this.score = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (addEnergy$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanResponse.addEnergy cannot be set twice.');
					}
					++addEnergy$count;
					this.addEnergy = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 5:
					if (addSteps$count != 0) {
						throw new flash.errors.IOError('Bad data format: CMsgStepCleanResponse.addSteps cannot be set twice.');
					}
					++addSteps$count;
					this.addSteps = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
