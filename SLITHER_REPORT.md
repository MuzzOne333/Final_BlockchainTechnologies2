**THIS CHECKLIST IS NOT COMPLETE**. Use `--show-ignored-findings` to show all the results.
Summary
 - [arbitrary-send-eth](#arbitrary-send-eth) (3 results) (High)
 - [incorrect-exp](#incorrect-exp) (1 results) (High)
 - [shadowing-state](#shadowing-state) (1 results) (High)
 - [divide-before-multiply](#divide-before-multiply) (9 results) (Medium)
 - [incorrect-equality](#incorrect-equality) (2 results) (Medium)
 - [unused-return](#unused-return) (9 results) (Medium)
 - [shadowing-local](#shadowing-local) (3 results) (Low)
 - [missing-zero-check](#missing-zero-check) (1 results) (Low)
 - [calls-loop](#calls-loop) (1 results) (Low)
 - [reentrancy-benign](#reentrancy-benign) (1 results) (Low)
 - [reentrancy-events](#reentrancy-events) (3 results) (Low)
 - [timestamp](#timestamp) (4 results) (Low)
 - [assembly](#assembly) (59 results) (Informational)
 - [pragma](#pragma) (1 results) (Informational)
 - [solc-version](#solc-version) (5 results) (Informational)
 - [low-level-calls](#low-level-calls) (4 results) (Informational)
 - [naming-convention](#naming-convention) (10 results) (Informational)
 - [too-many-digits](#too-many-digits) (7 results) (Informational)
 - [unindexed-event-address](#unindexed-event-address) (2 results) (Informational)
## arbitrary-send-eth
Impact: High
Confidence: Medium
 - [ ] ID-0
[Governor._executeOperations(uint256,address[],uint256[],bytes[],bytes32)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L434-L445) sends eth to arbitrary user
	Dangerous calls:
	- [(success,returndata) = targets[i].call{value: values[i]}(calldatas[i])](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L442)

lib/openzeppelin-contracts/contracts/governance/Governor.sol#L434-L445


 - [ ] ID-1
[Governor.relay(address,uint256,bytes)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L656-L659) sends eth to arbitrary user
	Dangerous calls:
	- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L657)

lib/openzeppelin-contracts/contracts/governance/Governor.sol#L656-L659


 - [ ] ID-2
[TimelockController._execute(address,uint256,bytes)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L410-L413) sends eth to arbitrary user
	Dangerous calls:
	- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L411)

lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L410-L413


## incorrect-exp
Impact: High
Confidence: Medium
 - [ ] ID-3
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277) has bitwise-xor operator ^ instead of the exponentiation operator **: 
	 - [inverse = (3 * denominator) ^ 2](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L259)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277


## shadowing-state
Impact: High
Confidence: High
 - [ ] ID-4
[Governor._name](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L48) shadows:
	- [EIP712._name](lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol#L49)

lib/openzeppelin-contracts/contracts/governance/Governor.sol#L48


## divide-before-multiply
Impact: Medium
Confidence: Medium
 - [ ] ID-5
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L244)
	- [inverse = (3 * denominator) ^ 2](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L259)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277


 - [ ] ID-6
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277) performs a multiplication on the result of a division:
	- [low = low / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L247)
	- [result = low * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L274)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277


 - [ ] ID-7
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L244)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L265)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277


 - [ ] ID-8
[Math.invMod(uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L317-L363) performs a multiplication on the result of a division:
	- [quotient = gcd / remainder](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L339)
	- [(gcd,remainder) = (remainder,gcd - remainder * quotient)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L341-L348)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L317-L363


 - [ ] ID-9
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L244)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L264)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277


 - [ ] ID-10
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L244)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L266)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277


 - [ ] ID-11
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L244)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L267)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277


 - [ ] ID-12
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L244)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L263)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277


 - [ ] ID-13
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277) performs a multiplication on the result of a division:
	- [denominator = denominator / twos](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L244)
	- [inverse *= 2 - denominator * inverse](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L268)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277


## incorrect-equality
Impact: Medium
Confidence: High
 - [ ] ID-14
[TimelockController.getOperationState(bytes32)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L205-L216) uses a dangerous strict equality:
	- [timestamp == DONE_TIMESTAMP](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L209)

lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L205-L216


 - [ ] ID-15
[TimelockController.getOperationState(bytes32)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L205-L216) uses a dangerous strict equality:
	- [timestamp == 0](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L207)

lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L205-L216


## unused-return
Impact: Medium
Confidence: Medium
 - [ ] ID-16
[TimelockController._execute(address,uint256,bytes)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L410-L413) ignores return value by [Address.verifyCallResult(success,returndata)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L412)

lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L410-L413


 - [ ] ID-17
[GovernorVotesQuorumFraction._optimisticUpperLookupRecent(Checkpoints.Trace208,uint256)](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotesQuorumFraction.sol#L104-L112) ignores return value by [(None,key,value) = ckpts.latestCheckpoint()](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotesQuorumFraction.sol#L110)

lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotesQuorumFraction.sol#L104-L112


 - [ ] ID-18
[Time.get(Time.Delay)](lib/openzeppelin-contracts/contracts/utils/types/Time.sol#L93-L96) ignores return value by [(delay,None,None) = self.getFull()](lib/openzeppelin-contracts/contracts/utils/types/Time.sol#L94)

lib/openzeppelin-contracts/contracts/utils/types/Time.sol#L93-L96


 - [ ] ID-19
[Votes._push(Checkpoints.Trace208,function(uint208,uint208) returns(uint208),uint208)](lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#L233-L239) ignores return value by [store.push(clock(),op(store.latest(),delta))](lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#L238)

lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#L233-L239


 - [ ] ID-20
[SignatureChecker.isValidSignatureNowCalldata(address,bytes32,bytes)](lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L44-L55) ignores return value by [(recovered,err,None) = ECDSA.tryRecoverCalldata(hash,signature)](lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L50)

lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L44-L55


 - [ ] ID-21
[Governor._executeOperations(uint256,address[],uint256[],bytes[],bytes32)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L434-L445) ignores return value by [Address.verifyCallResult(success,returndata)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L443)

lib/openzeppelin-contracts/contracts/governance/Governor.sol#L434-L445


 - [ ] ID-22
[GovernorVotesQuorumFraction._updateQuorumNumerator(uint256)](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotesQuorumFraction.sol#L89-L99) ignores return value by [_quorumNumeratorHistory.push(clock(),SafeCast.toUint208(newQuorumNumerator))](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotesQuorumFraction.sol#L96)

lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotesQuorumFraction.sol#L89-L99


 - [ ] ID-23
[SignatureChecker.isValidSignatureNow(address,bytes32,bytes)](lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L32-L39) ignores return value by [(recovered,err,None) = ECDSA.tryRecover(hash,signature)](lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L34)

lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L32-L39


 - [ ] ID-24
[Governor.relay(address,uint256,bytes)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L656-L659) ignores return value by [Address.verifyCallResult(success,returndata)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L658)

lib/openzeppelin-contracts/contracts/governance/Governor.sol#L656-L659


## shadowing-local
Impact: Low
Confidence: High
 - [ ] ID-25
[ERC20Permit.constructor(string).name](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#L39) shadows:
	- [ERC20.name()](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L52-L54) (function)
	- [IERC20Metadata.name()](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#L15) (function)

lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#L39


 - [ ] ID-26
[GameGovernor.constructor(IVotes,TimelockController)._timelock](src/governance/GameGovernor.sol#L19) shadows:
	- [GovernorTimelockControl._timelock](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#L25) (state variable)

src/governance/GameGovernor.sol#L19


 - [ ] ID-27
[GameGovernor.constructor(IVotes,TimelockController)._token](src/governance/GameGovernor.sol#L19) shadows:
	- [GovernorVotes._token](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol#L16) (state variable)

src/governance/GameGovernor.sol#L19


## missing-zero-check
Impact: Low
Confidence: Medium
 - [ ] ID-28
[Governor.relay(address,uint256,bytes).target](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L656) lacks a zero-check on :
		- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L657)

lib/openzeppelin-contracts/contracts/governance/Governor.sol#L656


## calls-loop
Impact: Low
Confidence: Medium
 - [ ] ID-29
[TimelockController._execute(address,uint256,bytes)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L410-L413) has external calls inside a loop: [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L411)
	Calls stack containing the loop:
		TimelockController.executeBatch(address[],uint256[],bytes[],bytes32,bytes32)

lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L410-L413


## reentrancy-benign
Impact: Low
Confidence: Medium
 - [ ] ID-30
Reentrancy in [GovernorTimelockControl._executeOperations(uint256,address[],uint256[],bytes[],bytes32)](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#L97-L108):
	External calls:
	- [_timelock.executeBatch{value: msg.value}(targets,values,calldatas,0,_timelockSalt(descriptionHash))](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#L105)
	State variables written after the call(s):
	- [delete _timelockIds[proposalId]](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#L107)

lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#L97-L108


## reentrancy-events
Impact: Low
Confidence: Medium
 - [ ] ID-31
Reentrancy in [Governor.execute(address[],uint256[],bytes[],bytes32)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L390-L425):
	External calls:
	- [_executeOperations(proposalId,targets,values,calldatas,descriptionHash)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L415)
		- [(success,returndata) = targets[i].call{value: values[i]}(calldatas[i])](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L442)
	Event emitted after the call(s):
	- [ProposalExecuted(proposalId)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L422)

lib/openzeppelin-contracts/contracts/governance/Governor.sol#L390-L425


 - [ ] ID-32
Reentrancy in [TimelockController.execute(address,uint256,bytes,bytes32,bytes32)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L356-L369):
	External calls:
	- [_execute(target,value,payload)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L366)
		- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L411)
	Event emitted after the call(s):
	- [CallExecuted(id,0,target,value,payload)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L367)

lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L356-L369


 - [ ] ID-33
Reentrancy in [TimelockController.executeBatch(address[],uint256[],bytes[],bytes32,bytes32)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L383-L405):
	External calls:
	- [_execute(target,value,payload)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L401)
		- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L411)
	Event emitted after the call(s):
	- [CallExecuted(id,i,target,value,payload)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L402)

lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L383-L405


## timestamp
Impact: Low
Confidence: Medium
 - [ ] ID-34
[ERC20Permit.permit(address,address,uint256,uint256,uint8,bytes32,bytes32)](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#L42-L65) uses timestamp for comparisons
	Dangerous comparisons:
	- [block.timestamp > deadline](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#L51)

lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#L42-L65


 - [ ] ID-35
[TimelockController.getOperationState(bytes32)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L205-L216) uses timestamp for comparisons
	Dangerous comparisons:
	- [timestamp == 0](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L207)
	- [timestamp == DONE_TIMESTAMP](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L209)
	- [timestamp > block.timestamp](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L211)

lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L205-L216


 - [ ] ID-36
[Votes.delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)](lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#L144-L163) uses timestamp for comparisons
	Dangerous comparisons:
	- [block.timestamp > expiry](lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#L152)

lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#L144-L163


 - [ ] ID-37
[Time._getFullAt(Time.Delay,uint48)](lib/openzeppelin-contracts/contracts/utils/types/Time.sol#L74-L80) uses timestamp for comparisons
	Dangerous comparisons:
	- [effect <= timepoint](lib/openzeppelin-contracts/contracts/utils/types/Time.sol#L79)

lib/openzeppelin-contracts/contracts/utils/types/Time.sol#L74-L80


## assembly
Impact: Informational
Confidence: High
 - [ ] ID-38
[Strings.toChecksumHexString(address)](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L108-L126) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L113-L115)

lib/openzeppelin-contracts/contracts/utils/Strings.sol#L108-L126


 - [ ] ID-39
[Math.tryMul(uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L73-L84) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L76-L80)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L73-L84


 - [ ] ID-40
[Math._zeroBytes(bytes)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L478-L490) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L482-L484)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L478-L490


 - [ ] ID-41
[LowLevelCall.callReturn64Bytes(address,uint256,bytes)](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L38-L48) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L43-L47)

lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L38-L48


 - [ ] ID-42
[StorageSlot.getAddressSlot(bytes32)](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L66-L70) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L67-L69)

lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L66-L70


 - [ ] ID-43
[Checkpoints._unsafeAccess(Checkpoints.Checkpoint256[],uint256)](lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L215-L223) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L219-L222)

lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L215-L223


 - [ ] ID-44
[ECDSA.parse(bytes)](lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L217-L240) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L218-L239)

lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L217-L240


 - [ ] ID-45
[MessageHashUtils.toDomainTypeHash(bytes1)](lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L182-L227) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L185-L226)

lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L182-L227


 - [ ] ID-46
[Math.mul512(uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L37-L46) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L41-L45)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L37-L46


 - [ ] ID-47
[LowLevelCall.callNoReturn(address,uint256,bytes)](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L19-L23) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L20-L22)

lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L19-L23


 - [ ] ID-48
[Math.mulDiv(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L229-L236)
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L242-L251)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L206-L277


 - [ ] ID-49
[Math.add512(uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L25-L30) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L26-L29)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L25-L30


 - [ ] ID-50
[LowLevelCall.bubbleRevert()](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L114-L120) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L115-L119)

lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L114-L120


 - [ ] ID-51
[ECDSA.tryRecoverCalldata(bytes32,bytes)](lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L85-L104) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L95-L99)

lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L85-L104


 - [ ] ID-52
[SafeCast.toUint(bool)](lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol#L1157-L1161) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol#L1158-L1160)

lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol#L1157-L1161


 - [ ] ID-53
[ECDSA.tryRecover(bytes32,bytes)](lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L61-L80) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L71-L75)

lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L61-L80


 - [ ] ID-54
[StorageSlot.getInt256Slot(bytes32)](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L102-L106) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L103-L105)

lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L102-L106


 - [ ] ID-55
[SignatureChecker.isValidERC1271SignatureNowCalldata(address,bytes32,bytes)](lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L90-L115) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L98-L114)

lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L90-L115


 - [ ] ID-56
[Math.tryModExp(bytes,bytes,bytes)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L451-L473) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L463-L472)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L451-L473


 - [ ] ID-57
[Bytes.concat(bytes[])](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L183-L203) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L194-L196)

lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L183-L203


 - [ ] ID-58
[Math.tryModExp(uint256,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L411-L435) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L413-L434)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L411-L435


 - [ ] ID-59
[LowLevelCall.returnData()](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L104-L111) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L105-L110)

lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L104-L111


 - [ ] ID-60
[Panic.panic(uint256)](lib/openzeppelin-contracts/contracts/utils/Panic.sol#L50-L56) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Panic.sol#L51-L55)

lib/openzeppelin-contracts/contracts/utils/Panic.sol#L50-L56


 - [ ] ID-61
[StorageSlot.getBytesSlot(bytes32)](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L129-L133) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L130-L132)

lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L129-L133


 - [ ] ID-62
[MessageHashUtils.toDataWithIntendedValidatorHash(address,bytes32)](lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L71-L81) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L75-L80)

lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L71-L81


 - [ ] ID-63
[LowLevelCall.delegatecallReturn64Bytes(address,bytes)](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L85-L94) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L89-L93)

lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L85-L94


 - [ ] ID-64
[Math.log2(uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L619-L658) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L655-L657)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L619-L658


 - [ ] ID-65
[LowLevelCall.staticcallReturn64Bytes(address,bytes)](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L62-L71) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L66-L70)

lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L62-L71


 - [ ] ID-66
[StorageSlot.getStringSlot(string)](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L120-L124) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L121-L123)

lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L120-L124


 - [ ] ID-67
[Bytes.slice(bytes,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L86-L98) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L93-L95)

lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L86-L98


 - [ ] ID-68
[Strings.toString(uint256)](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L42-L60) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L47-L49)
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L52-L54)

