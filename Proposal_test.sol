// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "remix_tests.sol";
import "./Proposal.sol";
import "remix_accounts.sol";

contract ProposalContractTest {
  ProposalContract proposalContract;
  address testAccount1;

  function beforeEach() public {
    proposalContract = new ProposalContract();
    testAccount1 = TestsAccounts.getAccount(1);
  }

  function testCreateProposal() public {
    proposalContract.create("Test Proposal Title", "Test Proposal Description", 10);
    ProposalContract.Proposal memory proposal = proposalContract.getCurrentProposal();
    Assert.equal(proposal.description, "Test Proposal Description", "Proposal description should match");
    Assert.equal(proposal.total_vote_to_end, 10, "Total votes to end should match");
  }

  function testTerminateProposal() public {
    proposalContract.create("Test Proposal Title", "Test Proposal Description", 10);
    proposalContract.teminateProposal();
    ProposalContract.Proposal memory proposal = proposalContract.getCurrentProposal();
    Assert.equal(proposal.is_active, false, "Proposal should be terminated");
  }

  function testGetProposal() public {
    proposalContract.create("First Proposal Title", "First Proposal Description", 1);
    proposalContract.create("Second Proposal Title", "Second Proposal Description", 2);
    ProposalContract.Proposal memory firstProposal = proposalContract.getProposal(1);
    ProposalContract.Proposal memory secondProposal = proposalContract.getProposal(2);
    Assert.equal(firstProposal.description, "First Proposal Description", "First proposal should be retrievable");
    Assert.equal(secondProposal.description, "Second Proposal Description", "Second proposal should be retrievable");
  }

  function testIsVoteOwner() public {
    proposalContract.create("Test Proposal Title", "Test Proposal Description", 10);
    Assert.equal(proposalContract.isVoted(address(this)), true, "Address should be marked as voted");
  }
  
  function testIsVoteNonowner() public {
    proposalContract.create("Test Proposal Title", "Test Proposal Description", 10);
    Assert.equal(proposalContract.isVoted(testAccount1), false, "Address should not be marked as voted");
  }

  function testChangeOwner() public {
    address newOwner = address(0xA17a7963c07DF001D349fEfd7F4277436657DDF4);
    proposalContract.setOwner(newOwner);

    address currentOwner = proposalContract.getOwner();

    Assert.equal(currentOwner, newOwner, "Owner should be the same");
  }

  function testVote() public {
    proposalContract.create("Test Proposal Title", "Test Proposal Description", 10);
    ProposalContract.Proposal memory proposal = proposalContract.getCurrentProposal();
    Assert.equal(proposal.approve, 0, "Approve count should be by non-owner");
  }
}