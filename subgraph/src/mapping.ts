import { BigInt } from "@graphprotocol/graph-ts"
import {
  ProposalCreated,
  VoteCast,
  ProposalQueued as ProposalQueuedEvent,
  ProposalExecuted as ProposalExecutedEvent
} from "../generated/GameGovernor/GameGovernor"
import { Proposal, Vote, ProposalQueued, ProposalExecuted } from "../generated/schema"

export function handleProposalCreated(event: ProposalCreated): void {
  let proposal = new Proposal(event.params.proposalId.toString())
  proposal.proposalId = event.params.proposalId
  proposal.proposer = event.params.proposer
  proposal.description = event.params.description
  proposal.startBlock = event.params.voteStart
  proposal.endBlock = event.params.voteEnd
  proposal.status = "Pending"
  proposal.forVotes = BigInt.fromI32(0)
  proposal.againstVotes = BigInt.fromI32(0)
  proposal.abstainVotes = BigInt.fromI32(0)
  proposal.createdAt = event.block.timestamp
  proposal.save()
}

export function handleVoteCast(event: VoteCast): void {
  let voteId = event.transaction.hash.toHex() + "-" + event.logIndex.toString()
  let vote = new Vote(voteId)
  vote.proposal = event.params.proposalId.toString()
  vote.voter = event.params.voter
  vote.support = event.params.support
  vote.weight = event.params.weight
  vote.reason = event.params.reason
  vote.timestamp = event.block.timestamp
  vote.save()

  let proposal = Proposal.load(event.params.proposalId.toString())
  if (proposal) {
    if (event.params.support == 1) {
      proposal.forVotes = proposal.forVotes.plus(event.params.weight)
    } else if (event.params.support == 0) {
      proposal.againstVotes = proposal.againstVotes.plus(event.params.weight)
    } else {
      proposal.abstainVotes = proposal.abstainVotes.plus(event.params.weight)
    }
    proposal.status = "Active"
    proposal.save()
  }
}

export function handleProposalQueued(event: ProposalQueuedEvent): void {
  let entity = new ProposalQueued(event.params.proposalId.toString())
  entity.proposalId = event.params.proposalId
  entity.eta = event.params.etaSeconds
  entity.save()

  let proposal = Proposal.load(event.params.proposalId.toString())
  if (proposal) {
    proposal.status = "Queued"
    proposal.queuedAt = event.block.timestamp
    proposal.save()
  }
}

export function handleProposalExecuted(event: ProposalExecutedEvent): void {
  let entity = new ProposalExecuted(event.params.proposalId.toString())
  entity.proposalId = event.params.proposalId
  entity.timestamp = event.block.timestamp
  entity.save()

  let proposal = Proposal.load(event.params.proposalId.toString())
  if (proposal) {
    proposal.status = "Executed"
    proposal.executedAt = event.block.timestamp
    proposal.save()
  }
}