lib/openzeppelin-contracts/contracts/utils/Strings.sol#L42-L60


 - [ ] ID-69
[StorageSlot.getBytes32Slot(bytes32)](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L84-L88) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L85-L87)

lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L84-L88


 - [ ] ID-70
[Math.tryMod(uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L102-L110) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L105-L108)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L102-L110


 - [ ] ID-71
[StorageSlot.getBytesSlot(bytes)](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L138-L142) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L139-L141)

lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L138-L142


 - [ ] ID-72
[Strings._unsafeWriteBytesOffset(bytes,uint256,bytes1)](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L526-L531) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L528-L530)

lib/openzeppelin-contracts/contracts/utils/Strings.sol#L526-L531


 - [ ] ID-73
[Math.tryDiv(uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L89-L97) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L92-L95)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L89-L97


 - [ ] ID-74
[Governor._unsafeReadBytesOffset(bytes,uint256)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L813-L818) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L815-L817)

lib/openzeppelin-contracts/contracts/governance/Governor.sol#L813-L818


 - [ ] ID-75
[Checkpoints._unsafeAccess(Checkpoints.Checkpoint224[],uint256)](lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L418-L426) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L422-L425)

lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L418-L426


 - [ ] ID-76
[LowLevelCall.staticcallNoReturn(address,bytes)](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L51-L55) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L52-L54)

lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L51-L55


 - [ ] ID-77
[LowLevelCall.delegatecallNoReturn(address,bytes)](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L74-L78) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L75-L77)

lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L74-L78


 - [ ] ID-78
[Bytes.splice(bytes,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L117-L129) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L123-L126)

lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L117-L129


 - [ ] ID-79
[StorageSlot.getBooleanSlot(bytes32)](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L75-L79) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L76-L78)

lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L75-L79


 - [ ] ID-80
[StorageSlot.getStringSlot(bytes32)](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L111-L115) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L112-L114)

lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L111-L115


 - [ ] ID-81
[Bytes.toNibbles(bytes)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L210-L245) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L211-L244)

lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L210-L245


 - [ ] ID-82
[LowLevelCall.bubbleRevert(bytes)](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L122-L126) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L123-L125)

lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L122-L126


 - [ ] ID-83
[Bytes.replace(bytes,uint256,bytes,uint256,uint256)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L154-L172) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L167-L169)

lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L154-L172


 - [ ] ID-84
[Bytes._unsafeReadBytesOffset(bytes,uint256)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L326-L331) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L328-L330)

lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L326-L331


 - [ ] ID-85
[Strings._unsafeReadBytesOffset(bytes,uint256)](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L513-L518) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L515-L517)

lib/openzeppelin-contracts/contracts/utils/Strings.sol#L513-L518


 - [ ] ID-86
[MessageHashUtils.toTypedDataHash(bytes32,bytes32)](lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L92-L100) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L93-L99)

lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L92-L100


 - [ ] ID-87
[MessageHashUtils.toDomainSeparator(bytes1,bytes32,bytes32,uint256,address,bytes32)](lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L137-L179) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L147-L178)

lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L137-L179


 - [ ] ID-88
[Checkpoints._unsafeAccess(Checkpoints.Checkpoint208[],uint256)](lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L621-L629) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L625-L628)

lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L621-L629


 - [ ] ID-89
[Checkpoints._unsafeAccess(Checkpoints.Checkpoint160[],uint256)](lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L824-L832) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L828-L831)

lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L824-L832


 - [ ] ID-90
[ShortStrings.toString(ShortString)](lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#L63-L72) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#L67-L70)

lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#L63-L72


 - [ ] ID-91
[Strings.escapeJSON(string)](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L461-L505) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L468-L470)
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L499-L502)

lib/openzeppelin-contracts/contracts/utils/Strings.sol#L461-L505


 - [ ] ID-92
[LowLevelCall.returnDataSize()](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L97-L101) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L98-L100)

lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L97-L101


 - [ ] ID-93
[StorageSlot.getUint256Slot(bytes32)](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L93-L97) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L94-L96)

lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L93-L97


 - [ ] ID-94
[ECDSA.parseCalldata(bytes)](lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L245-L268) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L246-L267)

lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L245-L268


 - [ ] ID-95
[MessageHashUtils.toEthSignedMessageHash(bytes32)](lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L32-L38) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L33-L37)

lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L32-L38


 - [ ] ID-96
[SignatureChecker.isValidERC1271SignatureNow(address,bytes32,bytes)](lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L64-L88) uses assembly
	- [INLINE ASM](lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L72-L87)

lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L64-L88


## pragma
Impact: Informational
Confidence: High
 - [ ] ID-97
6 different versions of Solidity are used:
	- Version constraint ^0.8.20 is used by:
		-[^0.8.20](lib/openzeppelin-contracts/contracts/access/AccessControl.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC1155/utils/ERC1155Holder.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Holder.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/Address.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/Context.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/Errors.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/Nonces.sol#L3)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/Panic.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L5)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol#L5)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol#L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L5)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/structs/DoubleEndedQueue.sol#L3)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/types/Time.sol#L4)
		-[^0.8.20](src/governance/GameGovernor.sol#L2)
		-[^0.8.20](src/governance/GameTimelock.sol#L2)
		-[^0.8.20](src/governance/GameToken.sol#L2)
	- Version constraint >=0.8.4 is used by:
		-[>=0.8.4](lib/openzeppelin-contracts/contracts/access/IAccessControl.sol#L4)
		-[>=0.8.4](lib/openzeppelin-contracts/contracts/governance/IGovernor.sol#L4)
		-[>=0.8.4](lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol#L4)
		-[>=0.8.4](lib/openzeppelin-contracts/contracts/interfaces/IERC5805.sol#L4)
		-[>=0.8.4](lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol#L4)
	- Version constraint ^0.8.24 is used by:
		-[^0.8.24](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorSettings.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotesQuorumFraction.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Votes.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/utils/Strings.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol#L4)
		-[^0.8.24](lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L4)
	- Version constraint >=0.5.0 is used by:
		-[>=0.5.0](lib/openzeppelin-contracts/contracts/interfaces/IERC1271.sol#L4)
		-[>=0.5.0](lib/openzeppelin-contracts/contracts/interfaces/IERC7913.sol#L4)
		-[>=0.5.0](lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#L4)
	- Version constraint >=0.4.16 is used by:
		-[>=0.4.16](lib/openzeppelin-contracts/contracts/interfaces/IERC165.sol#L4)
		-[>=0.4.16](lib/openzeppelin-contracts/contracts/interfaces/IERC5267.sol#L4)
		-[>=0.4.16](lib/openzeppelin-contracts/contracts/interfaces/IERC6372.sol#L4)
		-[>=0.4.16](lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#L4)
		-[>=0.4.16](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#L4)
		-[>=0.4.16](lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol#L4)
	- Version constraint >=0.6.2 is used by:
		-[>=0.6.2](lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol#L4)
		-[>=0.6.2](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#L4)

lib/openzeppelin-contracts/contracts/access/AccessControl.sol#L4


## solc-version
Impact: Informational
Confidence: High
 - [ ] ID-98
Version constraint >=0.6.2 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- MissingSideEffectsOnSelectorAccess
	- AbiReencodingHeadOverflowWithStaticArrayCleanup
	- DirtyBytesArrayToStorage
	- NestedCalldataArrayAbiReencodingSizeValidation
	- ABIDecodeTwoDimensionalArrayMemory
	- KeccakCaching
	- EmptyByteArrayCopy
	- DynamicArrayCleanup
	- MissingEscapingInFormatting
	- ArraySliceDynamicallyEncodedBaseType
	- ImplicitConstructorCallvalueCheck
	- TupleAssignmentMultiStackSlotComponents
	- MemoryArrayCreationOverflow.
It is used by:
	- [>=0.6.2](lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol#L4)
	- [>=0.6.2](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#L4)

lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol#L4


 - [ ] ID-99
Version constraint >=0.4.16 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- DirtyBytesArrayToStorage
	- ABIDecodeTwoDimensionalArrayMemory
	- KeccakCaching
	- EmptyByteArrayCopy
	- DynamicArrayCleanup
	- ImplicitConstructorCallvalueCheck
	- TupleAssignmentMultiStackSlotComponents
	- MemoryArrayCreationOverflow
	- privateCanBeOverridden
	- SignedArrayStorageCopy
	- ABIEncoderV2StorageArrayWithMultiSlotElement
	- DynamicConstructorArgumentsClippedABIV2
	- UninitializedFunctionPointerInConstructor_0.4.x
	- IncorrectEventSignatureInLibraries_0.4.x
	- ExpExponentCleanup
	- NestedArrayFunctionCallDecoder
	- ZeroFunctionSelector.
It is used by:
	- [>=0.4.16](lib/openzeppelin-contracts/contracts/interfaces/IERC165.sol#L4)
	- [>=0.4.16](lib/openzeppelin-contracts/contracts/interfaces/IERC5267.sol#L4)
	- [>=0.4.16](lib/openzeppelin-contracts/contracts/interfaces/IERC6372.sol#L4)
	- [>=0.4.16](lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#L4)
	- [>=0.4.16](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#L4)
	- [>=0.4.16](lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol#L4)

lib/openzeppelin-contracts/contracts/interfaces/IERC165.sol#L4


 - [ ] ID-100
Version constraint >=0.5.0 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- DirtyBytesArrayToStorage
	- ABIDecodeTwoDimensionalArrayMemory
	- KeccakCaching
	- EmptyByteArrayCopy
	- DynamicArrayCleanup
	- ImplicitConstructorCallvalueCheck
	- TupleAssignmentMultiStackSlotComponents
	- MemoryArrayCreationOverflow
	- privateCanBeOverridden
	- SignedArrayStorageCopy
	- ABIEncoderV2StorageArrayWithMultiSlotElement
	- DynamicConstructorArgumentsClippedABIV2
	- UninitializedFunctionPointerInConstructor
	- IncorrectEventSignatureInLibraries
	- ABIEncoderV2PackedStorage.
It is used by:
	- [>=0.5.0](lib/openzeppelin-contracts/contracts/interfaces/IERC1271.sol#L4)
	- [>=0.5.0](lib/openzeppelin-contracts/contracts/interfaces/IERC7913.sol#L4)
	- [>=0.5.0](lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol#L4)

lib/openzeppelin-contracts/contracts/interfaces/IERC1271.sol#L4


 - [ ] ID-101
Version constraint >=0.8.4 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- FullInlinerNonExpressionSplitArgumentEvaluationOrder
	- MissingSideEffectsOnSelectorAccess
	- AbiReencodingHeadOverflowWithStaticArrayCleanup
	- DirtyBytesArrayToStorage
	- DataLocationChangeInInternalOverride
	- NestedCalldataArrayAbiReencodingSizeValidation
	- SignedImmutables.
It is used by:
	- [>=0.8.4](lib/openzeppelin-contracts/contracts/access/IAccessControl.sol#L4)
	- [>=0.8.4](lib/openzeppelin-contracts/contracts/governance/IGovernor.sol#L4)
	- [>=0.8.4](lib/openzeppelin-contracts/contracts/governance/utils/IVotes.sol#L4)
	- [>=0.8.4](lib/openzeppelin-contracts/contracts/interfaces/IERC5805.sol#L4)
	- [>=0.8.4](lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol#L4)

lib/openzeppelin-contracts/contracts/access/IAccessControl.sol#L4


 - [ ] ID-102
Version constraint ^0.8.20 contains known severe issues (https://solidity.readthedocs.io/en/latest/bugs.html)
	- VerbatimInvalidDeduplication
	- FullInlinerNonExpressionSplitArgumentEvaluationOrder
	- MissingSideEffectsOnSelectorAccess.
It is used by:
	- [^0.8.20](lib/openzeppelin-contracts/contracts/access/AccessControl.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC1155/utils/ERC1155Holder.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Holder.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/Address.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/Context.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/Errors.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/LowLevelCall.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/Nonces.sol#L3)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/Panic.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/StorageSlot.sol#L5)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol#L5)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/math/SignedMath.sol#L4)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/structs/Checkpoints.sol#L5)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/structs/DoubleEndedQueue.sol#L3)
	- [^0.8.20](lib/openzeppelin-contracts/contracts/utils/types/Time.sol#L4)
	- [^0.8.20](src/governance/GameGovernor.sol#L2)
	- [^0.8.20](src/governance/GameTimelock.sol#L2)
	- [^0.8.20](src/governance/GameToken.sol#L2)

lib/openzeppelin-contracts/contracts/access/AccessControl.sol#L4


## low-level-calls
Impact: Informational
Confidence: High
 - [ ] ID-103
Low level call in [Governor.relay(address,uint256,bytes)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L656-L659):
	- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L657)

lib/openzeppelin-contracts/contracts/governance/Governor.sol#L656-L659


 - [ ] ID-104
Low level call in [TimelockController._execute(address,uint256,bytes)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L410-L413):
	- [(success,returndata) = target.call{value: value}(data)](lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L411)

lib/openzeppelin-contracts/contracts/governance/TimelockController.sol#L410-L413


 - [ ] ID-105
Low level call in [SignatureChecker.isValidSignatureNow(bytes,bytes32,bytes)](lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L132-L149):
	- [(success,result) = address(bytes20(signer)).staticcall(abi.encodeCall(IERC7913SignatureVerifier.verify,(signer.slice(20),hash,signature)))](lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L142-L144)

lib/openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol#L132-L149


 - [ ] ID-106
Low level call in [Governor._executeOperations(uint256,address[],uint256[],bytes[],bytes32)](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L434-L445):
	- [(success,returndata) = targets[i].call{value: values[i]}(calldatas[i])](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L442)

lib/openzeppelin-contracts/contracts/governance/Governor.sol#L434-L445


## naming-convention
Impact: Informational
Confidence: High
 - [ ] ID-107
Function [GovernorVotes.CLOCK_MODE()](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol#L45-L51) is not in mixedCase

lib/openzeppelin-contracts/contracts/governance/extensions/GovernorVotes.sol#L45-L51


 - [ ] ID-108
Function [IERC6372.CLOCK_MODE()](lib/openzeppelin-contracts/contracts/interfaces/IERC6372.sol#L16) is not in mixedCase

lib/openzeppelin-contracts/contracts/interfaces/IERC6372.sol#L16


 - [ ] ID-109
Function [EIP712._EIP712Version()](lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol#L157-L159) is not in mixedCase

lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol#L157-L159


 - [ ] ID-110
Function [Governor.CLOCK_MODE()](lib/openzeppelin-contracts/contracts/governance/Governor.sol#L796) is not in mixedCase

lib/openzeppelin-contracts/contracts/governance/Governor.sol#L796


 - [ ] ID-111
Function [IERC20Permit.DOMAIN_SEPARATOR()](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#L89) is not in mixedCase

lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#L89


 - [ ] ID-112
Function [ERC20Permit.DOMAIN_SEPARATOR()](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#L74-L76) is not in mixedCase

lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Permit.sol#L74-L76


 - [ ] ID-113
Function [Votes.CLOCK_MODE()](lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#L67-L73) is not in mixedCase

lib/openzeppelin-contracts/contracts/governance/utils/Votes.sol#L67-L73


 - [ ] ID-114
Function [EIP712._EIP712Name()](lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol#L146-L148) is not in mixedCase

lib/openzeppelin-contracts/contracts/utils/cryptography/EIP712.sol#L146-L148


 - [ ] ID-115
Function [IGovernor.COUNTING_MODE()](lib/openzeppelin-contracts/contracts/governance/IGovernor.sol#L202) is not in mixedCase

lib/openzeppelin-contracts/contracts/governance/IGovernor.sol#L202


 - [ ] ID-116
Function [GovernorCountingSimple.COUNTING_MODE()](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol#L32-L34) is not in mixedCase

lib/openzeppelin-contracts/contracts/governance/extensions/GovernorCountingSimple.sol#L32-L34


## too-many-digits
Impact: Informational
Confidence: Medium
 - [ ] ID-117
[Bytes.reverseBytes16(bytes16)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L275-L286) uses literals with too many digits:
	- [value = ((value & 0xFFFFFFFF00000000FFFFFFFF00000000) >> 32) | ((value & 0x00000000FFFFFFFF00000000FFFFFFFF) << 32)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L282-L284)

lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L275-L286


 - [ ] ID-118
[Math.log2(uint256)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L619-L658) uses literals with too many digits:
	- [r = r | byte(uint256,uint256)(x >> r,0x0000010102020202030303030303030300000000000000000000000000000000)](lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L656)

lib/openzeppelin-contracts/contracts/utils/math/Math.sol#L619-L658


 - [ ] ID-119
[ShortStrings.slitherConstructorConstantVariables()](lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#L40-L122) uses literals with too many digits:
	- [FALLBACK_SENTINEL = 0x00000000000000000000000000000000000000000000000000000000000000FF](lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#L42)

lib/openzeppelin-contracts/contracts/utils/ShortStrings.sol#L40-L122


 - [ ] ID-120
[Bytes.reverseBytes32(bytes32)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L258-L272) uses literals with too many digits:
	- [value = ((value >> 32) & 0x00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF) | ((value & 0x00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF00000000FFFFFFFF) << 32)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L265-L267)

lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L258-L272


 - [ ] ID-121
[Bytes.toNibbles(bytes)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L210-L245) uses literals with too many digits:
	- [chunk_toNibbles_asm_0 = 0x0000000000000000ffffffffffffffff0000000000000000ffffffffffffffff & chunk_toNibbles_asm_0 << 64 | chunk_toNibbles_asm_0](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L222-L225)

lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L210-L245


 - [ ] ID-122
[Bytes.toNibbles(bytes)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L210-L245) uses literals with too many digits:
	- [chunk_toNibbles_asm_0 = 0x00000000ffffffff00000000ffffffff00000000ffffffff00000000ffffffff & chunk_toNibbles_asm_0 << 32 | chunk_toNibbles_asm_0](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L226-L229)

lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L210-L245


 - [ ] ID-123
[Bytes.reverseBytes32(bytes32)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L258-L272) uses literals with too many digits:
	- [value = ((value >> 64) & 0x0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF) | ((value & 0x0000000000000000FFFFFFFFFFFFFFFF0000000000000000FFFFFFFFFFFFFFFF) << 64)](lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L268-L270)

lib/openzeppelin-contracts/contracts/utils/Bytes.sol#L258-L272


## unindexed-event-address
Impact: Informational
Confidence: High
 - [ ] ID-124
Event [GovernorTimelockControl.TimelockChange(address,address)](lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#L31) has address parameters but no indexed parameters

lib/openzeppelin-contracts/contracts/governance/extensions/GovernorTimelockControl.sol#L31


 - [ ] ID-125
Event [IGovernor.ProposalCreated(uint256,address,address[],uint256[],string[],bytes[],uint256,uint256,string)](lib/openzeppelin-contracts/contracts/governance/IGovernor.sol#L118-L128) has address parameters but no indexed parameters

lib/openzeppelin-contracts/contracts/governance/IGovernor.sol#L118-L128


